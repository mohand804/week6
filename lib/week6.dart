import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:week6/core/di/dependency_injection.dart';
import 'package:week6/core/routing/app_router.dart';
import 'package:week6/core/routing/routes.dart';
import 'package:week6/core/theming/theme_cubit.dart';
import 'package:week6/core/theming/theme_manager.dart';

class Week6 extends StatelessWidget {
  final AppRouter appRouter;
  const Week6({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => BlocProvider(
        create: (context) => getIt<ThemeCubit>(),
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, state) => MaterialApp(
            themeMode: state,
            debugShowCheckedModeBanner: false,
            theme: ThemeManager.getLightTheme(),
            darkTheme: ThemeManager.getDarkTheme(),
            onGenerateRoute: appRouter.generateRoute,
            initialRoute: Routes.home,
          ),
        ),
      ),
    );
  }
}
