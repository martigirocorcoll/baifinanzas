class NativeController < ApplicationController
  skip_before_action :authenticate_user!

  def config
    render json: {
      min_version: "1.0.0",
      current_version: "1.0.0",
      force_update: false,
      features: {
        calculators: true,
        discovery: true,
        objectives: true,
        onboarding: true
      },
      urls: {
        privacy: privacy_url,
        terms: terms_url
      }
    }
  end

  def tabs
    render json: {
      tabs: [
        {
          title: t("navigation.bottom_nav.home", default: "Inicio"),
          path: home_path,
          icon: "house",
          icon_active: "house.fill"
        },
        {
          title: t("navigation.bottom_nav.discovery", default: "Discovery"),
          path: discovery_path,
          icon: "play.circle",
          icon_active: "play.circle.fill"
        },
        {
          title: t("navigation.bottom_nav.calculators", default: "Calculadoras"),
          path: calculators_path,
          icon: "function",
          icon_active: "function"
        },
        {
          title: t("navigation.bottom_nav.profile", default: "Perfil"),
          path: profile_path,
          icon: "person",
          icon_active: "person.fill"
        }
      ]
    }
  end
end
