import Foundation

final class OpenMeteoService {
    private let client = APIClient()

    func geocode(city: String) async throws -> [GeoResult] {
        var comps = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/search")!
        comps.queryItems = [
            .init(name: "name", value: city),
            .init(name: "count", value: "5"),
            .init(name: "language", value: "en"),
            .init(name: "format", value: "json")
        ]
        guard let url = comps.url else { throw NetworkError.invalidURL }
        let res: GeoResponse = try await client.get(url)
        return res.results ?? []
    }

    func fetchWeather(lat: Double, lon: Double, useFahrenheit: Bool) async throws -> WeatherResponse {
        var comps = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
        comps.queryItems = [
            .init(name: "latitude", value: String(lat)),
            .init(name: "longitude", value: String(lon)),
            .init(name: "current", value: "temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code"),
            .init(name: "daily", value: "temperature_2m_max,temperature_2m_min,weather_code"),
            .init(name: "timezone", value: "auto"),
            .init(name: "temperature_unit", value: useFahrenheit ? "fahrenheit" : "celsius")
        ]
        guard let url = comps.url else { throw NetworkError.invalidURL }
        return try await client.get(url)
    }
}
