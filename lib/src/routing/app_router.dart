import 'package:auto_route/auto_route.dart';
import '../features/homepage/view/homepage_view.dart';
import '../features/navigatorpage/view/navigator_view.dart';
import '../features/shopingListPage/view/shoping_list_view.dart';
part 'app_router.gr.dart';

@AutoRouterConfig(generateForDir: ['lib/src/features'])
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: NavigatorRoute.page, path: '/'),
        AutoRoute(page: HomeRoute.page, path: '/home'),
        AutoRoute(page: ListRoute.page, path: '/list')
      ];
}
