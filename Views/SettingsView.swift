import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsStore

    var body: some View {
        Form {
            Toggle("Use Fahrenheit (°F)", isOn: $settings.useFahrenheit)
        }
        .navigationTitle("Settings")
    }
}
