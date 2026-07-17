import 'package:ai_photo_generator/features/bottom_nav/bottom_nav_bindings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ai_photo_generator/core/di/di_repo.dart';
import 'package:ai_photo_generator/core/routes/app_pages.dart';
import 'package:ai_photo_generator/core/services/remote_config_service/remote_config_service.dart';
import 'core/theme/app_theme.dart';
import 'package:ai_photo_generator/domain/di_use_case.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RemoteConfigService().initialize();

  ///Initializing UseCase and Repo Dependencies <- Start ->
  final RepoDependencies repoDependencies = RepoDependencies();
  await repoDependencies.init().whenComplete(() {});
  await repoDependencies.initializeRepoDependencies();
  await initializeModelUseCasesDependencies();

  ///Initializing UseCase and Repo Dependencies <- End ->
  ///
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'AI Photo Generator',
          theme: AppTheme.dark,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.dark,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          debugShowCheckedModeBanner: false,
          initialBinding: BottomNavBindings(),
        );
      },
    );
  }
}
