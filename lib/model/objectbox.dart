import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:zekryptofolio/model/favourite.dart';

import 'objectbox.g.dart'; // created by `dart run build_runner build`

class ObjectBox {
  late final Store _store;

  late final Box<Favourite> _favouriteBox;

  ObjectBox._create(this._store) {
    _favouriteBox = Box<Favourite>(_store);

    // Add some demo data if the box is empty.
    if (_favouriteBox.isEmpty()) {
      _putDemoData();
    }
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final store = await openStore(
        directory: p.join(
            (await getApplicationDocumentsDirectory()).path, "favourite"),
        macosApplicationGroup: "favourite.demo");
    return ObjectBox._create(store);
  }

  void _putDemoData() {
    final demoFavourites = [
      Favourite('bitcoin'),
      Favourite('etherum'),
      Favourite('solana')
    ];
    _favouriteBox.putManyAsync(demoFavourites);
  }

  Stream<List<Favourite>> getFavourites() {
    final builder =
        _favouriteBox.query().order(Favourite_.id, flags: Order.descending);
    // Build and watch the query,
    // set triggerImmediately to emit the query immediately on listen.
    return builder
        .watch(triggerImmediately: true)
        // Map it to a list of notes to be used by a StreamBuilder.
        .map((query) => query.find());
  }

  Future<void> addFavourite(String coin) =>
      _favouriteBox.putAsync(Favourite(coin));

  Future<void> removeFavourite(int id) => _favouriteBox.removeAsync(id);
}
