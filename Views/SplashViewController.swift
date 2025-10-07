import UIKit

/// A simple splash screen displayed when the app launches.  It shows
/// an icon and transitions to the main tab bar after a delay.  The
/// delay simulates loading time and provides a brief branding
/// opportunity.
class SplashViewController: UIViewController {
    private let imageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "sun.max.fill"))
        iv.tintColor = .systemBlue
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Weatherly"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // After a short delay show the main tab bar controller loaded
        // from the storyboard.  Loading from the storyboard ensures
        // that the UI is defined in Interface Builder as required by
        // the assignment.  The initial view controller of
        // `Main.storyboard` is a UITabBarController with four tabs.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            // Instantiate the initial view controller from the
            // storyboard.  It is of type `UITabBarController`.
            guard let tabBarController = storyboard.instantiateInitialViewController() else {
                // Fallback: if the storyboard cannot be loaded, use the
                // programmatic tab bar controller as a backup.  This
                // should not occur in normal operation.
                self.view.window?.rootViewController = MainTabBarController()
                return
            }
            self.view.window?.rootViewController = tabBarController
        }
    }
}