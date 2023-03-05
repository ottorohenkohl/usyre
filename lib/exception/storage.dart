/// Exception in case the Container is invalid.
class ContainerInvalidException implements Exception {
  final String description = 'The specified item is not valid.';

  ContainerInvalidException();

  @override
  String toString() => description;
}

/// Exception in case there is no desired Container.
class ContainerMissingException implements Exception {
  final String description = 'The desired item does not exist.';

  ContainerMissingException();

  @override
  String toString() => description;
}

/// Exception in case there is no matching ContainerConverter.
class ConverterMissingException implements Exception {
  final String description = 'There is no Converter matching specified.';

  ConverterMissingException();

  @override
  String toString() => description;
}

/// Exception in case no database connection can be established.
class DatabaseConnectionFailedException implements Exception {
  final String description = 'Could not connect to the database.';

  DatabaseConnectionFailedException();

  @override
  String toString() => description;
}

/// Exception in case a Database transaction has failed.
class DatabaseTransactionFailedException implements Exception {
  final String description = 'Could not interact with the database.';

  DatabaseTransactionFailedException();

  @override
  String toString() => description;
}

/// Exception in case a Datasheet is invalid.
class DatasheetInvalidException implements Exception {
  final String description = 'Datasheet is not valid.';

  DatasheetInvalidException();

  @override
  String toString() => description;
}
