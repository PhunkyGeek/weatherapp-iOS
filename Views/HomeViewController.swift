import UIKit

/// Displays the home screen where users can search for a city and view
/// the current weather.  It also allows saving the city as a
/// favourite and navigating to the favourites screen.
class HomeViewController: UIViewController {
    private let viewModel = HomeViewModel(repository: AppContainer.shared.weatherRepository)
    private let settingsViewModel = SettingsViewModel()

    private let cityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search for a city"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let getWeatherButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Weather", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let weatherCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let saveFavoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save as Favorite", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let favoritesCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Weather"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingsTapped))
        setupViews()
        setupBindings()
        prepopulateFavoriteCity()
    }

    private func setupViews() {
        view.addSubview(cityTextField)
        view.addSubview(getWeatherButton)
        view.addSubview(weatherCardView)
        view.addSubview(favoritesCardView)

        // Weather card subviews
        [temperatureLabel, descriptionLabel, cityNameLabel, saveFavoriteButton].forEach {
            weatherCardView.addSubview($0)
        }
        // Favorites card subviews
        let favIcon = UIImageView(image: UIImage(systemName: "heart.fill"))
        favIcon.tintColor = .systemBlue
        favIcon.translatesAutoresizingMaskIntoConstraints = false
        let favTitle = UILabel()
        favTitle.text = "My Favorite Cities"
        favTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        favTitle.translatesAutoresizingMaskIntoConstraints = false
        let favSubtitle = UILabel()
        favSubtitle.text = "View and manage your saved locations"
        favSubtitle.font = UIFont.systemFont(ofSize: 14)
        favSubtitle.textColor = .secondaryLabel
        favSubtitle.translatesAutoresizingMaskIntoConstraints = false
        let favArrow = UIImageView(image: UIImage(systemName: "chevron.right"))
        favArrow.tintColor = .tertiaryLabel
        favArrow.translatesAutoresizingMaskIntoConstraints = false
        favoritesCardView.addSubview(favIcon)
        favoritesCardView.addSubview(favTitle)
        favoritesCardView.addSubview(favSubtitle)
        favoritesCardView.addSubview(favArrow)
        // Add tap gesture to favorites card
        let tap = UITapGestureRecognizer(target: self, action: #selector(favoritesCardTapped))
        favoritesCardView.addGestureRecognizer(tap)
        favoritesCardView.isUserInteractionEnabled = true

        getWeatherButton.addTarget(self, action: #selector(getWeatherTapped), for: .touchUpInside)
        saveFavoriteButton.addTarget(self, action: #selector(saveFavoriteTapped), for: .touchUpInside)

        // Layout constraints
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            cityTextField.topAnchor.constraint(equalTo: safe.topAnchor, constant: 20),
            cityTextField.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            cityTextField.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),

            getWeatherButton.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 12),
            getWeatherButton.leadingAnchor.constraint(equalTo: cityTextField.leadingAnchor),
            getWeatherButton.trailingAnchor.constraint(equalTo: cityTextField.trailingAnchor),

            weatherCardView.topAnchor.constraint(equalTo: getWeatherButton.bottomAnchor, constant: 16),
            weatherCardView.leadingAnchor.constraint(equalTo: cityTextField.leadingAnchor),
            weatherCardView.trailingAnchor.constraint(equalTo: cityTextField.trailingAnchor),

            temperatureLabel.topAnchor.constraint(equalTo: weatherCardView.topAnchor, constant: 16),
            temperatureLabel.leadingAnchor.constraint(equalTo: weatherCardView.leadingAnchor, constant: 16),

            descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor),

            cityNameLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            cityNameLabel.leadingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor),

            saveFavoriteButton.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 12),
            saveFavoriteButton.leadingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor),
            saveFavoriteButton.bottomAnchor.constraint(equalTo: weatherCardView.bottomAnchor, constant: -16),

            favoritesCardView.topAnchor.constraint(equalTo: weatherCardView.bottomAnchor, constant: 16),
            favoritesCardView.leadingAnchor.constraint(equalTo: cityTextField.leadingAnchor),
            favoritesCardView.trailingAnchor.constraint(equalTo: cityTextField.trailingAnchor),
            favoritesCardView.bottomAnchor.constraint(lessThanOrEqualTo: safe.bottomAnchor, constant: -20),

            favIcon.leadingAnchor.constraint(equalTo: favoritesCardView.leadingAnchor, constant: 16),
            favIcon.centerYAnchor.constraint(equalTo: favoritesCardView.centerYAnchor),
            favIcon.widthAnchor.constraint(equalToConstant: 24),
            favIcon.heightAnchor.constraint(equalToConstant: 24),

            favTitle.leadingAnchor.constraint(equalTo: favIcon.trailingAnchor, constant: 12),
            favTitle.topAnchor.constraint(equalTo: favoritesCardView.topAnchor, constant: 16),

            favSubtitle.leadingAnchor.constraint(equalTo: favTitle.leadingAnchor),
            favSubtitle.topAnchor.constraint(equalTo: favTitle.bottomAnchor, constant: 4),

            favArrow.trailingAnchor.constraint(equalTo: favoritesCardView.trailingAnchor, constant: -16),
            favArrow.centerYAnchor.constraint(equalTo: favoritesCardView.centerYAnchor)
        ])
    }

    private func setupBindings() {
        viewModel.onWeatherUpdate = { [weak self] info in
            guard let info = info else { return }
            self?.showWeather(info)
        }
        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }
    }

    private func prepopulateFavoriteCity() {
        if let favourite = viewModel.favoriteCity {
            cityTextField.text = favourite
        }
    }

    @objc private func getWeatherTapped() {
        guard let city = cityTextField.text, !city.isEmpty else { return }
        let units = settingsViewModel.isMetricUnits ? "metric" : "imperial"
        viewModel.fetchWeather(city: city, units: units)
    }

    @objc private func saveFavoriteTapped() {
        guard let city = cityTextField.text, !city.isEmpty else { return }
        viewModel.saveFavoriteCity(city)
        let alert = UIAlertController(title: "Saved", message: "City added to favourites.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func favoritesCardTapped() {
        tabBarController?.selectedIndex = 1
    }

    @objc private func settingsTapped() {
        tabBarController?.selectedIndex = 3
    }

    private func showWeather(_ info: WeatherInfo) {
        temperatureLabel.text = "\(Int(info.temperature))°"
        descriptionLabel.text = info.description.capitalized
        cityNameLabel.text = info.cityName
        weatherCardView.isHidden = false
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}