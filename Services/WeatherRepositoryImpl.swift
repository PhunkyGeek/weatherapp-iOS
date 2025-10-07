import Foundation

/// Concrete implementation of `WeatherRepository` that calls the
/// OpenWeather API to retrieve current weather data.  The API
/// requires a city name and API key.  Units may be specified as
/// `metric` or `imperial`.  Errors are propagated through the
/// completion handler.
class WeatherRepositoryImpl: WeatherRepository {

    func fetchWeather(for city: String, units: String, completion: @escaping (Result<WeatherInfo, Error>) -> Void) {
        // Prepare a percent‑escaped city name to safely include in the URL.
        let escapedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        // Build the request URL using the OpenWeather API.  The `q`
        // parameter provides the city name and `appid` provides the
        // API key【910102616634607†L465-L489】.
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(escapedCity)&units=\(units)&appid=\(Constants.apiKey)"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "WeatherApp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                let error = NSError(domain: "WeatherApp", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            do {
                // Decode the JSON into a WeatherResponse model.
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                // Construct a domain object with the needed values.
                let info = WeatherInfo(cityName: weatherResponse.name,
                                       temperature: weatherResponse.main.temp,
                                       description: weatherResponse.weather.first?.description ?? "")
                completion(.success(info))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}