import UIKit
import HotwireNative

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configureHotwire()
        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // MARK: - Hotwire Configuration

    private func configureHotwire() {
        // User agent substring that triggers turbo_native_app? in Rails
        Hotwire.config.userAgent = "Turbo Native iOS"

        // Path configuration: local fallback + remote server
        Hotwire.config.pathConfiguration.matchQueryStrings = false

        // Load bundled path configuration as fallback
        if let localURL = Bundle.main.url(forResource: "path-configuration", withExtension: "json") {
            Hotwire.config.pathConfiguration.sources = [
                .file(localURL),
                .server(Server.pathConfigurationURL)
            ]
        } else {
            Hotwire.config.pathConfiguration.sources = [
                .server(Server.pathConfigurationURL)
            ]
        }

        #if DEBUG
        Hotwire.config.debugLoggingEnabled = true
        #endif
    }
}
