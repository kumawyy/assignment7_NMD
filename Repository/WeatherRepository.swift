import Foundation

final class WeatherRepository {
    private let service = OpenMeteoService()
    private let cache = CacheStore()

    func searchCity(_ name: String) async throws -> [GeoResult] {
        try await service.geocode(city: name)
    }

    func loadWeather(city: GeoResult, useFahrenheit: Bool) async throws -> CachedWeather {
        let weather = try await service.fetchWeather(lat: city.latitude, lon: city.longitude, useFahrenheit: useFahrenheit)
        let display = [city.name, city.admin1, city.country].compactMap { $0 }.joined(separator: ", ")
        let cached = CachedWeather(cityDisplay: display, payload: weather, savedAt: Date())
        cache.save(cached)
        return cached
    }

    func loadCached() -> CachedWeather? {
        cache.load()
    }
}
