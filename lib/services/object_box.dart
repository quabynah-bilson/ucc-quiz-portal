import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:ucc_quiz_portal/models/active.dart';
import 'package:ucc_quiz_portal/objectbox.g.dart';

// import 'dart';
// import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

/// Provides access to the ObjectBox Store throughout the app.
///
/// Create this in the apps main function.
class ObjectBox {
  /// The Store of this app.
  late final Store _store;

  /// A Box of notes.
  late final Box<Active> _activeBox;

  ObjectBox._create(this._store) {
    _activeBox = Box<Active>(_store);
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Note: setting a unique directory is recommended if running on desktop
    // platforms. If none is specified, the default directory is created in the
    // users documents directory, which will not be unique between apps.
    // On mobile this is typically fine, as each app has its own directory
    // structure.

    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(
        directory: p.join(
            (await getApplicationDocumentsDirectory()).path, "obx-demo"));
    return ObjectBox._create(store);
  }

  // void _putDemoData() {
  //   final demoNotes = [
  //     Note('Quickly add a note by writing text and pressing Enter'),
  //     Note('Delete notes by tapping on one'),
  //     Note('Write a demo app for ObjectBox')
  //   ];
  //   _noteBox.putManyAsync(demoNotes);
  // }

  Stream<List<Active>> getActives() {
    // Query for all notes, sorted by their date.
    // https://docs.objectbox.io/queries
    final builder =
        _activeBox.query().order(Active_.date, flags: Order.descending);
    // Build and watch the query,
    // set triggerImmediately to emit the query immediately on listen.
    return builder
        .watch(triggerImmediately: true)
        // Map it to a list of notes to be used by a StreamBuilder.
        .map((query) => query.find());
  }

  /// Add a note.
  ///
  /// To avoid frame drops, run ObjectBox operations that take longer than a
  /// few milliseconds, e.g. putting many objects, asynchronously.
  /// For this example only a single object is put which would also be fine if
  /// done using [Box.put].
  Future<void> addActive(int count) => _activeBox.putAsync(Active(count));

  Future<void> removeActive(int id) => _activeBox.removeAsync(id);
}
