/// Exception in case there is no Session.
class BadRequestException implements Exception {
  final String description = 'The given input can not be processed.';

  BadRequestException();

  @override
  String toString() => description;
}

/// Exception in case there is no Session.
class ForbiddenException implements Exception {
  final String description = 'You are not allowed to perform this action.';

  ForbiddenException();

  @override
  String toString() => description;
}

/// Exception in case the resource does not exist.
class NotFoundException implements Exception {
  final String description = 'The resource does not exist.';

  NotFoundException();

  @override
  String toString() => description;
}
