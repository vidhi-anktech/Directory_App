import 'package:hooks_riverpod/hooks_riverpod.dart';

class Location{
  final String state;
  final String city;

  const Location(
    this.state,
    this.city,
  );
  Location copyWith({
    String? state,
    String? city,
  }){
    return Location(
      state ?? this.state,
      city ?? this.city,
    );
  }
   Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'state': state,
      'city': city,
    };
  }
}

class LocationNotifier extends StateNotifier<Location>{
  LocationNotifier(super.state);

   updateState( String newStateValue){
    state = state.copyWith(state: newStateValue);
  }
   updateCity(String newCityValue){
    state = state.copyWith(city: newCityValue);
  }
}

final locationNotifier = StateNotifierProvider<LocationNotifier, Location>((ref) {
  return LocationNotifier(const Location("", ""));
});