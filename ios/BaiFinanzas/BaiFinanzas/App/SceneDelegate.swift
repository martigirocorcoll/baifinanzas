import UIKit
import HotwireNative

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var tabBarController: UITabBarController!
    private var navigators: [Navigator] = []

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)
        tabBarController = UITabBarController()

        configureTabBar()
        configureNavigators()

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
    }

    private func configureNavigators() {
        let tabs: [(title: String, icon: String, iconActive: String, path: String)] = [
            ("Inicio",        "house",       "house.fill",       "/es/home"),
            ("Discovery",     "play.circle", "play.circle.fill", "/es/discovery"),
            ("Calculadoras",  "function",    "function",         "/es/calculators"),
            ("Perfil",        "person",      "person.fill",      "/es/profile")
        ]

        var viewControllers: [UIViewController] = []

        for (index, tab) in tabs.enumerated() {
            let navigator = Navigator()
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

            // Visit the tab's root URL
            let url = Server.url(path: tab.path)
            navigator.route(url)
        }

        tabBarController.viewControllers = viewControllers
    }
}

// MARK: - NavigatorDelegate

extension SceneDelegate: NavigatorDelegate {

    func handle(proposal: VisitProposal) -> ProposalResult {
        let url = proposal.url

        // Handle sign-out: reload the first tab (home -> will redirect to sign_in)
        if url.path.contains("/sign_out") {
            for (index, navigator) in navigators.enumerated() {
                let tabPath = ["/es/home", "/es/discovery", "/es/calculators", "/es/profile"][index]
                if index == 0 {
                    navigator.route(Server.url(path: tabPath))
                } else {
                    navigator.clearAll()
                    navigator.route(Server.url(path: tabPath))
                }
            }
            tabBarController.selectedIndex = 0
            return .reject
        }

        // Check if URL matches a tab root - switch tab instead of pushing
        let tabPaths = ["/home", "/discovery", "/calculators", "/profile"]
        for (index, tabPath) in tabPaths.enumerated() {
            if url.path.hasSuffix(tabPath) && !url.path.contains("/calculators/") {
                tabBarController.selectedIndex = index
                return .reject
            }
        }

        return .accept
    }
}
