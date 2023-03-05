import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:usyre/exception/generic.dart';
import 'package:usyre/exception/registry.dart';
import 'package:usyre/exception/storage.dart';
import 'package:usyre/exception/user.dart';
import 'package:usyre/logging/logger.dart';
import 'package:usyre/logging/record.dart';
import 'package:usyre/logging/urgency.dart';

/// Class for automatically handling HTTP responses.
///
/// The ResponseTemplate can be used to return predefined HTTP responses.
/// Responses are based on the different kind of attributes given.
class ResponseTemplate {
  ResponseTemplate();

  /// Method for returning a standard success response.
  Response success(Map? body) {
    var response = <dynamic, dynamic>{
      'info': {
        'status': 200,
        'title': 'OK',
        'description': 'Request performed successfully!',
        'explanation': 'https://www.rfc-editor.org/rfc/rfc7231#section-6.3.1'
      },
      'data': {},
    };

    if (body != null) {
      response['data'].addAll(body);
    }

    return Response(
      200,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(response),
    );
  }

  /// Method for parsing a exception and returning a matching response.
  Response errored(Map? body, exception, stacktrace) {
    var payload = <dynamic, dynamic>{
      'info': {},
      'data': {},
    };

    if (body != null) {
      payload['data'].addAll(body);
    }

    switch (exception.runtimeType) {
      /// Generic exceptions.
      case BadRequestException:
        payload['info']['status'] = 400;
        payload['info']['title'] = 'Bad Request';
        payload['info']['description'] = exception.description;
        payload['info']['explanation'] =
            'https://www.rfc-editor.org/rfc/rfc7231#section-6.5.1';
        break;
      case ForbiddenException:
        payload['info']['status'] = 403;
        payload['info']['title'] = 'Forbidden';
        payload['info']['description'] = exception.description;
        payload['info']['explanation'] =
            'https://www.rfc-editor.org/rfc/rfc7231#section-6.5.3';
        break;

      case NotFoundException:
        payload['info']['status'] = 404;
        payload['info']['title'] = 'Not Found';
        payload['info']['description'] = exception.description;
        payload['info']['explanation'] =
            'https://www.rfc-editor.org/rfc/rfc7231#section-6.5.4';
        break;

      /// Registry Exceptions.
      case SessionMissingException:
        payload['info']['status'] = 403;
        payload['info']['title'] = 'Forbidden';
        payload['info']['description'] = exception.description;
        payload['info']['explanation'] =
            'https://www.rfc-editor.org/rfc/rfc7231#section-6.5.3';
        break;

      /// Storage exceptions.
      case ContainerInvalidException:
        payload['info']['status'] = 400;
        payload['info']['title'] = 'Bad Request';
        payload['info']['description'] = exception.description;
        payload['info']['explanation'] =
            'https://www.rfc-editor.org/rfc/rfc7231#section-6.5.1';
        break;
      case ContainerMissingException:
        payload['info']['status'] = 404;
        payload['info']['title'] = 'Not Found';
        payload['info']['description'] = exception.description;
        payload['info']['explanation'] =
            'https://www.rfc-editor.org/rfc/rfc7231#section-6.5.4';
        break;
      case ConverterMissingException:
        payload['info']['status'] = 500;
        payload['info']['title'] = 'Internal Server Error';
        payload['info']['description'] = exception.description;
        payload['info']['explanation'] =
            'https://www.rfc-editor.org/rfc/rfc7231#section-6.6.1';
        break;
      case DatabaseConnectionFailedException:
        payload['info']['status'] = 500;
        payload['info']['title'] = 'Internal Server Error';
        payload['info']['description'] = exception.description;
        payload['info']['explanation'] =
            'https://www.rfc-editor.org/rfc/rfc7231#section-6.6.1';
        break;
      case DatabaseTransactionFailedException:
        payload['info']['status'] = 500;
        payload['info']['title'] = 'Internal Server Error';
        payload['info']['description'] = exception.description;
        payload['info']['explanation'] =
            'https://www.rfc-editor.org/rfc/rfc7231#section-6.6.1';
        break;
      case DatasheetInvalidException:
        payload['info']['status'] = 500;
        payload['info']['title'] = 'Internal Server Error';
        payload['info']['description'] = exception.description;
        payload['info']['explanation'] =
            'https://www.rfc-editor.org/rfc/rfc7231#section-6.6.1';
        break;

      /// User exceptions.
      case UsernameTakenException:
        payload['info']['status'] = 409;
        payload['info']['title'] = 'Conflict';
        payload['info']['description'] = exception.description;
        payload['info']['explanation'] =
            'https://www.rfc-editor.org/rfc/rfc7231#section-6.5.8';
        break;

      /// No known exception given.
      default:
        payload['info']['status'] = 500;
        payload['info']['title'] = 'Internal Server Error';
        payload['info']['description'] =
            'Something went wrong. Contact the admin';
        payload['info']['explanation'] =
            'https://www.rfc-editor.org/rfc/rfc7231#section-6.6.1';
    }

    Logger().toOverall(
      Record(
        urgency: Urgency.standard,
        header: payload['info']['title'],
        detail: payload['info']['description'],
        tracer: stacktrace.toString(),
      ),
    );

    return Response(
      payload['info']['status'],
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
  }
}
