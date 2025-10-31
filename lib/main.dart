import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:week6/core/di/dependency_injection.dart';
import 'package:week6/core/routing/app_router.dart';
import 'package:week6/features/home/data/cache/home_cache_service.dart';
import 'package:week6/features/movei_details/data/cache/movie_deatils_cache_service.dart';
import 'package:week6/week6.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HomeCacheService.init();
  await MovieDetailsCacheService.init();
  await setupGetIt();
  await SentryFlutter.init((options) {
    options.dsn =
        'https://ac479075dcbd5f94d6d1eedd34a8b8c1@o4510239871729664.ingest.us.sentry.io/4510273972600832';
    options.tracesSampleRate = 1.0;
    options.profilesSampleRate = 1.0;
    options.attachStacktrace = true;
    options.attachScreenshot = true;
    options.attachViewHierarchy = true;
    options.attachViewHierarchy = true;
  });
  runApp(Week6(appRouter: AppRouter()));
}
