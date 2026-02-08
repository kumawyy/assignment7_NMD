import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case badStatus(Int)
    case decoding
    case noData
    case other(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .badStatus(let code):
            return "Server error (HTTP \(code))"
        case .decoding:
            return "Failed to parse server response"
        case .noData:
            return "No data received"
        case .other(let e):
            return e.localizedDescription
        }
    }
}

final class APIClient {
    private let session: URLSession

    init() {
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = 8
        config.timeoutIntervalForResource = 8
        config.waitsForConnectivity = false
        self.session = URLSession(configuration: config)
    }

    func get<T: Decodable>(_ url: URL) async throws -> T {
        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        do {
            let (data, resp) = try await session.data(for: req)
            guard let http = resp as? HTTPURLResponse else {
                throw NetworkError.noData
            }
            guard (200...299).contains(http.statusCode) else {
                throw NetworkError.badStatus(http.statusCode)
            }
            return try JSONDecoder().decode(T.self, from: data)
        } catch let urlErr as URLError {
            throw NetworkError.other(urlErr)
        } catch {
            throw NetworkError.other(error)
        }
    }
}
