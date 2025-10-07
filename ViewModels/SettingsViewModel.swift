import Foundation

/// ViewModel for the settings screen.  It exposes user preferences
/// stored in user defaults such as theme, units and notifications.
/// Changing these properties updates user defaults and triggers any
/// necessary UI updates (e.g. theme changes in the controller).
class SettingsViewModel {
    private let userDefaults = UserDefaults.standard

    /// Whether dark mode is enabled.  When set, the value is stored
    /// in user defaults under `Constants.darkThemeKey`.
    var darkTheme: Bool {
        get { userDefaults.bool(forKey: Constants.darkThemeKey) }
        set { userDefaults.set(newValue, forKey: Constants.darkThemeKey) }
    }

    /// Whether metric units should be used.  When set, the value is
    /// stored in user defaults under `Constants.metricUnitsKey`.
    var isMetricUnits: Bool {
        get {
            if let val = userDefaults.object(forKey: Constants.metricUnitsKey) as? Bool { return val }
            return true
        }
        set {
            userDefaults.set(newValue, forKey: Constants.metricUnitsKey)
        }
    }

    /// Whether notifications are enabled.
    var notificationsEnabled: Bool {
        get {
            if let val = userDefaults.object(forKey: Constants.notificationsKey) as? Bool { return val }
            return true
        }
        set {
            userDefaults.set(newValue, forKey: Constants.notificationsKey)
        }
    }

    /// Delete all saved favourite cities.  Called from the settings
    /// screen when the user opts to clear saved data.
    func clearSavedData() {
        userDefaults.removeObject(forKey: Constants.favoriteCityKey)
        userDefaults.removeObject(forKey: Constants.favoriteCitiesKey)
    }
}