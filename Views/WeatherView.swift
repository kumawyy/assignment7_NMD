import SwiftUI

struct WeatherView: View {
    let city: GeoResult

    @ObservedObject var settings: SettingsStore
    @StateObject private var vm: WeatherViewModel

    init(city: GeoResult, settings: SettingsStore) {
        self.city = city
        self.settings = settings
        _vm = StateObject(wrappedValue: WeatherViewModel(settings: settings))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if vm.isLoading { ProgressView() }

                if let msg = vm.errorMessage {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(msg).foregroundStyle(.red)
                        Button("Retry") {
                            Task { await vm.fetch(city: city) }
                        }
                    }
                }

                if vm.isOffline { OfflineBanner() }

                if let cached = vm.cached {
                    let w = cached.payload

                    Text(cached.cityDisplay)
                        .font(.title2).bold()

                    Text("Updated: \(formatDate(w.current.time))")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(formatTemp(w.current.temperature_2m))
                        .font(.system(size: 48, weight: .bold))

                    InfoRow(label: "Condition", value: WeatherCodeMapper.text(w.current.weather_code))
                    InfoRow(label: "Humidity", value: "\(Int(w.current.relative_humidity_2m))%")
                    InfoRow(label: "Wind", value: "\(Int(w.current.wind_speed_10m)) km/h")

                    Divider().padding(.vertical, 6)

                    Text("3-day forecast").font(.headline)

                    ForEach(0..<min(3, w.daily.time.count), id: \.self) { i in
                        HStack {
                            Text(w.daily.time[i])
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text(WeatherCodeMapper.text(w.daily.weather_code[i]))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("\(formatTemp(w.daily.temperature_2m_min[i])) / \(formatTemp(w.daily.temperature_2m_max[i]))")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .font(.subheadline)
                        Divider()
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Weather")
        .task {
            await vm.fetch(city: city)
        }
        .onChange(of: settings.useFahrenheit) {
            Task { await vm.fetch(city: city) }
        }
    }

    private func formatTemp(_ v: Double) -> String {
        settings.useFahrenheit ? "\(Int(v))°F" : "\(Int(v))°C"
    }

    private func formatDate(_ iso: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        var date = isoFormatter.date(from: iso)

        if date == nil {
            let f2 = ISO8601DateFormatter()
            f2.formatOptions = [.withInternetDateTime]
            date = f2.date(from: iso)
        }

        guard let d = date else { return iso }

        let out = DateFormatter()
        out.dateStyle = .medium
        out.timeStyle = .short
        return out.string(from: d)
    }
}
