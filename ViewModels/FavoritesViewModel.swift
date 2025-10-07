import Foundation

/// ViewModel for the favourites screen.  It loads the list of
/// favourite cities from user defaults and retrieves current weather
/// for each city.  It exposes an array of `WeatherInfo` objects and
/// notifies the controller when data changes.
class FavoritesViewModel {
    private let repository: WeatherRepository
    private let userDefaults = UserDefaults.standard
    private(set) var favoritesWeather: [WeatherInfo] = []
    var onUpdate: (() -> Void)?

    /// The measurement units to use for weather requests.
    var units: String = "metric"

    init(repository: WeatherRepository) {
        self.repository = repository
    }

    /// Computed property for reading and writing the array of favourite cities
    /// to user defaults.
    var favoriteCities: [String] {
        get { userDefaults.stringArray(forKey: Constants.favoriteCitiesKey) ?? [] }
        set { userDefaults.set(newValue, forKey: Constants.favoriteCitiesKey) }
    }

    /// Load weather information for all saved favourite cities.  The
    /// results are returned in arbitrary order.  The completion
    /// handler fires on the main thread once all requests complete.
    func loadWeather() {
        favoritesWeather = []
        let group = DispatchGroup()
        for city in favoriteCities {
            group.enter()
            repository.fetchWeather(for: city, units: units) { [weak self] result in
                if case .success(let info) = result {
                    self?.favoritesWeather.append(info)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.onUpdate?()
        }
    }

    /// Remove a favourite city at the given index.  After removal,
    /// reloads the weather list to update the UI.
    func removeFavorite(at index: Int) {
        var cities = favoriteCities
        guard cities.indices.contains(index) else { return }
        cities.remove(at: index)
        favoriteCities = cities
        loadWeather()
    }

    /// Clear all saved favourite cities and reset the weather list.
    func clearFavorites() {
        favoriteCities = []
        favoritesWeather = []
        onUpdate?()
    }
}