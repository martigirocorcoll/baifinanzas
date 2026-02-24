# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_02_23_091611) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_news", force: :cascade do |t|
    t.string "title", null: false
    t.text "content"
    t.datetime "published_at"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_app_news_on_active"
    t.index ["published_at"], name: "index_app_news_on_published_at"
  end

  create_table "articles", force: :cascade do |t|
    t.string "slug", null: false
    t.string "title", null: false
    t.text "excerpt"
    t.text "body"
    t.string "category"
    t.integer "read_time", default: 5
    t.string "author", default: "BaiFinanzas"
    t.datetime "published_at"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_articles_on_active"
    t.index ["category"], name: "index_articles_on_category"
    t.index ["published_at"], name: "index_articles_on_published_at"
    t.index ["slug"], name: "index_articles_on_slug", unique: true
  end

  create_table "balances", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "valor_inmuebles"
    t.integer "dinero_cuenta_corriente"
    t.integer "dinero_cuenta_ahorro_depos"
    t.integer "dinero_inversiones_f"
    t.integer "dinero_planes_pensiones"
    t.integer "valor_coches_vehiculos"
    t.integer "valor_otros_activos"
    t.integer "hipoteca_inmuebles"
    t.integer "deuda_tarjeta_credito"
    t.integer "prestamos_personales"
    t.integer "prestamos_coches"
    t.integer "otras_deudas"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_balances_on_user_id", unique: true
  end

  create_table "influencers", force: :cascade do |t|
    t.string "name"
    t.string "ac_compte"
    t.string "ac_cdiposit"
    t.string "ac_curt"
    t.string "ac_llarg"
    t.string "ac_deute"
    t.string "ac_jubil"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ac_fiscal"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "code"
    t.string "video_compte"
    t.string "video_cdiposit"
    t.string "video_curt"
    t.string "video_llarg"
    t.string "video_deute"
    t.string "video_jubil"
    t.string "video_fiscal"
    t.string "video_portfolio"
    t.boolean "default", default: false, null: false
    t.string "ac_portfolio"
    t.string "ac_saving"
    t.string "ac_mortgage"
    t.string "video_saving"
    t.string "video_mortgage"
    t.string "video_diposit"
    t.bigint "user_id"
    t.string "youtube_channel_id"
    t.index ["ac_compte"], name: "index_influencers_on_ac_compte"
    t.index ["code"], name: "index_influencers_on_code", unique: true
    t.index ["default"], name: "index_influencers_on_default"
    t.index ["email"], name: "index_influencers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_influencers_on_reset_password_token", unique: true
    t.index ["user_id"], name: "index_influencers_on_user_id", unique: true
  end

  create_table "objectives", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.text "description"
    t.integer "target_amount"
    t.date "target_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "current_amount", default: 0, null: false
    t.index ["user_id"], name: "index_objectives_on_user_id"
  end

  create_table "pygs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "ingresos_mensual"
    t.integer "gasto_compra"
    t.integer "alquiler_hipoteca"
    t.integer "gastos_utilities"
    t.integer "gastos_seguros"
    t.integer "gastos_transporte"
    t.integer "restaurantes_y_ocio"
    t.integer "cuota_hipoteca"
    t.integer "cuota_coche"
    t.integer "otras_cuotas"
    t.integer "suscripciones"
    t.integer "cuidado_personal"
    t.integer "otros_gastos"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_pygs_on_user_id", unique: true
  end

  create_table "user_actions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "action_type"
    t.string "action_key"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_actions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "country"
    t.integer "risk_profile"
    t.bigint "influencer_id"
    t.bigint "pyg_id"
    t.bigint "balance_id"
    t.string "role", default: "user", null: false
    t.boolean "pyg_completed", default: false, null: false
    t.boolean "balance_completed", default: false, null: false
    t.index ["balance_id"], name: "index_users_on_balance_id", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["influencer_id"], name: "index_users_on_influencer_id"
    t.index ["pyg_id"], name: "index_users_on_pyg_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  create_table "youtube_videos", force: :cascade do |t|
    t.string "youtube_video_id", null: false
    t.bigint "influencer_id", null: false
    t.string "title", null: false
    t.string "thumbnail_url"
    t.string "channel_title"
    t.integer "duration_seconds", default: 0
    t.datetime "published_at"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["influencer_id", "published_at"], name: "index_youtube_videos_on_influencer_id_and_published_at"
    t.index ["influencer_id"], name: "index_youtube_videos_on_influencer_id"
    t.index ["youtube_video_id"], name: "index_youtube_videos_on_youtube_video_id", unique: true
  end

  add_foreign_key "balances", "users"
  add_foreign_key "objectives", "users"
  add_foreign_key "pygs", "users"
  add_foreign_key "user_actions", "users"
  add_foreign_key "users", "balances"
  add_foreign_key "users", "influencers"
  add_foreign_key "users", "pygs"
  add_foreign_key "youtube_videos", "influencers"
end
