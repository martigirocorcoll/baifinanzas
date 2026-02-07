class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :privacy, :terms ]

  def home
  end

  def privacy
  end

  def terms
  end
end
