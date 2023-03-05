import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:usyre/exception/storage.dart';
import 'package:usyre/storage/datasheet.dart';

/// Class for communicating with the database.
///
/// The Database class should handle the communication
/// with the database server. The database server is a MongoDB instance,
/// even though it should be easy to modify the implementation to
/// match other database types (e.g. MariaDB, PostGreSQL).
class Database {
  /// Database compatible types for using inside of a Datasheet.
  static Map types = <Type, String>{
    int: 'int',
    bool: 'bool',
    double: 'double',
    String: 'string',
  };

  /// MongoDB connection credentials; Need to be set for proper functioning.
  static int port = 27017;
  static String location = 'localhost';
  static String database = 'usyre';
  static String username = 'usyre';
  static String password = 'usyre';
  static String schemata = 'mongodb';

  /// MongoDB connection; Static for the sake of performance.
  static dynamic mongodb;

  Database();

  /// Attach to the database in case there's no active connection.
  Future<void> attach() async {
    if (mongodb != null && mongodb.isConnected) {
      return;
    }

    try {
      var uri = Uri(
        port: port,
        host: location,
        path: database,
        scheme: schemata,
        userInfo: '$username:$password',
        queryParameters: {
          'authSource': 'admin',
        },
      );

      mongodb = mongo.Db(uri.toString());

      await mongodb.open();
    } catch (exception) {
      throw DatabaseConnectionFailedException();
    }
  }

  /// Inserts one item into the collection. Overwrites an existing entry.
  Future<void> insert(Datasheet datasheet) async {
    await datasheet.validate();
    await attach();

    var collection = mongodb.collection(datasheet.hash);
    var properties = <String, dynamic>{};

    datasheet.form.keys.forEach(
      (element) {
        properties.addAll({
          element: datasheet.data[element],
        });
      },
    );

    try {
      await collection.insertOne(properties);
    } catch (exception) {
      throw DatabaseTransactionFailedException();
    }
  }

  /// Deletes one item from the desired collection. Skips if not found.
  Future<void> delete(Datasheet datasheet) async {
    await datasheet.validate();
    await attach();

    var collection = mongodb.collection(datasheet.hash);

    try {
      await collection.deleteOne(
        {
          'containerID': datasheet.data['containerID'],
        },
      );
    } catch (exception) {
      throw DatabaseTransactionFailedException();
    }
  }

  /// Loads items from database. Collection is selected through the Datasheet.
  Future<List<Datasheet>> load(Datasheet datasheet) async {
    await attach();
    var collection = mongodb.collection(datasheet.hash);

    var datasheets = <Datasheet>[];
    try {
      for (Map element in await collection.find().toList()) {
        datasheets.add(
          Datasheet()
            ..form.addAll(datasheet.form)
            ..data.addAll(element),
        );
      }
    } catch (exception) {
      throw DatabaseTransactionFailedException();
    }

    return datasheets;
  }
}
