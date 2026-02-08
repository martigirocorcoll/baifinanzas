import UIKit
import HotwireNative
import SafariServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var tabBarController: UITabBarController!
    private var navigators: [Navigator] = []
    private var tabStarted: [Bool] = []
    private var isAuthenticated = false

    private let tabConfigs: [(title: String, icon: String, iconActive: String, path: String)] = [
        ("Inicio",        "house",       "house.fill",       "/es/home"),
        ("Discovery",     "play.circle", "play.circle.fill", "/es/discovery"),
        ("Calculadoras",  "function",    "function",         "/es/calculators"),
        ("Perfil",        "person",      "person.fill",      "/es/profile")
    ]

    private let tabPaths = ["/home", "/discovery", "/calculators", "/profile"]

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = UIColor(red: 22/255, green: 86/255, blue: 104/255, alpha: 1) // #165668
        tabBarController = UITabBarController()
        tabBarController.delegate = self

        configureTabBar()
        configureNavigators()

        // Listen for show/hide tab bar from the JS bridge
        NotificationCenter.default.addObserver(forName: TabBarBridge.show, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            let wasAuthenticated = self.isAuthenticated
            self.isAuthenticated = true
            self.tabBarController.tabBar.isHidden = false

            // First authentication: remove sign-in page from navigation stack
            if !wasAuthenticated {
                let nav = self.navigators[0].rootViewController
                if nav.viewControllers.count > 1, let top = nav.viewControllers.last {
                    nav.setViewControllers([top], animated: false)
                }
            }
        }
        NotificationCenter.default.addObserver(forName: TabBarBridge.hide, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.isAuthenticated = false
            self.tabBarController.tabBar.isHidden = true
        }

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    // MARK: - Tab Bar

    private func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground

        let teal = UIColor(red: 22/255, green: 86/255, blue: 104/255, alpha: 1) // #165668
        tabBarController.tabBar.tintColor = teal
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance

        // Navigation bar: teal background, white text/buttons
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = teal
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navAppearance.shadowColor = .clear

        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().tintColor = .white // back button color
    }

    private func configureNavigators() {
        var viewControllers: [UIViewController] = []
        tabStarted = Array(repeating: false, count: tabConfigs.count)

        for (index, tab) in tabConfigs.enumerated() {
            let url = Server.url(path: tab.path)
            let navigator = Navigator(configuration: .init(
                name: "tab-\(index)",
                startLocation: url
            ))
            navigator.delegate = self
            navigators.append(navigator)

            let navController = navigator.rootViewController
            navController.tabBarItem = UITabBarItem(
                title: tab.title,
                image: UIImage(systemName: tab.icon),
                selectedImage: UIImage(systemName: tab.iconActive)
            )
            navController.tabBarItem.tag = index

            viewControllers.append(navController)
        }

        // Only start the first tab
        navigators[0].start()
        tabStarted[0] = true

        tabBarController.viewControllers = viewControllers

        // Hidden until JS bridge says "show"
        tabBarController.tabBar.isHidden = true
    }

    private func ensureTabStarted(_ index: Int) {
        guard index < tabStarted.count, !tabStarted[index] else { return }
        navigators[index].start()
        tabStarted[index] = true
    }
}

// MARK: - UITabBarControllerDelegate

extension SceneDelegate: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if !isAuthenticated && viewController.tabBarItem.tag != 0 { return false }
        return true
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        ensureTabStarted(tabBarController.selectedIndex)
    }
}

// MARK: - NavigatorDelegate

extension SceneDelegate: NavigatorDelegate {

    func handle(proposal: VisitProposal) -> ProposalResult {
        let path = proposal.url.path

        // Sign-out: reset tabs
        if path.contains("/sign_out") {
            isAuthenticated = false
            tabBarController.tabBar.isHidden = true
            tabStarted = Array(repeating: false, count: tabConfigs.count)
            navigators[0].start()
            tabStarted[0] = true
            tabBarController.selectedIndex = 0
            return .reject
        }

        // External links: open in in-app browser (SFSafariViewController)
        if proposal.url.host != Server.baseURL.host {
            let safari = SFSafariViewController(url: proposal.url)
            tabBarController.selectedViewController?.present(safari, animated: true)
            return .reject
        }

        // Before auth: let everything through (sign-in flow)
        if !isAuthenticated {
            return .accept
        }

        // After auth: switch tabs only for cross-tab navigation
        for (index, tabPath) in tabPaths.enumerated() {
            if path.hasSuffix(tabPath) && !path.contains("/calculators/") {
                if index != tabBarController.selectedIndex {
                    // Cross-tab: switch to that tab
                    ensureTabStarted(index)
                    tabBarController.selectedIndex = index
                    return .reject
                }
                // Same tab: let path config handle it (e.g. replace_root for /home)
                return .accept
            }
        }

        return .accept
    }
}
