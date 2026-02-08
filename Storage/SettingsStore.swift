import Foundation
import Combine

final class SettingsStore: ObservableObject {
    @Published var useFahrenheit: Bool {
        didSet { UserDefaults.standard.set(useFahrenheit, forKey: "useFahrenheit") }
    }

    init() {
        self.useFahrenheit = UserDefaults.standard.bool(forKey: "useFahrenheit")
    }
}
