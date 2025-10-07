import Foundation

/// A simple service locator used for dependency injection.  It
/// constructs and provides instances of services used throughout the
/// application.  This allows view models and controllers to receive
/// dependencies without tightly coupling to concrete implementations.
class AppContainer {
    static let shared = AppContainer()

    /// The repository responsible for fetching weather data.  You
    /// could swap this out for a mock implementation in unit tests.
    let weatherRepository: WeatherRepository

    private init() {
        weatherRepository = WeatherRepositoryImpl()
    }
}