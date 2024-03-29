# Celheit_WeatherApp

Weather app displaying measurements in Celsius and Fahrenheit, useful for people coming to the US and do not knowing the conversion rate, written using SwiftUI. 

The app uses weather API provided by [Open-Meteo.com](https://open-meteo.com/) and location search API by [nominatim.org](https://nominatim.org/)

## Live Demo

https://user-images.githubusercontent.com/73793088/212335539-efa39240-4e51-461b-a9bc-e3398b4081d6.mp4

## Specification:

- The app shows to a user weather at current location, with temperature displayed in both Fahrenheit and Celsius. User can also search for other places by tapping on change location button and inserting the new address.

- User can check current temperature(including apparent temperature) and hourly prediction up to 12 hours forward in both Fahrenheit and Celsius, as well as weather conditions such as precipitation and cloud cover percentage.

- In order to find weather for given location the app uses by default user location tracker(user is asked for permission) by passing longitude and latitude and calling the weather API. In the search area user can input new address and choose new region from the list of results fetched through location API. After tapping on any option, the coordinates are passed and weather API is called to retrieve new values for given region. 

- The data is easily refreshable by pulling the main view down with a finger, which is accompanied with a animation feedback. A user can always switch back to current location by tapping "Use current location" button

- The UI colors change based on the weather conditions in chosen address' precipitation and day/night cycle
