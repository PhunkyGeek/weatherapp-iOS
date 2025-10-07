import Foundation

/// A central location for constant values used throughout the app.  The
/// API key is defined here; be sure to replace `"YOUR_API_KEY"` with
/// your actual OpenWeather API key before running the app.  User
/// defaults keys are grouped here to avoid typos elsewhere in the code.
struct Constants {
    static let apiKey = "941bcdb773df2fcb2c25acb2cdb7f28d"

    static let favoriteCityKey = "favoriteCity"
    static let favoriteCitiesKey = "favoriteCities"
    static let darkThemeKey = "darkTheme"
    static let metricUnitsKey = "metricUnits"
    static let notificationsKey = "notificationsEnabled"
}