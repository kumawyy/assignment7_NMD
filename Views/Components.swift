import SwiftUI

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label).foregroundStyle(.secondary)
            Spacer()
            Text(value).bold()
        }
    }
}

struct OfflineBanner: View {
    var body: some View {
        Text("Offline mode: showing cached data")
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.yellow.opacity(0.25))
            .cornerRadius(10)
    }
}

enum WeatherCodeMapper {
    static func text(_ code: Int) -> String {
        switch code {
        case 0: return "Clear"
        case 1,2,3: return "Cloudy"
        case 45,48: return "Fog"
        case 51,53,55: return "Drizzle"
        case 61,63,65: return "Rain"
        case 71,73,75: return "Snow"
        case 95: return "Thunderstorm"
        default: return "Code \(code)"
        }
    }
}
