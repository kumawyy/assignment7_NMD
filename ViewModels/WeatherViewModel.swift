import Foundation
import Combine

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var cached: CachedWeather?
    @Published var isOffline = false

    private let repo = WeatherRepository()
    private let settings: SettingsStore

    init(settings: SettingsStore) {
        self.settings = settings
        self.cached = repo.loadCached()
    }

    func fetch(city: GeoResult) async {
        errorMessage = nil
        isLoading = true
        isOffline = false
        defer { isLoading = false }

        do {
            cached = try await repo.loadWeather(city: city, useFahrenheit: settings.useFahrenheit)
        } catch {
            if let c = repo.loadCached() {
                cached = c
                isOffline = true
            } else {
                errorMessage = (error as? LocalizedError)?.errorDescription ?? "Unknown error"
            }
        }
    }
}
