import Foundation

/// Protocol defining an abstraction over weather data fetching.  By
/// depending on this protocol rather than a concrete implementation,
/// the view models can be tested with mocks.
protocol WeatherRepository {
    /// Fetch current weather for the given city name.
    ///
    /// - Parameters:
    ///   - city: The name of the city to fetch weather for.
    ///   - units: Units of measurement, either `metric` or `imperial`.
    ///   - completion: Completion handler called with the result on
    ///     completion.  On success a `WeatherInfo` is returned; on
    ///     failure an error is provided.
    func fetchWeather(for city: String, units: String, completion: @escaping (Result<WeatherInfo, Error>) -> Void)
}