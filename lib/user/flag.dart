/// Enum for storing a Flag to be used within an User object.
///
/// A Flag's value can be used to mark a User object for an
/// better overview. You may mark a User as Flag.temporally to indicate,
/// that it is only required for now, but should be deleted in the future.
enum Flag {
  /// Mark users that you probably don't need in the future.
  temporally,

  /// Mark users that you as an admin know.
  trustful,

  /// Mark users that you as an admin don't now.
  foreign,
}
