import 'package:hooks_riverpod/hooks_riverpod.dart';

class PhoneNumber {
  String phoneNum;
  PhoneNumber({required this.phoneNum});

PhoneNumber copyWith({String? phoneNum}){
  return PhoneNumber(phoneNum: phoneNum ?? this.phoneNum );
}
}

class PhoneNoNotifier extends StateNotifier<PhoneNumber> {
  PhoneNoNotifier(super.state);

  void setPhoneNo({String? phoneNo}) {
    state = state.copyWith(phoneNum: phoneNo);
  }
}

final phoneNoProvider = StateNotifierProvider<PhoneNoNotifier, PhoneNumber>((ref){
  return PhoneNoNotifier(
    PhoneNumber(phoneNum: "")
  );
});
