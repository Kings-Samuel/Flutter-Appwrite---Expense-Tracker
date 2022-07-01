import 'country.dart';
import 'currency.dart';

class Prefs {
  Country? country;
  Currency? currency;
  String? profilepicID;
  String? profilepicURL;

  Prefs({this.country, this.currency, this.profilepicID, this.profilepicURL});

  factory Prefs.fromJson(Map<String, dynamic> json) {
    return Prefs(
      country: json['country'] != null ? Country.fromJson(json['country']) : null,
      currency: json['currency'] != null ? Currency.fromJson(json['currency']) : null,
      profilepicID: json['profilepicID'],
      profilepicURL: json['profilepicURL'],
    );
  }

}