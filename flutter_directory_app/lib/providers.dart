import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedCityStateProvider = StateProvider<CityState?>((ref) => null);

class CityState {
  final String country;
  final String state;
  final String city;

  CityState(this.country, this.state, this.city);
}


// // On the home page when the user selects a city and state
// final selectedCityState = context.read(selectedCityStateProvider);
// context.read(selectedCityStateProvider).state = CityState(
//   selectedCountry, // Replace with the actual selected country value
//   selectedState,   // Replace with the actual selected state value
//   selectedCity,    // Replace with the actual selected city value
// );

// // On the show data page to retrieve the selected city and state
// final selectedCityState = context.read(selectedCityStateProvider).state;
// if (selectedCityState != null) {
//   final selectedCountry = selectedCityState.country;
//   final selectedState = selectedCityState.state;
//   final selectedCity = selectedCityState.city;
//   // Now you have the selected city and state values to filter the user data
// }
