import UIKit
import WebKit
import HotwireNative

// Receives messages from injected JS to show/hide the tab bar
class TabBarBridge: NSObject, WKScriptMessageHandler {
    static let shared = TabBarBridge()
    static let show = Notification.Name("ShowTabBar")
    static let hide = Notification.Name("HideTabBar")

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let msg = message.body as? String else { return }
        NotificationCenter.default.post(name: msg == "show" ? Self.show : Self.hide, object: nil)
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configureHotwire()
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    private func configureHotwire() {
        Hotwire.config.applicationUserAgentPrefix = "Turbo Native iOS"
        Hotwire.config.pathConfiguration.matchQueryStrings = false

        if let localURL = Bundle.main.url(forResource: "path-configuration", withExtension: "json") {
            Hotwire.loadPathConfiguration(from: [
                .file(localURL),
                .server(Server.pathConfigurationURL)
            ])
        } else {
            Hotwire.loadPathConfiguration(from: [
                .server(Server.pathConfigurationURL)
            ])
        }

        // Inject a script that tells the native app whether to show/hide tabs
        Hotwire.config.makeCustomWebView = { configuration in
            // Ensure persistent cookie storage across app launches
            configuration.websiteDataStore = .default()

            let script = WKUserScript(
                source: """
                    function notifyTabBar() {
                        var h = window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.tabBar;
                        if (!h) return;
                        var p = window.location.pathname;
                        var isAuth = (p.indexOf('sign_in') === -1 && p.indexOf('sign_up') === -1 && p.indexOf('password') === -1);
                        h.postMessage(isAuth ? 'show' : 'hide');
                    }
                    notifyTabBar();
                    document.addEventListener('turbo:load', notifyTabBar);
                """,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: true
            )
            configuration.userContentController.addUserScript(script)
            configuration.userContentController.add(TabBarBridge.shared, name: "tabBar")
            return WKWebView(frame: .zero, configuration: configuration)
        }

        #if DEBUG
        Hotwire.config.debugLoggingEnabled = true
        #endif
    }
}
