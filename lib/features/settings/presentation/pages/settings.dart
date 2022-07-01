import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../../data/model/country.dart';
import '../../data/model/currency.dart';
import '../../data/model/prefs.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Country _country;
  late Currency _currency;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthState>().loadSettings();
    Prefs? prefs = context.read<AuthState>().userPrefs;
    _country = prefs!.country ?? Country(name: "Nigeria", code: "NG");
    _currency = prefs.currency ??
        Currency(code: "NGN", name: "Nigerian Naira", symbol: "₦");
  }

  @override
  Widget build(BuildContext context) {
    List<Currency>? currencies = context.watch<AuthState>().currencies;
    List<Country>? countries = context.watch<AuthState>().countries;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          if (countries != null) ...[
            DropdownSearch<Country>(
              showSearchBox : true,
              showClearButton: true,
              onChanged: (country) {
                setState(() {
                  _country = country!;
                });
              },
              compareFn: (a, b) => a!.code == b!.code,
              showSelectedItems: true,
              selectedItem: _country,
              dropdownSearchDecoration: const InputDecoration(labelText: "Country"),
              mode: Mode.MENU,
              items: countries,
              itemAsString: (country) => country!.name,
              onFind: (q) => Future.value(
                List<Country>.from(countries)
                    .where((country) => country.name.contains(q!))
                    .toList(),
              ),
            ),
          ],
          if (currencies != null) ...[
            const SizedBox(height: 20.0),
            DropdownSearch<Currency>(
              showSearchBox : true,
              showClearButton: true,
              onChanged: (currency) {
                setState(() {
                  _currency = currency!;
                });
              },
              compareFn: (a, b) => a!.code == b!.code,
              showSelectedItems: true,
              selectedItem: _currency,
              dropdownSearchDecoration: const InputDecoration(labelText: "Currency"),
              mode: Mode.MENU,
              items: currencies,
              itemAsString: (currency) => currency!.name!,
              onFind: (q) => Future.value(
                List<Currency>.from(currencies)
                    .where((currency) => currency.name!.contains(q!))
                    .toList(),
              ),
            ),
          ],
          const SizedBox(height: 10.0),
          ElevatedButton(
            child: _processing ? const Center(child: CircularProgressIndicator()) : const Text("Save"),
            onPressed: _processing
                ? () {}
                : () async {
                    setState(() {
                      _processing = true;
                    });
                    await context.read<AuthState>().updateUserPrefs({
                      "country": _country.toMap(),
                      "currency": _currency.toJson(),
                    });
                    setState(() {
                      _processing = false;
                    });
                    if (kDebugMode) {
                      print("Prefs updated");
                    }
                    Navigator.pop(context);
                  },
          ),
        ],
      ),
    );
  }
}