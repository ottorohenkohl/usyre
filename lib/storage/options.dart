/// Class for applying loading options.
///
/// Through the Options class you should be able
/// to apply filters when loading a Container through the
/// Storage class.
class Options {
  /// Options regarding the Container's values.
  final String? containerID;
  final String? description;

  /// Option regarding the Container's type.
  final bool? solo;
  final Type? type;

  Options({
    this.containerID,
    this.description,
    this.solo,
    this.type,
  });
}
