import 'package:usyre/exception/user.dart';
import 'package:usyre/storage/container.dart';
import 'package:usyre/storage/options.dart';
import 'package:usyre/storage/storage.dart';
import 'package:usyre/user/flag.dart';
import 'package:usyre/user/role.dart';

/// Object for storing users.
///
/// Because of extending the Container class, it can be stored via the
/// storage lib. For further details take a look at the storage lib.
class User extends Container {
  /// Values for managing permissions.
  Flag flag;
  Role role;

  /// User information and credentials.
  String forename;
  String lastname;
  String password;
  String username;

  User({
    this.flag = Flag.foreign,
    this.role = Role.guest,
    this.forename = '',
    this.lastname = '',
    this.password = '',
    this.username = '',
  });

  @override
  Future<void> update() async {}

  @override
  Future<void> verify() async {
    (await Storage().load(Options(type: User))).forEach(
      (element) {
        var user = element as User;

        if (user.username == username && user.containerID != containerID) {
          throw UsernameTakenException();
        }
      },
    );
  }
}
