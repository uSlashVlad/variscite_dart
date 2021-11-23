[Также доступно на русском языке](README_RU.md)

# Variscite Dart

[![Pub Package](https://img.shields.io/pub/v/variscite_dart.svg)](https://pub.dev/packages/variscite_dart)
[![GitHub License](https://img.shields.io/badge/License-MIT-blue.svg)](https://raw.githubusercontent.com/uslashvlad/variscite_dart/master/LICENSE)

**Part of "Variscite" project. Here is also [API](https://github.com/uSlashVlad/variscite_api) and [client app](https://github.com/uSlashVlad/variscite_mobile)**

Library for [Dart](https://dart.dev) programming language for work with [Variscite API](https://github.com/uSlashVlad/variscite_api). Written poorly with Dart and uses this libraries:

- **dio** - library for working with HTTP, creating and sending requests to API
- **geojson_vi** - library for working with GeoJSON objects, namely for constructing them from JSON
- **equatable** - auxiliary library for more convenient comparation of API objects

Library implements all API endpoints of version 0.3, you can find list of all methods in file _lib/src/api.dart_

# Examples

Group creation and login:

```dart
import 'package:variscite_dart/variscite_dart.dart';

void main() async {
    // At the start, it is necessary to initialize VarisciteApi
    // class. It performs all functions, related to API
    final api = VarisciteApi();

    // Creation of group with name "New group" and admin password
    // "qwerty"
    final group = await api.createNewGroup(
        GroupCreationBody(name: 'New group', passcode: 'qwerty'),
    );

    // Logging in group with name "Admin" and passcode "qwerty"
    // If passcode doesn't exists, user won't have admins rights
    final user = await api.loginUsingInviteCode(
        group.inviteCode,
        UserLoginBody(name: 'Admin', passcode: 'qwerty'),
    );

    // Setting up user token, token is needed for any of farther
    // actions, related to group
    api.setToken(user.token);
}
```

Retrieving group information and list of users:

```dart
import 'package:variscite_dart/variscite_dart.dart';

void main() async {
    final api = VarisciteApi(token: 'super.secret.token');

    // Retrieving group information: name, invite code, id
    final groupInfo = await api.getCurrentGroupInfo();

    // Retrieving list of users, each element contains name,
    // rights information (admin or not) and user id
    final users = await api.getUsersList();
}
```

Working with geographical structures:

```dart
import 'package:variscite_dart/variscite_dart.dart';

void main() async {
    final api = VarisciteApi(token: 'super.secret.token');

    // Retrieving list of all structures, each element contains
    // structure' id and id of user created it, additional fields
    // (they can be edited separately) and most important -
    // GeoJSON object (it has FeatureCollection type)
    final structures = await api.getAllStructures();

    // Creating Map object that contains GeoJSON object
    final feature = {
        'type': 'FeatureCollection',
        'features': [
            {
                'type': 'Feature',
                'properties': {},
                'geometry': {
                'type': 'Polygon',
                    'coordinates': [
                        [
                            [34.453125, 54.007768],
                            [40.78125, 54.007768],
                            [40.78125, 57.326521],
                            [34.453125, 57.326521],
                            [34.453125, 54.007768],
                        ],
                    ],
                },
            },
        ],
    };
    // Transforming Map<String, dynamic> into GeoJSONFeatureCollection
    final collectionGeoJSON = GeoJSONFeatureCollection.fromMap(feature);

    // Creating structure from GeoJSON object, storing it into
    // database
    final newStruct = await api.addNewStructure(collectionGeoJSON);
}
```

Working with geolocation:

```dart
import 'package:variscite_dart/variscite_dart.dart';

void main() async {
    final api = VarisciteApi(token: 'super.secret.token');

    // Retrieving geolocation of all users with open geolocation
    // in group
    final allLocations = await api.getAllGeolocation();
    // If you need to remove geolocation of current user
    // (user that sended request), you can achive it by passing
    // "excludeUser: true" argument
    final almostAllLocations = await api.getAllGeolocation(excludeUser: true);

    // Updating geolocation of current user
    await api.editCurrentUserGeolocation(GeolocationPosition(
        latitude: 37.478860,
        longitude: 55.670802,
    ));
}
```

Specifying address of your own API:

```dart
import 'package:variscite_dart/variscite_dart.dart';

void main() async {
    // In this case reqiests will be sended to https://example.com
    final api = VarisciteApi(serviceUrl: 'https://example.com');
}
```
