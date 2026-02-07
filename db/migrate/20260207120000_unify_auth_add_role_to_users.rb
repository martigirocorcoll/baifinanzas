class UnifyAuthAddRoleToUsers < ActiveRecord::Migration[7.2]
  def up
    # Add role to users
    add_column :users, :role, :string, default: "user", null: false
    add_index :users, :role

    # Add user_id to influencers (links influencer profile to user account)
    add_column :influencers, :user_id, :bigint
    add_index :influencers, :user_id, unique: true

    # Migrate existing admin boolean to role
    execute <<-SQL
      UPDATE users SET role = 'admin' WHERE admin = true;
    SQL

    # Create User accounts for existing Influencers
    # and link them via user_id
    Influencer.reset_column_information
    User.reset_column_information

    Influencer.find_each do |inf|
      # Check if a user with this email already exists
      existing_user = User.find_by(email: inf.email)

      if existing_user
        # User already exists with same email - just link and set role
        existing_user.update_columns(role: "influencer")
        inf.update_columns(user_id: existing_user.id)
      else
        # Create new user with influencer role
        user = User.new(
          email: inf.email,
          password: inf.encrypted_password,
          role: "influencer"
        )
        # Use encrypted_password directly to preserve the existing password
        user.save(validate: false)
        user.update_columns(encrypted_password: inf.encrypted_password)
        inf.update_columns(user_id: user.id)
      end
    end

    # Remove admin boolean (replaced by role)
    remove_column :users, :admin
  end

  def down
    add_column :users, :admin, :boolean, default: false, null: false

    execute <<-SQL
      UPDATE users SET admin = true WHERE role = 'admin';
    SQL

    remove_column :influencers, :user_id
    remove_index :users, :role, if_exists: true
    remove_column :users, :role
  end
end
