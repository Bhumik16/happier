import 'package:get_it/get_it.dart';

// Import repositories (only implemented ones)
import 'repository/meditation_repository/meditation_repository.dart';
import 'repository/course_repository/course_repository.dart';
import 'repository/shorts_repository/shorts_repository.dart';
import 'repository/singles_repository/singles_repository.dart';
import 'repository/sleeps_repository/sleeps_repository.dart';

/// ====================
/// DEPENDENCY INJECTION SETUP
/// ====================
///
/// Configures GetIt for dependency injection
/// Called once during app initialization

Future<void> setupDependencyInjection() async {
  final getIt = GetIt.instance;

  print('🔧 Setting up dependency injection...\n');

  // ====================
  // REGISTER REPOSITORIES (Only implemented ones)
  // ====================

  getIt.registerLazySingleton<MeditationRepository>(
    () => MeditationRepository(),
  );
  getIt.registerLazySingleton<CourseRepository>(() => CourseRepository());
  getIt.registerLazySingleton<ShortsRepository>(() => ShortsRepository());
  getIt.registerLazySingleton<SinglesRepository>(() => SinglesRepository());
  getIt.registerLazySingleton<SleepsRepository>(() => SleepsRepository());

  print('✅ Repositories registered');
  print('✅ Dependency injection setup complete!\n');
}
