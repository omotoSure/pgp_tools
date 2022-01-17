import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreference {
  static const publicKey = 'publicKey';
  static const privateKey = 'privateKey';

  static Future init() async {
    try {
      /// Checks if shared preference exist
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      prefs.getString("app-name");
    } catch (err) {
      /// setMockInitialValues initiates shared preference
      /// Adds app-name
      SharedPreferences.setMockInitialValues({});
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      prefs.setString("app-name", "my-app");
    }
  }

  static dynamic setPublicKey(String public) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var _res = prefs.setString(publicKey, public);
    return _res;
  }

  static dynamic getPublicKey() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String? _res = prefs.getString(publicKey);
    return _res;
  }

  static Future setPrivateKey(String private) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var _res = prefs.setString(privateKey, private);
    return _res;
  }

  static dynamic getPrivateKey() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String? _res = prefs.getString(privateKey);
    return _res;
  }
}
