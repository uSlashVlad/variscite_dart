[Also available on English](README.md)

# Variscite Dart

**Часть проекта "Варисцит". Также есть [API](https://github.com/uSlashVlad/variscite_api) и [клиентское приложение](https://github.com/uSlashVlad/variscite_mobile)**

Библиотека для языка программирования [Dart](https://dart.dev) для работы с [Variscite API](https://github.com/uSlashVlad/variscite_api). Написано полностью на Dart и использует следующие библиотеки:

- **dio** - библиотека для работы с HTTP, составление и отправка запросов к API
- **geojson_vi** - библиотека для работы с GeoJSON объектами, а именно составление их из JSON
- **equatable** - вспомогательная библиотека для более удобного дальнейшего сравнения объектов API

В библиотеке реализованы все конечные точки API версии 0.3, список всех методов можно найти в файле _lib/src/api.dart_

# Примеры

Создание группы и вход:

```dart
import 'package:variscite_dart/variscite_dart.dart';

void main() async {
    // Для начала необходимо создать экземпляр класса VarisciteApi
    // Именно он выполняет все функции по работе с API
    final api = VarisciteApi();

    // Создание группы с имененм "New group" и паролем
    // администратора "qwerty"
    final group = await api.createNewGroup(
        GroupCreationBody(name: 'New group', passcode: 'qwerty'),
    );

    // Вход в группу под именем "Admin" и с вводом пароля
    // Если passcode не введён, то пользователь не будет обладать
    // правами администратора
    final user = await api.loginUsingInviteCode(
        group.inviteCode,
        UserLoginBody(name: 'Admin', passcode: 'qwerty'),
    );

    // Установка токена, токен необходим для выполнения любых
    // дальшейших действий, связанных с группой
    api.setToken(user.token);
}
```

Получение информации о группе и списка её участников:

```dart
import 'package:variscite_dart/variscite_dart.dart';

void main() async {
    final api = VarisciteApi(token: 'super.secret.token');

    // Получаем информацию о группе: имя, код приглашения, id
    final groupInfo = await api.getCurrentGroupInfo();

    // Получаем список пользователей, каждый элемент списка
    // содержит имя, информацию о правах (админ или нет) и id
    // пользователя
    final users = await api.getUsersList();
}
```

Работа с географическими структурами:

```dart
import 'package:variscite_dart/variscite_dart.dart';

void main() async {
    final api = VarisciteApi(token: 'super.secret.token');

    // Получаем список структур, каждый элемент содержит id
    // структуры и id пользователя, создавшего её, дополнительные
    // поля (которые можно отдельно свободно редактировать) и,
    // самое главное, GeoJSON объект (который имеет тип
    // FeatureCollection)
    final structures = await api.getAllStructures();

    // Создания Dart объекта (Map<String, dynamic>), который бы
    // хранил полный GeoJSON объект
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
    // Превращение Map<String, dynamic> в GeoJSONFeatureCollection
    final collectionGeoJSON = GeoJSONFeatureCollection.fromMap(feature);

    // Создание структуры из GeoJSON объекта, сохранение его в
    // базе данных
    final newStruct = await api.addNewStructure(collectionGeoJSON);
}
```

Работа с геолокацией:

```dart
import 'package:variscite_dart/variscite_dart.dart';

void main() async {
    final api = VarisciteApi(token: 'super.secret.token');

    // Получение геолокации всех пользователей в группе с
    // открытой геолокацией
    final allLocations = await api.getAllGeolocation();
    // Если надо убрать геолокацию текущего пользователя
    // (пользователя, который отправляет запрос), то можно добиться
    // этого путём добавления аргумента "excludeUser: true"
    final almostAllLocations = await api.getAllGeolocation(excludeUser: true);

    // Обновление геолокации текущего пользователя
    await api.editCurrentUserGeolocation(GeolocationPosition(
        latitude: 37.478860,
        longitude: 55.670802,
    ));
}
```

Указание адреса собственного API:

```dart
import 'package:variscite_dart/variscite_dart.dart';

void main() async {
    // В таком случае разпросы к API будет идти по адресу
    // https://example.com
    final api = VarisciteApi(serviceUrl: 'https://example.com');
}
```
