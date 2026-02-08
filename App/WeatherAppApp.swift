import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject private var settings = SettingsStore()

    var body: some Scene {
        WindowGroup {
            SearchView()
                .environmentObject(settings)
        }
    }
}
