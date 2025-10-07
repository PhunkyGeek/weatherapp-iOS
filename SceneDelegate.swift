import UIKit

/// The scene delegate sets up the window and initial view controller
/// for the application.  It shows a simple splash screen on launch
/// and transitions to the main tab bar controller after a short delay.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let splashVC = SplashViewController()
        window.rootViewController = splashVC
        self.window = window
        window.makeKeyAndVisible()
    }
}