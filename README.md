# Usyre

## Description

The Usyre project is a user management and authentication platform written completely in Dart and mostly by myself.
Its purpose is to give some bare minimum backend functionalities like user and session management for inclusion in other projects.

## Functionality

The base of Usyre is the [storage](lib/storage/) lib.
It can save objects implementing the [Container](lib/storage/container.dart) interface automatically to a MongoDB server instance.
The storage itself is single-threaded and kept quite simple. Performance is therefore not nearly equivalent with complex databases.
Still, for a user management platform it should be enough.

The interaction is done through an HTTP endpoint. There's no official API documentation at the moment.
For further information, either look at the source code or use the autogenerated documentation by ```dart doc```.

## Usage

Clone the repository and name it 'usyre' for compatibility with the Dart package naming scheme.
While having the Dart SDK installed on your system,
either run the application directly or build the project as a binary with ```dart build``` (Use [bin/main.dart](bin/main.dart) as the entry point).
For persistent storage, Usyre uses a MongoDB instance in the background.

## Configuration

Configuration of the Usyre application is solely done through environment variables.
The table gives an overview about possible configuration values.

| Environment variable    | Description                                                     |
|-------------------------|-----------------------------------------------------------------|
| ADMIN_USERNAME          | Username of an default admin user.                              |
| ADMIN_PASSWORD          | Password of an default admin user.                              |
| DB_PORT                 | Port of the MongoDB instance.                                   |
| DB_LOCATION             | Hostname / IP-Address of the MongoDB instance.                  |
| DB_DATABASE             | Name of the database.                                           |
| DB_USERNAME             | Username to access the database.                                |
| DB_PASSWORD             | Password to access the database.                                |
| LOGGING_URGENCY         | Log urgency: ```standard```, ```relevant``` and ```cautious```. |
| LOGGING_LENGTH_STANDARD | Amount of standard logging records stored.                      |
| LOGGING_LENGTH_RELEVANT | Amount of relevant logging records stored.                      |
| LOGGING_LENGTH_CAUTIOUS | Amount of cautious logging records stored.                      |
