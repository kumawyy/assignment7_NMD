import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var results: [GeoResult] = []
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let repo = WeatherRepository()
    private var searchTask: Task<Void, Never>?

    func search() {
        searchTask?.cancel()

        searchTask = Task {
            await self.searchAsync()
        }
    }

    private func searchAsync() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "Enter a city name"
            results = []
            return
        }

        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let res = try await repo.searchCity(trimmed)
            if Task.isCancelled { return }
            results = res
            if res.isEmpty { errorMessage = "City not found" }
        } catch {
            if Task.isCancelled { return }
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Network error"
            results = []
        }
    }
}
