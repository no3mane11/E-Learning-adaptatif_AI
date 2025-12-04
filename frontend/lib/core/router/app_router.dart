import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/courses/courses_list_screen.dart';
import '../../features/courses/course_details_screen.dart';
import '../../features/lesson/lesson_player_screen.dart';
import '../../features/history/history_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/professor/presentation/home_professor_screen.dart';
import '../../features/professor/presentation/manage_courses_screen.dart';
import '../../features/professor/presentation/dashboard_screen.dart';

/// Configuration du router avec go_router
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/courses',
        name: 'courses',
        builder: (context, state) => const CoursesListScreen(),
      ),
      GoRoute(
        path: '/course/:id',
        name: 'course-details',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CourseDetailsScreen(courseId: id);
        },
      ),
      GoRoute(
        path: '/lesson/:id',
        name: 'lesson-player',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final courseId = state.uri.queryParameters['courseId'] ?? 'default-course';
          return LessonPlayerScreen(
            courseId: courseId,
            lessonId: id,
          );
        },
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      // Routes Professeur
      GoRoute(
        path: '/professor',
        name: 'professor-home',
        builder: (context, state) => const HomeProfessorScreen(),
      ),
      GoRoute(
        path: '/professor/dashboard',
        name: 'professor-dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/professor/courses',
        name: 'professor-courses',
        builder: (context, state) => const ManageCoursesScreen(),
      ),
      GoRoute(
        path: '/professor/analytics',
        name: 'professor-analytics',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page non trouvée: ${state.uri}'),
      ),
    ),
  );
}

