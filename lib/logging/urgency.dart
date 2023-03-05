/// Enum for storing the Log's level.
///
/// The Logger distinguishes between different Levels of importance.
/// The Urgency enum is supposed to specify those.
enum Urgency {
  /// Only basic information for end users; Not for debugging purposes.
  standard,

  /// Debugging information for unwanted errors.
  relevant,

  /// Literally everything; Even wanted user interaction with the software.
  cautious,
}
