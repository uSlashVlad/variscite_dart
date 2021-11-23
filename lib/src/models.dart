import 'package:equatable/equatable.dart';
import 'package:geojson_vi/geojson_vi.dart';

abstract class ApiModel extends Equatable {
  const ApiModel();
}

abstract class RequestBodyInterface {
  Map<String, dynamic> toMap();
}

// I can't do the same interface for responce body and fromMap() method
// since here is no way in dart to create static inheretible methods
// So you really should be careful with this method and with such classes

class GroupCreationBody extends ApiModel implements RequestBodyInterface {
  final String name;
  final String passcode;

  const GroupCreationBody({
    required this.name,
    required this.passcode,
  });

  @override
  List<Object?> get props => [name, passcode];

  @override
  Map<String, dynamic> toMap() => {
        'name': name,
        'passcode': passcode,
      };
}

class GroupCreationOutput extends ApiModel {
  final String id;
  final String inviteCode;

  const GroupCreationOutput({
    required this.id,
    required this.inviteCode,
  });

  @override
  List<Object?> get props => [id, inviteCode];

  static GroupCreationOutput fromMap(map) => GroupCreationOutput(
        id: map['id'],
        inviteCode: map['inviteCode'],
      );
}

class UserLoginBody extends ApiModel implements RequestBodyInterface {
  final String name;
  final String? passcode;

  const UserLoginBody({
    required this.name,
    this.passcode,
  });

  @override
  List<Object?> get props => [name, passcode];

  @override
  Map<String, dynamic> toMap() => {
        'name': name,
        'passcode': passcode,
      };
}

class UserLoginOutput extends ApiModel {
  final String id;
  final String token;

  const UserLoginOutput({
    required this.id,
    required this.token,
  });

  @override
  List<Object?> get props => [id, token];

  static UserLoginOutput fromMap(map) => UserLoginOutput(
        id: map['id'],
        token: map['token'],
      );
}

class GroupInfo extends ApiModel {
  final String id;
  final String name;
  final String inviteCode;

  const GroupInfo({
    required this.id,
    required this.name,
    required this.inviteCode,
  });

  @override
  List<Object?> get props => [id, name, inviteCode];

  static GroupInfo fromMap(map) => GroupInfo(
        id: map['id'],
        name: map['name'],
        inviteCode: map['inviteCode'],
      );
}

class UserInfo extends ApiModel {
  final String id;
  final String name;
  final bool isAdmin;

  const UserInfo({
    required this.id,
    required this.name,
    required this.isAdmin,
  });

  @override
  List<Object?> get props => [id, name, isAdmin];

  static UserInfo fromMap(map) => UserInfo(
        id: map['id'],
        name: map['name'],
        isAdmin: map['isAdmin'],
      );
}

class GeoStruct extends ApiModel {
  final String id;
  final String user;
  final Map<String, dynamic> fields;
  final GeoJSONFeatureCollection struct;

  const GeoStruct({
    required this.id,
    required this.user,
    required this.fields,
    required this.struct,
  });

  @override
  List<Object?> get props => [id, user, fields, struct];

  static GeoStruct fromMap(map) => GeoStruct(
        id: map['id'],
        user: map['user'],
        fields: Map.castFrom(map['fields']),
        struct: GeoJSONFeatureCollection.fromMap(Map.castFrom(map['struct'])),
      );
}

class UserGeolocationOutput extends ApiModel {
  final String user;
  final GeolocationPosition position;

  const UserGeolocationOutput({
    required this.user,
    required this.position,
  });

  @override
  List<Object?> get props => [user, position];

  static UserGeolocationOutput fromMap(map) => UserGeolocationOutput(
        user: map['user'],
        position: GeolocationPosition.fromMap(map['position']),
      );
}

class GeolocationPosition extends ApiModel implements RequestBodyInterface {
  final double latitude;
  final double longitude;

  const GeolocationPosition({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];

  @override
  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'longitude': longitude,
      };

  static GeolocationPosition fromMap(map) => GeolocationPosition(
        latitude: map['lat'] + .0,
        longitude: map['lon'] + .0,
      );
}
