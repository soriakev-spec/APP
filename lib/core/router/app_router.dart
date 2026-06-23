// GoRouter configuration for Habla AAC.
// All routes are declared here; the AppShell wraps every route with persistent
// navigation (sidebar on tablet, bottom bar on phone).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:habla/core/router/app_shell.dart';
import 'package:habla/features/activities/activities_screen.dart';
import 'package:habla/features/activities/activity_detail_screen.dart';
import 'package:habla/features/ai_panel/ai_panel_screen.dart';
import 'package:habla/features/boards/boards_screen.dart';
import 'package:habla/features/boards/create_board_screen.dart';
import 'package:habla/features/boards/edit_board_screen.dart';
import 'package:habla/features/communicate/communicate_screen.dart';
import 'package:habla/features/communicate/vocabulary_search_screen.dart';
import 'package:habla/features/ecosystem/ecosystem_screen.dart';
import 'package:habla/features/editor/editor_screen.dart';
import 'package:habla/features/family/family_screen.dart';
import 'package:habla/features/home/home_screen.dart';
import 'package:habla/features/library/library_screen.dart';
import 'package:habla/features/phrases/phrases_screen.dart';
import 'package:habla/features/reports/reports_screen.dart';
import 'package:habla/features/scenarios/scenario_detail_screen.dart';
import 'package:habla/features/scenarios/scenarios_screen.dart';
import 'package:habla/features/settings/accessibility_settings_screen.dart';
import 'package:habla/features/settings/backup_settings_screen.dart';
import 'package:habla/features/settings/profiles_screen.dart';
import 'package:habla/features/settings/settings_screen.dart';
import 'package:habla/features/settings/voice_settings_screen.dart';
import 'package:habla/features/supports/routines_screen.dart';
import 'package:habla/features/supports/social_stories_screen.dart';
import 'package:habla/features/supports/supports_screen.dart';
import 'package:habla/features/supports/timers_screen.dart';
import 'package:habla/features/therapist/therapist_screen.dart';

// ---------------------------------------------------------------------------
// Route path constants
// ---------------------------------------------------------------------------

abstract final class AppRoutes {
  static const home = '/home';
  static const communicate = '/communicate';
  static const communicateSearch = '/communicate/search';
  static const boards = '/boards';
  static const boardsCreate = '/boards/create';
  static const boardEdit = '/boards/:id/edit';
  static const editor = '/editor/:boardId';
  static const ai = '/ai';
  static const phrases = '/phrases';
  static const scenarios = '/scenarios';
  static const scenarioDetail = '/scenarios/:id';
  static const activities = '/activities';
  static const activityDetail = '/activities/:id';
  static const supports = '/supports';
  static const supportsStories = '/supports/stories';
  static const supportsRoutines = '/supports/routines';
  static const supportsTimers = '/supports/timers';
  static const therapist = '/therapist';
  static const family = '/family';
  static const reports = '/reports';
  static const library = '/library';
  static const ecosystem = '/ecosystem';
  static const settings = '/settings';
  static const settingsProfiles = '/settings/profiles';
  static const settingsVoice = '/settings/voice';
  static const settingsAccessibility = '/settings/accessibility';
  static const settingsBackup = '/settings/backup';

  // ---------------------------------------------------------------------------
  // Helpers to build parameterised paths at runtime.
  // ---------------------------------------------------------------------------

  static String boardEditPath(String id) => '/boards/$id/edit';
  static String editorPath(String boardId) => '/editor/$boardId';
  static String scenarioDetailPath(String id) => '/scenarios/$id';
  static String activityDetailPath(String id) => '/activities/$id';
}

// ---------------------------------------------------------------------------
// GoRouter provider
// ---------------------------------------------------------------------------

/// The singleton GoRouter instance consumed by [MaterialApp.router].
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: false,
    routes: [
      // Root redirect → home.
      GoRoute(
        path: '/',
        redirect: (_, __) => AppRoutes.home,
      ),

      // ShellRoute — provides persistent AppShell around all main routes.
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return AppShell(child: child);
        },
        routes: [
          // ----------------------------------------------------------------
          // Home
          // ----------------------------------------------------------------
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),

          // ----------------------------------------------------------------
          // Communicate
          // ----------------------------------------------------------------
          GoRoute(
            path: AppRoutes.communicate,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const CommunicateScreen(),
            ),
            routes: [
              GoRoute(
                path: 'search',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const VocabularySearchScreen(),
                ),
              ),
            ],
          ),

          // ----------------------------------------------------------------
          // Boards
          // ----------------------------------------------------------------
          GoRoute(
            path: AppRoutes.boards,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const BoardsScreen(),
            ),
            routes: [
              GoRoute(
                path: 'create',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const CreateBoardScreen(),
                ),
              ),
              GoRoute(
                path: ':id/edit',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: EditBoardScreen(
                    boardId: state.pathParameters['id']!,
                  ),
                ),
              ),
            ],
          ),

          // ----------------------------------------------------------------
          // Board editor
          // ----------------------------------------------------------------
          GoRoute(
            path: '/editor/:boardId',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: EditorScreen(
                boardId: state.pathParameters['boardId']!,
              ),
            ),
          ),

          // ----------------------------------------------------------------
          // AI panel
          // ----------------------------------------------------------------
          GoRoute(
            path: AppRoutes.ai,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const AiPanelScreen(),
            ),
          ),

          // ----------------------------------------------------------------
          // Phrases
          // ----------------------------------------------------------------
          GoRoute(
            path: AppRoutes.phrases,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const PhrasesScreen(),
            ),
          ),

          // ----------------------------------------------------------------
          // Scenarios
          // ----------------------------------------------------------------
          GoRoute(
            path: AppRoutes.scenarios,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ScenariosScreen(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: ScenarioDetailScreen(
                    scenarioId: state.pathParameters['id']!,
                  ),
                ),
              ),
            ],
          ),

          // ----------------------------------------------------------------
          // Activities
          // ----------------------------------------------------------------
          GoRoute(
            path: AppRoutes.activities,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ActivitiesScreen(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: ActivityDetailScreen(
                    activityId: state.pathParameters['id']!,
                  ),
                ),
              ),
            ],
          ),

          // ----------------------------------------------------------------
          // Supports
          // ----------------------------------------------------------------
          GoRoute(
            path: AppRoutes.supports,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SupportsScreen(),
            ),
            routes: [
              GoRoute(
                path: 'stories',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const SocialStoriesScreen(),
                ),
              ),
              GoRoute(
                path: 'routines',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const RoutinesScreen(),
                ),
              ),
              GoRoute(
                path: 'timers',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const TimersScreen(),
                ),
              ),
            ],
          ),

          // ----------------------------------------------------------------
          // Therapist
          // ----------------------------------------------------------------
          GoRoute(
            path: AppRoutes.therapist,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const TherapistScreen(),
            ),
          ),

          // ----------------------------------------------------------------
          // Family
          // ----------------------------------------------------------------
          GoRoute(
            path: AppRoutes.family,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const FamilyScreen(),
            ),
          ),

          // ----------------------------------------------------------------
          // Reports
          // ----------------------------------------------------------------
          GoRoute(
            path: AppRoutes.reports,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ReportsScreen(),
            ),
          ),

          // ----------------------------------------------------------------
          // Library
          // ----------------------------------------------------------------
          GoRoute(
            path: AppRoutes.library,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const LibraryScreen(),
            ),
          ),

          // ----------------------------------------------------------------
          // Ecosystem
          // ----------------------------------------------------------------
          GoRoute(
            path: AppRoutes.ecosystem,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const EcosystemScreen(),
            ),
          ),

          // ----------------------------------------------------------------
          // Settings
          // ----------------------------------------------------------------
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SettingsScreen(),
            ),
            routes: [
              GoRoute(
                path: 'profiles',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const ProfilesScreen(),
                ),
              ),
              GoRoute(
                path: 'voice',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const VoiceSettingsScreen(),
                ),
              ),
              GoRoute(
                path: 'accessibility',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const AccessibilitySettingsScreen(),
                ),
              ),
              GoRoute(
                path: 'backup',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const BackupSettingsScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],

    // Global error page shown when navigation fails.
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Ruta no encontrada',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(state.error?.message ?? state.uri.toString()),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Ir al inicio'),
            ),
          ],
        ),
      ),
    ),
  );
});
