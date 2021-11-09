import 'package:variscite_dart/variscite_dart.dart';
import 'package:geojson_vi/geojson_vi.dart';

void main() async {
  // Create new API instance
  final api = VarisciteApi();

  // Creating new group and user
  final group = await api.createNewGroup(
    GroupCreationBody(name: 'New awesome group', passcode: 'qwerty'),
  );
  final user = await api.loginUsingInviteCode(
    group.inviteCode,
    UserLoginBody(name: 'Admin', passcode: 'qwerty'),
  );
  api.setToken(user.token);
  final groupInfo = await api.getCurrentGroupInfo();

  print('Group "${groupInfo.name}"');

  // Create new structure
  final feature = {
    'type': 'FeatureCollection',
    'features': [
      {
        'type': 'Feature',
        'properties': <String, dynamic>{},
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
  final collectionGeoJSON = GeoJSONFeatureCollection.fromMap(feature);
  final newStruct = await api.addNewStructure(collectionGeoJSON);

  print('Structure id: ${newStruct.id}');

  // Delete the group after all
  await api.deleteCurrentGroup();
}
