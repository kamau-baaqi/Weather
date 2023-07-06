import SwiftUI

struct CityTime {
    let cityName: String
    var localTime: String
    var weatherCondition: String
}

struct WeatherAppView: View {
    @State private var cities: [CityTime] = [
        CityTime(cityName: "Detroit", localTime: "", weatherCondition: "rainy"),
        CityTime(cityName: "New York", localTime: "", weatherCondition: "clear"),
        CityTime(cityName: "London", localTime: "", weatherCondition: "cloudy"),
        CityTime(cityName: "Tokyo", localTime: "", weatherCondition: "partly_cloudy"),
        CityTime(cityName: "Paris", localTime: "", weatherCondition: "partly_cloudy"),
        CityTime(cityName: "Sydney", localTime: "", weatherCondition: "rainy")
        
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(cities.indices, id: \.self) { index in
                    let city = cities[index]

                    VStack {
                        weatherSymbol(for: city.weatherCondition)
                            .font(.system(size: 50))
                            .foregroundColor(.primary)

                        VStack {
                            Text(city.cityName)
                                .font(.headline)
                                .fontWeight(.bold)

                            Text(city.localTime)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .multilineTextAlignment(.center)
                    }
                    .padding()
                    .onAppear {
                        updateTime(for: index)
                    }
                    .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                        updateTime(for: index)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle("City Time")
    }

    private func weatherSymbol(for condition: String) -> some View {
        switch condition {
        case "clear":
            return Text("☀️")
        case "cloudy":
            return Text("☁️")
        case "partly_cloudy":
            return Text("⛅️")
        case "rainy":
            return Text("🌧")
        default:
            return Text("")
        }
    }

    private func updateTime(for index: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a"
        formatter.timeZone = TimeZone.current

        cities[index].localTime = formatter.string(from: Date())
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            WeatherAppView()
        }
    }
}

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
