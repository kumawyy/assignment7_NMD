import SwiftUI

struct SearchView: View {
    @StateObject private var vm = SearchViewModel()
    @EnvironmentObject var settings: SettingsStore

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {

                HStack(spacing: 10) {
                    TextField("Enter city", text: $vm.query)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)
                        .submitLabel(.search)
                        .onSubmit {
                            vm.search()
                        }

                    Button("Search") {
                        vm.search()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(vm.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.isLoading)
                }

                if vm.isLoading {
                    ProgressView()
                        .padding(.top, 6)
                }

                if let msg = vm.errorMessage {
                    Text(msg)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                List(vm.results) { city in
                    NavigationLink {
                        WeatherView(city: city, settings: settings)
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(city.name)
                                .font(.headline)

                            Text([city.admin1, city.country].compactMap { $0 }.joined(separator: ", "))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
            }
            .padding()
            .navigationTitle("Weather")
            .toolbar {
                NavigationLink("Settings") {
                    SettingsView()
                }
            }
        }
    }
}
