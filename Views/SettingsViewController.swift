import UIKit

/// Displays application settings allowing the user to switch between
/// light and dark mode, select temperature units, enable or disable
/// notifications and clear saved favourites.  The theme switch
/// immediately updates the app's appearance by overriding the
/// window’s interface style.
class SettingsViewController: UIViewController {
    private let viewModel = SettingsViewModel()
    private let themeSwitch = UISwitch()
    private let unitsSwitch = UISwitch()
    private let notificationsSwitch = UISwitch()
    private let clearButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load current preference states
        themeSwitch.isOn = viewModel.darkTheme
        unitsSwitch.isOn = viewModel.isMetricUnits
        notificationsSwitch.isOn = viewModel.notificationsEnabled
        applyTheme()
    }

    private func setupViews() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        // Appearance section
        let appearanceLabel = sectionLabel(text: "Appearance")
        let themeRow = row(title: "Theme", subtitle: "Choose between light and dark mode", control: themeSwitch)
        themeSwitch.addTarget(self, action: #selector(themeChanged), for: .valueChanged)

        // Units section
        let unitsLabel = sectionLabel(text: "Units")
        let unitsRow = row(title: "Temperature", subtitle: unitsSwitch.isOn ? "Celsius" : "Fahrenheit", control: unitsSwitch)
        unitsSwitch.addTarget(self, action: #selector(unitsChanged), for: .valueChanged)

        // Notifications section
        let notificationsLabel = sectionLabel(text: "Notifications")
        let notificationsRow = row(title: "Weather Alerts", subtitle: "Receive alerts for your favorite locations", control: notificationsSwitch)
        notificationsSwitch.addTarget(self, action: #selector(notificationsChanged), for: .valueChanged)

        // Data management section
        let dataLabel = sectionLabel(text: "Data Management")
        clearButton.setTitle("Clear Saved Data", for: .normal)
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        clearButton.setTitleColor(.systemBlue, for: .normal)
        clearButton.contentHorizontalAlignment = .left

        // Feedback placeholder
        let feedbackLabel = sectionLabel(text: "Feedback")
        let feedbackButton = UIButton(type: .system)
        feedbackButton.setTitle("Provide Feedback", for: .normal)
        feedbackButton.setTitleColor(.systemBlue, for: .normal)
        feedbackButton.contentHorizontalAlignment = .left

        // Add arranged subviews
        [appearanceLabel, themeRow,
         unitsLabel, unitsRow,
         notificationsLabel, notificationsRow,
         dataLabel, clearButton,
         feedbackLabel, feedbackButton].forEach { stack.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func sectionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }

    private func row(title: String, subtitle: String, control: UISwitch) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        let labels = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        labels.axis = .vertical
        labels.spacing = 2
        let row = UIStackView(arrangedSubviews: [labels, control])
        row.axis = .horizontal
        row.spacing = 8
        row.alignment = .center
        return row
    }

    @objc private func themeChanged() {
        viewModel.darkTheme = themeSwitch.isOn
        applyTheme()
    }

    private func applyTheme() {
        // Override the interface style on the window to apply the chosen theme.
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.overrideUserInterfaceStyle = viewModel.darkTheme ? .dark : .light
        }
    }

    @objc private func unitsChanged() {
        viewModel.isMetricUnits = unitsSwitch.isOn
    }

    @objc private func notificationsChanged() {
        viewModel.notificationsEnabled = notificationsSwitch.isOn
    }

    @objc private func clearTapped() {
        viewModel.clearSavedData()
        let alert = UIAlertController(title: "Data Cleared", message: "Your saved favourites have been removed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}