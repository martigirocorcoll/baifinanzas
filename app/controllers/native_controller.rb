class NativeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_around_action :switch_locale

  def app_config
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
        privacy: privacy_url(locale: :es),
        terms: terms_url(locale: :es)
      }
    }
  end

  def path_configuration
    render json: {
      settings: {
        screenshots_enabled: true
      },
      rules: [
        {
          patterns: ["/.*"],
          properties: {
            context: "default",
            pull_to_refresh_enabled: true
          }
        },
        {
          patterns: ["/home$"],
          properties: {
            context: "default",
            presentation: "replace_root",
            pull_to_refresh_enabled: true
          }
        },
        {
          patterns: ["/discovery/articles/.*"],
          properties: {
            context: "modal",
            pull_to_refresh_enabled: false
          }
        },
        {
          patterns: ["/profile/settings"],
          properties: {
            context: "modal",
            pull_to_refresh_enabled: false
          }
        },
        {
          patterns: ["/plan$"],
          properties: {
            context: "default",
            presentation: "replace_root",
            pull_to_refresh_enabled: true
          }
        },
        {
          patterns: ["/plan/level-guide"],
          properties: {
            context: "modal",
            pull_to_refresh_enabled: false
          }
        },
        {
          patterns: ["/new$", "/edit$"],
          properties: {
            context: "modal",
            pull_to_refresh_enabled: false
          }
        },
        {
          patterns: ["/calculators/.*"],
          properties: {
            context: "default",
            pull_to_refresh_enabled: false
          }
        },
        {
          patterns: ["/onboarding/.*"],
          properties: {
            context: "default",
            pull_to_refresh_enabled: false
          }
        },
        {
          patterns: ["/users/sign_in", "/users/sign_up"],
          properties: {
            context: "default",
            pull_to_refresh_enabled: false
          }
        },
        {
          patterns: ["/objectives/new", "/objectives/\\d+/edit", "/objectives/\\d+/update_progress"],
          properties: {
            context: "modal",
            pull_to_refresh_enabled: false
          }
        }
      ]
    }
  end

  def tabs
    render json: {
      tabs: [
        {
          title: t("navigation.bottom_nav.objetivo", default: "Objetivo"),
          path: home_path,
          icon: "scope",
          icon_active: "scope"
        },
        {
          title: t("navigation.bottom_nav.plan", default: "Plan"),
          path: plan_path,
          icon: "list.bullet",
          icon_active: "list.bullet"
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
        }
      ]
    }
  end
end
