import 'network.dart';
import 'models.dart';
import 'consts.dart';

import 'package:geojson_vi/geojson_vi.dart';

class VarisciteApi {
  late RequestsHandler _req;
  String? _token;

  String? get userToken => _token;
  bool get hasToken => _token != null;

  VarisciteApi({String? serviceUrl, String? token}) {
    if (token != null) {
      _token = token;
      _req = RequestsHandler(
        serviceUrl ?? defaultTestServerUrl,
        headers: _genTokenHeader(token),
      );
    } else {
      _req = RequestsHandler(
        serviceUrl ?? defaultTestServerUrl,
      );
    }
  }

  void setToken(String token) {
    _token = token;
    _req = RequestsHandler(
      defaultTestServerUrl,
      headers: _genTokenHeader(token),
    );
  }

  Map<String, String> _genTokenHeader(String token) {
    return {'Authorization': 'Bearer $token'};
  }

  Future<GroupCreationOutput> createNewGroup(GroupCreationBody body) async {
    final res = await _req.postRequest('/groups', body.toMap());
    return GroupCreationOutput.fromMap(res.data);
  }

  Future<UserLoginOutput> loginUsingInviteCode(
    String inviteCode,
    UserLoginBody body,
  ) async {
    final res = await _req.postRequest('/groups/$inviteCode', body.toMap());
    return UserLoginOutput.fromMap(res.data);
  }

  Future<GroupInfo> getCurrentGroupInfo() async {
    final res = await _req.getRequest('/groups/my');
    return GroupInfo.fromMap(res.data);
  }

  Future<void> deleteCurrentGroup() async {
    await _req.deleteRequest('/groups/my');
  }

  Future<List<UserInfo>> getUsersList() async {
    final res = await _req.getRequest('/groups/my/users');
    final userMaps = res.data as List;
    return userMaps.map((map) => UserInfo.fromMap(map)).toList();
  }

  Future<UserInfo> getUser(String userId) async {
    final res = await _req.getRequest('/groups/my/users/$userId');
    return UserInfo.fromMap(res.data);
  }

  Future<void> deleteUser(String userId) async {
    await _req.deleteRequest('/groups/my/users/$userId');
  }

  Future<UserInfo> getCurrentUserInfo() async {
    final res = await _req.getRequest('/groups/my/users/me');
    return UserInfo.fromMap(res.data);
  }

  Future<void> deleteCurrentUser() async {
    await _req.deleteRequest('/groups/my/users/me');
  }

  Future<List<GeoStruct>> getAllStructures() async {
    final res = await _req.getRequest('/structures');
    final structMaps = res.data as List;
    return structMaps.map((map) => GeoStruct.fromMap(map)).toList();
  }

  Future<GeoStruct> addNewStructure(GeoJSONFeatureCollection geojson) async {
    final res = await _req.postRequest('/structures', geojson.toMap());
    return GeoStruct.fromMap(res.data);
  }

  Future<GeoStruct> getStructure(String structId) async {
    final res = await _req.getRequest('/structures/$structId');
    return GeoStruct.fromMap(res.data);
  }

  Future<GeoStruct> editStructure(
    String structId,
    GeoJSONFeatureCollection geojson,
  ) async {
    final res = await _req.putRequest('/structures/$structId', geojson.toMap());
    return GeoStruct.fromMap(res.data);
  }

  Future<void> deleteStructure(String structId) async {
    await _req.deleteRequest('/structures/$structId');
  }

  Future<Map<String, dynamic>> getStructureFields(String structId) async {
    final res = await _req.getRequest('/structures/$structId/fields');
    return Map.castFrom(res.data);
  }

  Future<Map<String, dynamic>> postStructureFields(
    String structId,
    Map<String, dynamic> fields,
  ) async {
    final res = await _req.postRequest('/structures/$structId/fields', fields);
    return Map.castFrom(res.data);
  }

  Future<Map<String, dynamic>> deleteStructureFields(
    String structId,
    List<String> fields,
  ) async {
    final fieldsStr = fields.join(',');
    final res = await _req.deleteRequest('/structures/$structId/fields'
        '?fields=$fieldsStr');
    return Map.castFrom(res.data);
  }

  Future<List<UserGeolocationOutput>> getAllGeolocation() async {
    final res = await _req.getRequest('/location/all');
    final locationMaps = res.data as List;
    return locationMaps
        .map((map) => UserGeolocationOutput.fromMap(map))
        .toList();
  }

  Future<GeolocationPosition> getUserGeolocation(String userId) async {
    final res = await _req.getRequest('/location/$userId');
    return GeolocationPosition.fromMap(res.data);
  }

  Future<GeolocationPosition> getCurrentUserGeolocation() async {
    final res = await _req.getRequest('/location/my');
    return GeolocationPosition.fromMap(res.data);
  }

  Future<GeolocationPosition> editCurrentUserGeolocation(
      GeolocationPosition position) async {
    final res = await _req.putRequest('/location/my', position.toMap());
    return GeolocationPosition.fromMap(res.data);
  }

  Future<void> deleteCurrentGeolocation() async {
    await _req.deleteRequest('/location/my');
  }
}
