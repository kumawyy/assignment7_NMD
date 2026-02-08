import Foundation

struct GeoResponse: Codable {
    let results: [GeoResult]?
}

struct GeoResult: Codable, Identifiable, Hashable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String?
    let admin1: String?
}
f
