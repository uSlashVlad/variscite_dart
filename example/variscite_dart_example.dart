import 'package:variscite_dart/variscite_dart.dart';

void main() async {
  // Create new API instance
  final api = VarisciteApi();

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
}
