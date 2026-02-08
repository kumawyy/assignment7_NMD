import Foundation

struct CachedWeather: Codable {
    let cityDisplay: String
    let payload: WeatherResponse
    let savedAt: Date
}

final class CacheStore {
    private let key = "last_weather_cache_v1"

    func save(_ cached: CachedWeather) {
        guard let data = try? JSONEncoder().encode(cached) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    func load() -> CachedWeather? {
        guard let data = UserDefaults.standard.data(forKey: key),
              let obj = try? JSONDecoder().decode(CachedWeather.self, from: data) else { return nil }
        return obj
    }
}
