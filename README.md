# Weather App 

## Overview

This project is an iOS Weather Application developed using Swift and SwiftUI as part of Assignment 7: Data & Networking (API Integration).
The application allows users to search for a city and view current weather information retrieved from a public REST API. The last successful response is cached locally to support offline usage.

---

## Features

* City search using a public geocoding API
* Current weather display including:

  * City name
  * Temperature
  * Weather condition
  * Humidity
  * Wind speed
  * Last update time
* Three-day daily weather forecast (minimum and maximum temperature)
* Offline mode with cached data and clear offline indicator
* Settings screen for switching temperature units (Celsius/Fahrenheit)
* Graceful error handling for empty input, city not found, and network or API errors

---

## API Used

**Open-Meteo API** 

### Endpoints

**Geocoding**

```
https://geocoding-api.open-meteo.com/v1/search
```

Parameters:

* name – city name
* count – number of results
* language – response language
* format – response format

**Weather Forecast**

```
https://api.open-meteo.com/v1/forecast
```

Parameters:

* latitude, longitude
* current – temperature, humidity, wind speed, weather code
* daily – minimum and maximum temperature, weather code
* temperature_unit – celsius or fahrenheit
* timezone – auto

---

## Architecture

The application follows the MVVM architecture with a Repository layer.

```
SwiftUI Views
   ↓
ViewModels (ObservableObject)
   ↓
Repository
   ↓
Networking Layer (URLSession)
```

* Views are responsible only for UI rendering.
* ViewModels manage state and business logic.
* Repository handles data retrieval and caching.
* Networking layer performs HTTP requests and JSON parsing using Codable.

---

## Local Caching and Offline Mode

* The last successful weather response is stored locally using UserDefaults.
* When the network is unavailable, the application displays cached data along with an offline mode indicator.

---

## Error Handling

The application handles the following cases:

* Empty search input
* City not found
* Network timeout
* API or server errors
* JSON parsing errors

Error messages are displayed clearly in the user interface.

---

## How to Run the App

1. Open the project in Xcode.
2. Select an iOS Simulator (iOS 15 or later recommended).
3. Build and run the application.
4. Enter a city name to retrieve weather information.

---

## Technologies Used

* Swift
* SwiftUI
* URLSession
* Codable
* Combine
* UserDefaults

---

## Known Limitations

* Weather conditions are displayed as text based on weather codes.
* Search history and suggestions are not implemented.
* Forecast is limited to three days as required by the assignment.


---

## Author

Student: *Muratov Aslan*


