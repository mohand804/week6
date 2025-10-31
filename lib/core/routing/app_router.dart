import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week6/core/di/dependency_injection.dart';
import 'package:week6/core/routing/routes.dart';
import 'package:week6/features/home/home_screen.dart';
import 'package:week6/features/home/logic/cubit/home_cubit.dart';
import 'package:week6/features/movei_details/logic/cubit/movie_deatils_cubit.dart';
import 'package:week6/features/movei_details/movie_details_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<HomeCubit>(),
            child: const HomeScreen(),
          ),
        );
      case Routes.movieDetails:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<MovieDeatilsCubit>(),
            child: MovieDetailsScreen(movieId: arguments as int),
          ),
        );
      default:
        return null;
    }
  }
}
