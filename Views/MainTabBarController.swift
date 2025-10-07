import UIKit

/// The application's main tab bar controller.  It contains four tabs
/// corresponding to the home, favourites, map and settings screens.
class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {
        // Home
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        // Favourites
        let favVC = UINavigationController(rootViewController: FavoritesViewController())
        favVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.fill"), tag: 1)
        // Map
        let mapVC = UINavigationController(rootViewController: MapViewController())
        mapVC.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map.fill"), tag: 2)
        // Settings
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill"), tag: 3)

        viewControllers = [homeVC, favVC, mapVC, settingsVC]
    }
}