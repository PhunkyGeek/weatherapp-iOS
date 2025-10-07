import Foundation

/// Represents the JSON response from the OpenWeather `current weather`
/// endpoint.  Only the fields used by the application are defined
/// here.  Additional fields can be added as needed to support more
/// functionality.
struct WeatherResponse: Codable {
    let name: String
    let weather: [Weather]
    let main: Main

    struct Weather: Codable {
        let description: String
    }

    struct Main: Codable {
        let temp: Double
    }
}

/// A domain model representing the weather information displayed in
/// the user interface.  The repository maps network data into this
/// simpler structure.
struct WeatherInfo {
    let cityName: String
    let temperature: Double
    let description: String
}