import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterappwrite/core/res/app_constants.dart';
import 'package:flutterappwrite/features/auth/data/model/user.dart';
import 'package:flutterappwrite/features/settings/data/model/country.dart';
import 'package:flutterappwrite/features/settings/data/model/currency.dart';
import 'package:flutterappwrite/features/settings/data/model/prefs.dart';

class AuthState extends ChangeNotifier {
  Client client = Client();
  late Account account;
  late bool _isLoggedIn;
  late User _user;
  String? _error;
  late Locale locale;
  List<Country>? _countries;
  List<Currency>? _currencies;
  Prefs? prefs;
  late bool _isSettingsLoaded;
  late Storage storage;

  bool get isLoggedIn => _isLoggedIn;
  User get user => _user;
  String? get error => _error;
  List<Country>? get countries => _countries;
  List<Currency>? get currencies => _currencies;
  Prefs? get userPrefs => prefs;
  Account get getAccount => account;

  AuthState() {
    _init();
  }

  _init() {
    _isLoggedIn = false;
    _user = User();
    _isSettingsLoaded = false;
    client.setEndpoint(AppConstants.endpoint);
    client.setProject(AppConstants.projectId);
    account = Account(client);
    getUser();
    checkIsLoggedIn();
    locale = Locale(client);
    getUserPrefs();
    prefs = Prefs();
    storage = Storage(client);
  }

  //load settings
  Future loadSettings() async {
    if (_isSettingsLoaded) return;
    if (_currencies == null) await getCurrencies();
    if (_countries == null) await getCountries();
    await getUserPrefs();
  }

  // Check if user is logged in
  checkIsLoggedIn() async {
    _user = await getUser();
    _isLoggedIn = true;
    notifyListeners();
    try {
      var result = await account.get();
      if (kDebugMode) {
        print(result.toMap().toString());
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
        rethrow;
      }
    }
  }

  //get user account
  Future<User> getUser() async {
    final result = await account.get();
    return User.fromJson(result.toMap());
  }

  //user login session with email and password
  Future<User> login(String email, String password) async {
    User? __user;
    try {
      var result =
          await account.createSession(email: email, password: password);
      if (kDebugMode) {
        print(result.toMap().toString());
      }
      __user = User.fromJson(result.toMap());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    notifyListeners();
    if (__user != null) {
      _user = __user;
      _isLoggedIn = true;
      notifyListeners();
      return __user;
    } else {
      return User();
    }
  }

  //create user
  create(String name, String email, String password) async {
    try {
      var result = await account.create(
          email: email, password: password, userId: 'unique()', name: name);
      notifyListeners();
      if (kDebugMode) {
        print(result.toMap().toString());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //logout user
  logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
      _isLoggedIn = false;
      _user = User();
      notifyListeners();
      if (kDebugMode) {
        print('User is logged out');
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //get countries
  Future getCountries() async {
    try {
      var result = await locale.getCountries();
      if (kDebugMode) {
        print(result.toMap().toString());
      }
      // _countries = <Country>[
      //   ...result.countries.map((e) => Country(code: e.code, name: e.name))
      // ];

      _countries = result.countries
          .map((e) => Country(code: e.code, name: e.name))
          .toList();

      // result.toMap().forEach((key, value) {
      //   _countries!.add(Country(code: key, name: value));
      // });

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //get currencies
  Future getCurrencies() async {
    try {
      var result = await locale.getCurrencies();
      if (kDebugMode) {
        print(result.toMap().toString());
      }
      _currencies = <Currency>[
        ...result.currencies.map((e) => Currency.fromJson(e.toMap()))
      ];

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future getUserPrefs() async {
    return account.getPrefs().then((result) {
      prefs = Prefs.fromJson(result.toMap());
      // if (kDebugMode) {
      //   print("Prefs: ${prefs?.country?.name.toString()}");
      // }
      notifyListeners();
    });
  }

  //update prefs
  Future updateUserPrefs(Map<String, dynamic> prefs_) async {
    try {
      var result = await account.updatePrefs(prefs: prefs_);
      if (kDebugMode) {
        print(result.toMap().toString());
      }
      prefs = Prefs.fromJson(result.toMap());
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
