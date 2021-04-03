import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

abstract class LocalStorageDataSource {
  Future<String> cachedCurrency({String currency});
}

const CACHED_CURRENCY = 'CACHED_CURRENCY';

class LocalStorageDataSourceImpl implements LocalStorageDataSource {
  LocalStorageDataSourceImpl();
  @override
  Future<String> cachedCurrency({String currency}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    if (currency != null) {
      sharedPreferences.setString(CACHED_CURRENCY, currency);
      return Future.value('ok');
    } else {
      final cachedCurrency = sharedPreferences.getString(CACHED_CURRENCY);
      if (cachedCurrency != null) {
        return Future.value(cachedCurrency);
      } else {
        return Future.value('\$');
      }
    }
  }
}
