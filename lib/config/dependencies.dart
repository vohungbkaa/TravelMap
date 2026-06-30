import 'package:provider/single_child_widget.dart';
import 'package:travel_map/config/di/auth_module.dart';
import 'package:travel_map/config/di/base_module.dart';
import 'package:travel_map/config/di/map_module.dart';
import 'package:travel_map/config/di/news_module.dart';
import 'package:travel_map/config/di/shop_module.dart';
import 'package:travel_map/config/di/trips_module.dart';
import 'package:travel_map/config/di/users_module.dart';

List<SingleChildWidget> get providersDevelopment {
  return [
    ...baseModule,
    ...authModule,
    ...usersModule,
    ...tripsModule,
    ...newsModule,
    ...shopModule,
    ...mapModule,
  ];
}
