import 'package:get/get.dart';
import '../../views/splash_view/screens/splash_view.dart';
import '../../views/main_scaffold/screens/main_scaffold.dart';
import '../../views/course_detail_view/screens/course_detail_view.dart';
import '../../views/video_player_view/screens/video_player_view.dart';
import '../../views/audio_player_view/screens/audio_player_view.dart';
import '../../views/unified_player_view/screens/unified_player_view.dart';
import '../../views/favorites_list_view/screens/favorites_list_view.dart';
import '../../views/collection_detail_view/screens/collection_detail_view.dart';
import '../../views/sleep_detail_view/screens/sleep_detail_view.dart';
import '../../views/sleep_audio_player_view/screens/sleep_audio_player_view.dart';
import '../../views/shorts_video_player_view/screens/shorts_video_player_view.dart';
import '../../views/wisdom_detail_view/screens/wisdom_detail_view.dart';
import '../../views/podcast_detail_view/screens/podcast_detail_view.dart';
import '../../views/podcast_episode_detail_view/screens/podcast_episode_detail_view.dart';
import '../../views/podcast_audio_player_view/screens/podcast_audio_player_view.dart';
// import '../../views/onboarding_view/screens/onboarding_view.dart'; // ✅ COMMENTED OUT - Purple Login Page
import '../../views/user_onboarding_view/screens/user_onboarding_view.dart';
import '../../views/profile_view/screens/profile_view.dart';
import '../../views/profile_favorites_view/screens/profile_favorites_view.dart';
import '../../views/milestones_view/screens/milestones_view.dart';
import '../../views/history_view/screens/history_view.dart';
import '../../views/downloads_view/screens/downloads_view.dart';
import '../../views/settings_view/screens/settings_view.dart';
import '../../views/account_view/screens/account_view.dart';
import '../../views/subscription_view/screens/subscription_view.dart';
import '../../views/premium_upgrade_view/screens/premium_upgrade_view.dart';
import '../../views/notifications_view/screens/notifications_view.dart';
import '../../views/downloads_settings_view/screens/downloads_settings_view.dart';
import '../../views/appearance_view/screens/appearance_view.dart';
import '../../views/chatbot_view/screens/chatbot_view.dart';
import '../../views/search_view/screens/search_view.dart'; // ✅ ADDED FOR SEARCH
import '../../views/teacher_profile_view/screens/teacher_profile_view.dart'; // ✅ ADDED FOR TEACHER PROFILE
import '../../views/recommended_courses_view/screens/recommended_courses_view.dart'; // ✅ ADDED FOR RECOMMENDATIONS

import '../../controllers/splash_controller/splash_bindings.dart';
import '../../controllers/home_controller/home_bindings.dart';
import '../../controllers/course_detail_controller/course_detail_bindings.dart';
import '../../controllers/video_player_controller/video_player_bindings.dart';
import '../../controllers/audio_player_controller/audio_player_bindings.dart';
import '../../controllers/unified_player_controller/unified_player_bindings.dart';
import '../../controllers/favorites_list_controller/favorites_list_bindings.dart';
import '../../controllers/collection_detail_controller/collection_detail_bindings.dart';
import '../../controllers/sleep_detail_controller/sleep_detail_bindings.dart';
import '../../controllers/sleep_audio_player_controller/sleep_audio_player_bindings.dart';
import '../../controllers/shorts_video_player_controller/shorts_video_player_bindings.dart';
import '../../controllers/wisdom_detail_controller/wisdom_detail_bindings.dart';
import '../../controllers/podcast_detail_controller/podcast_detail_bindings.dart';
import '../../controllers/podcast_episode_detail_controller/podcast_episode_detail_bindings.dart';
import '../../controllers/podcast_audio_player_controller/podcast_audio_player_bindings.dart';
// import '../../controllers/auth_controller/auth_bindings.dart'; // ✅ COMMENTED OUT - Not needed for purple login
import '../../controllers/user_onboarding_controller/user_onboarding_bindings.dart';
import '../../controllers/profile_controller/profile_bindings.dart';
import '../../controllers/milestones_controller/milestones_bindings.dart';
import '../../controllers/history_controller/history_bindings.dart';
import '../../controllers/downloads_controller/downloads_bindings.dart';
import '../../controllers/settings_controller/settings_bindings.dart';
import '../../controllers/account_controller/account_bindings.dart';
import '../../controllers/subscription_controller/subscription_bindings.dart';
import '../../controllers/premium_upgrade_controller/premium_upgrade_bindings.dart';
import '../../controllers/notifications_controller/notifications_bindings.dart';
import '../../controllers/downloads_settings_controller/downloads_settings_bindings.dart';
import '../../controllers/appearance_controller/appearance_bindings.dart';
import '../../controllers/chatbot_controller/chatbot_bindings.dart';
import '../../controllers/search_controller/search_bindings.dart'; // ✅ ADDED FOR SEARCH
import '../../controllers/teacher_profile_controller/teacher_profile_bindings.dart'; // ✅ ADDED FOR TEACHER PROFILE
import '../../controllers/recommended_courses_controller/recommended_courses_bindings.dart'; // ✅ ADDED FOR RECOMMENDATIONS

import 'app_routes.dart';

/// ====================
/// APP PAGES
/// ====================
///
/// GetX page routes configuration with smooth transitions

class AppPages {
  // Transition duration constants
  static const _defaultDuration = Duration(milliseconds: 300);
  static const _fastDuration = Duration(milliseconds: 250);
  static const _modalDuration = Duration(milliseconds: 400);

  static final routes = [
    // ====================
    // SPLASH SCREEN (FIRST ROUTE!)
    // ====================
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBindings(),
      transition: Transition.fadeIn,
      transitionDuration: _fastDuration,
    ),

    // ====================
    // ⏭️ PURPLE LOGIN PAGE - COMMENTED OUT (NOT USED)
    // ====================
    // GetPage(
    //   name: AppRoutes.onboarding,
    //   page: () => const OnboardingView(),
    //   binding: AuthBindings(),
    //   transition: Transition.fadeIn,
    //   transitionDuration: _defaultDuration,
    // ),

    // ====================
    // USER ONBOARDING (FIRST TIME SETUP) ✅ ACTIVE
    // ====================
    GetPage(
      name: AppRoutes.userOnboarding,
      page: () => const UserOnboardingView(),
      binding: UserOnboardingBindings(),
      transition: Transition.fadeIn,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // MAIN SCAFFOLD (Home)
    // ====================
    GetPage(
      name: AppRoutes.main,
      page: () => const MainScaffold(),
      binding: HomeBindings(),
      transition: Transition.fadeIn,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // COURSE DETAIL
    // ====================
    GetPage(
      name: AppRoutes.courseDetail,
      page: () => const CourseDetailView(),
      binding: CourseDetailBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // UNIFIED PLAYER (Main player)
    // ====================
    GetPage(
      name: AppRoutes.unifiedPlayer,
      page: () => const UnifiedPlayerView(),
      binding: UnifiedPlayerBindings(),
      transition: Transition.downToUp,
      transitionDuration: _modalDuration,
    ),

    // ====================
    // FAVORITES/RECENTLY PLAYED LIST
    // ====================
    GetPage(
      name: AppRoutes.favoritesList,
      page: () => const FavoritesListView(),
      binding: FavoritesListBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // COLLECTION DETAIL
    // ====================
    GetPage(
      name: AppRoutes.collectionDetail,
      page: () => const CollectionDetailView(),
      binding: CollectionDetailBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // SLEEP DETAIL
    // ====================
    GetPage(
      name: AppRoutes.sleepDetail,
      page: () => const SleepDetailView(),
      binding: SleepDetailBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // SLEEP AUDIO PLAYER
    // ====================
    GetPage(
      name: AppRoutes.sleepAudioPlayer,
      page: () => const SleepAudioPlayerView(),
      binding: SleepAudioPlayerBindings(),
      transition: Transition.downToUp,
      transitionDuration: _modalDuration,
    ),

    // ====================
    // SHORTS VIDEO PLAYER
    // ====================
    GetPage(
      name: AppRoutes.shortsVideoPlayer,
      page: () => const ShortsVideoPlayerView(),
      binding: ShortsVideoPlayerBindings(),
      transition: Transition.fadeIn,
      transitionDuration: _fastDuration,
    ),

    // ====================
    // WISDOM DETAIL
    // ====================
    GetPage(
      name: AppRoutes.wisdomDetail,
      page: () => const WisdomDetailView(),
      binding: WisdomDetailBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // PODCAST DETAIL
    // ====================
    GetPage(
      name: AppRoutes.podcastDetail,
      page: () => const PodcastDetailView(),
      binding: PodcastDetailBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // PODCAST EPISODE DETAIL
    // ====================
    GetPage(
      name: AppRoutes.podcastEpisodeDetail,
      page: () => const PodcastEpisodeDetailView(),
      binding: PodcastEpisodeDetailBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // PODCAST AUDIO PLAYER
    // ====================
    GetPage(
      name: AppRoutes.podcastAudioPlayer,
      page: () => const PodcastAudioPlayerView(),
      binding: PodcastAudioPlayerBindings(),
      transition: Transition.downToUp,
      transitionDuration: _modalDuration,
    ),

    // ====================
    // PROFILE
    // ====================
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // PROFILE FAVORITES
    // ====================
    GetPage(
      name: AppRoutes.profileFavorites,
      page: () => const ProfileFavoritesView(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // MILESTONES
    // ====================
    GetPage(
      name: AppRoutes.milestones,
      page: () => const MilestonesView(),
      binding: MilestonesBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // HISTORY
    // ====================
    GetPage(
      name: AppRoutes.history,
      page: () => const HistoryView(),
      binding: HistoryBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // DOWNLOADS
    // ====================
    GetPage(
      name: AppRoutes.downloads,
      page: () => const DownloadsView(),
      binding: DownloadsBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // SETTINGS
    // ====================
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: SettingsBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // ACCOUNT
    // ====================
    GetPage(
      name: AppRoutes.account,
      page: () => const AccountView(),
      binding: AccountBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // SUBSCRIPTION
    // ====================
    GetPage(
      name: AppRoutes.subscription,
      page: () => const SubscriptionView(),
      binding: SubscriptionBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // PREMIUM UPGRADE
    // ====================
    GetPage(
      name: AppRoutes.premiumUpgrade,
      page: () => const PremiumUpgradeView(),
      binding: PremiumUpgradeBindings(),
      transition: Transition.downToUp,
      transitionDuration: _modalDuration,
    ),

    // ====================
    // NOTIFICATIONS
    // ====================
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsView(),
      binding: NotificationsBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // DOWNLOADS SETTINGS
    // ====================
    GetPage(
      name: AppRoutes.downloadsSettings,
      page: () => const DownloadsSettingsView(),
      binding: DownloadsSettingsBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // APPEARANCE
    // ====================
    GetPage(
      name: AppRoutes.appearance,
      page: () => const AppearanceView(),
      binding: AppearanceBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // CHATBOT
    // ====================
    GetPage(
      name: AppRoutes.chatbot,
      page: () => const ChatbotView(),
      binding: ChatbotBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // SEARCH ✅ ADDED
    // ====================
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchView(),
      binding: SearchBindings(),
      transition: Transition.fadeIn,
      transitionDuration: _fastDuration,
    ),

    // ====================
    // TEACHER PROFILE ✅ ADDED
    // ====================
    GetPage(
      name: AppRoutes.teacherProfile,
      page: () => const TeacherProfileView(),
      binding: TeacherProfileBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // RECOMMENDED COURSES ✅ ADDED
    // ====================
    GetPage(
      name: AppRoutes.recommendedCourses,
      page: () => const RecommendedCoursesView(),
      binding: RecommendedCoursesBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: _defaultDuration,
    ),

    // ====================
    // VIDEO PLAYER (Keep as backup)
    // ====================
    GetPage(
      name: AppRoutes.videoPlayer,
      page: () => const VideoPlayerView(),
      binding: VideoPlayerBindings(),
      transition: Transition.downToUp,
      transitionDuration: _modalDuration,
    ),

    // ====================
    // AUDIO PLAYER (Keep as backup)
    // ====================
    GetPage(
      name: AppRoutes.audioPlayer,
      page: () => const AudioPlayerView(),
      binding: AudioPlayerBindings(),
      transition: Transition.downToUp,
      transitionDuration: _modalDuration,
    ),
  ];
}
