import 'package:auto_route/auto_route.dart';

import '../../features/home/screens/home_screen.dart';
import '../../features/permisions/screens/permissions_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: PermissionsRoute.page, initial: true),
    AutoRoute(page: HomeRoute.page),
  ];
}
