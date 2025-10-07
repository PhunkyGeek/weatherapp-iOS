import Foundation

/// A simple view model that wraps a weather repository to fetch
/// weather information for a given city.  It is similar to
/// `HomeViewModel` but can be reused by other screens, such as a
/// detailed weather screen.  The state is exposed via closures.
class WeatherViewModel {
    private let repository: WeatherRepository
    private(set) var weatherInfo: WeatherInfo?
    var onUpdate: ((WeatherInfo?) -> Void)?
    var onError: ((String) -> Void)?
    init(repository: WeatherRepository) {
        self.repository = repository
    }
    func fetchWeather(for city: String, units: String) {
        repository.fetchWeather(for: city, units: units) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let info):
                    self?.weatherInfo = info
                    self?.onUpdate?(info)
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
}