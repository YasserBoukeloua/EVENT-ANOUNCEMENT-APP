import 'dart:io';
import 'package:eventify/cubits/repost/repost_cubit.dart';
import 'package:eventify/data/repo/favorite/favorite_repository.dart';
import 'package:eventify/data/repo/repost/repost_repository.dart';
import 'package:eventify/screens/home/home_screen.dart';
import 'package:eventify/screens/favorite/favorite_screen.dart';
import 'package:eventify/screens/profile/profile_screen.dart';
import 'package:eventify/screens/login/login_screen.dart';
import 'package:eventify/screens/repost/repost_screen.dart';
import 'package:eventify/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eventify/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Import repositories
import 'package:eventify/repositories/auth_repository.dart';
import 'package:eventify/repositories/events_repository.dart';
import 'package:eventify/repositories/favorites_repository.dart';
import 'package:eventify/repositories/profile_repository.dart';
import 'package:eventify/repositories/reposts_repository.dart';

// Import cubits
import 'package:eventify/cubits/events/events_cubit.dart';
import 'package:eventify/cubits/favorites/favorites_cubit.dart';
import 'package:eventify/cubits/profile/profile_cubit.dart';
import 'package:eventify/cubits/navigation/navigation_cubit.dart';
import 'package:eventify/cubits/navigation/navigation_state.dart';
import 'package:eventify/cubits/settings/settings_cubit.dart';

// Import database
import 'package:eventify/data/databases/dbhelper.dart';
import 'package:eventify/data/databases/database_seeder.dart';

Future<void> initializeApp() async {
  // Initialize sqflite for desktop platforms
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize database
  await DBHelper.getDatabase();
  
  // Seed database with initial data
  await DatabaseSeeder.seedDatabase();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize app and database
  await initializeApp();

  // Set status bar color to purple with white icons
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryDark,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize repositories
    final authRepository = AuthRepository();
    final eventsRepository = EventsRepository();
    final favoriteRepository = FavoriteRepository();
    final repostRepository = RepostRepository();
    final repostsRepository = RepostsRepository(repostRepository);
    final favoritesRepository = FavoritesRepository(favoriteRepository);
    final profileRepository = ProfileRepository();

    return MultiBlocProvider(
      providers: [
        // Global cubits that persist across the app
        BlocProvider<EventsCubit>(
          create: (context) => EventsCubit(eventsRepository)..loadEvents(),
        ),
        BlocProvider<FavoritesCubit>(
          create: (context) => FavoritesCubit(favoritesRepository)..loadFavorites(),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(profileRepository, authRepository)..loadProfile(),
        ),
        BlocProvider<SettingsCubit>(
          create: (context) => SettingsCubit(),
        ),
        BlocProvider<RepostCubit>(
          create: (context) => RepostCubit(repostsRepository)..loadReposts(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'JosefinSans',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: const HomeAppContent(),
    );
  }
}

class HomeAppContent extends StatelessWidget {
  const HomeAppContent({super.key});

  List<Widget> _buildPages(BuildContext context, Function(int) onTabChange) {
    return [
      Home(onTabChange: onTabChange),
      const RepostScreen(),
      const FavoritesScreen(),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, navigationState) {
        final selectedIndex = navigationState.selectedIndex;
        final navigationCubit = context.read<NavigationCubit>();

        void onItemTapped(int index) {
          navigationCubit.changePage(index);
        }

        return Scaffold(
          extendBody: true,
          body: _buildPages(context, onItemTapped)[selectedIndex],
          bottomNavigationBar: SizedBox(
            height: 55,
            child: Container(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () => onItemTapped(0),
                          icon: const Icon(
                            Icons.home_outlined,
                            size: 26,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () => onItemTapped(1),
                          icon: const Icon(
                            Icons.repeat,
                            size: 26,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () => onItemTapped(2),
                          icon: const Icon(
                            Icons.star_border_outlined,
                            size: 26,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () => onItemTapped(3),
                          icon: const Icon(
                            Icons.person_outline_outlined,
                            size: 26,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

