/// Enum for storing an User's role.
///
/// The Role can be used to determine an User's permissions.
/// Users with Role.admin can perform any action.
enum Role {
  /// Can do whatever you want.
  admin,

  /// Can not do whatever you want.
  user,

  /// Can pretty much do nothing.
  guest,
}
