import Foundation

/// ViewModel for the home screen.  It handles fetching weather for a
/// user‑entered city, persisting the favourite city and updating the
/// UI through callback closures.  The view model uses a weather
/// repository injected via the initializer to allow for easy
/// unit testing.
class HomeViewModel {
    private let repository: WeatherRepository
    private let userDefaults = UserDefaults.standard

    /// The current weather information, populated after a successful fetch.
    private(set) var weatherInfo: WeatherInfo?

    /// Closure invoked whenever new weather information is available.
    var onWeatherUpdate: ((WeatherInfo?) -> Void)?
    /// Closure invoked when an error occurs during a fetch.
    var onError: ((String) -> Void)?

    init(repository: WeatherRepository) {
        self.repository = repository
    }

    /// The favourite city saved by the user.  If set to a non‑nil value it
    /// is also added to the list of favourite cities.
    var favoriteCity: String? {
        get {
            userDefaults.string(forKey: Constants.favoriteCityKey)
        }
        set {
            userDefaults.set(newValue, forKey: Constants.favoriteCityKey)
        }
    }

    /// Save a city as the user's favourite.  This method both sets
    /// `favoriteCity` and appends the city to the array of favourite
    /// cities if it isn't already present.
    func saveFavoriteCity(_ city: String) {
        favoriteCity = city
        var cities = favoriteCities
        if !cities.contains(where: { $0.caseInsensitiveCompare(city) == .orderedSame }) {
            cities.append(city)
            favoriteCities = cities
        }
    }

    /// Computed property that returns the array of favourite cities
    /// persisted in user defaults.  Setting this property updates
    /// user defaults accordingly.
    private var favoriteCities: [String] {
        get {
            userDefaults.stringArray(forKey: Constants.favoriteCitiesKey) ?? []
        }
        set {
            userDefaults.set(newValue, forKey: Constants.favoriteCitiesKey)
        }
    }

    /// Fetch weather data for the provided city using the weather
    /// repository.  On success, the `weatherInfo` property is
    /// updated and `onWeatherUpdate` is called on the main thread.
    func fetchWeather(city: String, units: String) {
        repository.fetchWeather(for: city, units: units) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let info):
                    self?.weatherInfo = info
                    self?.onWeatherUpdate?(info)
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
}