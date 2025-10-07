import UIKit

/// Displays detailed weather information for a given city.  This
/// controller can be used if the app navigates to a detail screen
/// instead of showing the weather on the home card.  Currently it is
/// not used but remains here to illustrate MVVM patterns and
/// potential expansion.
class WeatherDetailViewController: UIViewController {
    var city: String?
    private let viewModel = WeatherViewModel(repository: AppContainer.shared.weatherRepository)

    private let descriptionLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let cityLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = city ?? "Weather"
        setupViews()
        setupBindings()
        if let city = city {
            let settingsViewModel = SettingsViewModel()
            let units = settingsViewModel.isMetricUnits ? "metric" : "imperial"
            viewModel.fetchWeather(for: city, units: units)
        }
    }

    private func setupViews() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.font = UIFont.systemFont(ofSize: 20)
        temperatureLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        cityLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)

        let stack = UIStackView(arrangedSubviews: [cityLabel, temperatureLabel, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupBindings() {
        viewModel.onUpdate = { [weak self] info in
            guard let info = info else { return }
            self?.temperatureLabel.text = "\(Int(info.temperature))°"
            self?.descriptionLabel.text = info.description.capitalized
            self?.cityLabel.text = info.cityName
        }
        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}