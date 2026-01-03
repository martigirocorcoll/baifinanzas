class LocalesController < ApplicationController
  skip_before_action :authenticate_user!

  def update
    new_locale = params[:new_locale]

    if I18n.available_locales.map(&:to_s).include?(new_locale)
      session[:locale] = new_locale

      # Redirect back to the same page but with new locale
      if request.referer.present?
        uri = URI.parse(request.referer)
        path = uri.path

        # Handle different path patterns:
        # /es or /en (root with locale)
        # /es/ or /en/ (root with locale and trailing slash)
        # /es/dashboard or /en/dashboard (locale with path)
        if path =~ %r{^/(es|en)(/.*)?$}
          # Replace the locale, keeping the rest of the path
          rest_of_path = $2 || ''
          new_path = "/#{new_locale}#{rest_of_path}"
        else
          # No locale in path, just prepend the new locale
          new_path = "/#{new_locale}#{path}"
        end

        # Build the redirect URL
        port_part = (uri.port && uri.port != 80 && uri.port != 443) ? ":#{uri.port}" : ""
        redirect_path = "#{uri.scheme}://#{uri.host}#{port_part}#{new_path}"
      else
        redirect_path = root_path(locale: new_locale)
      end

      redirect_to redirect_path, allow_other_host: false
    else
      redirect_to root_path(locale: I18n.default_locale)
    end
  end
end
