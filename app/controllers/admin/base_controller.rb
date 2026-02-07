module Admin
  class BaseController < ApplicationController
    layout "admin"

    before_action :require_admin!

    private

    def require_admin!
      unless current_user&.admin?
        redirect_to root_path, alert: "No tienes permisos para acceder a esta pagina."
      end
    end
  end
end
