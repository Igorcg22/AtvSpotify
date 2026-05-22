import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/spotify_theme.dart';
import 'core/network/dio_client.dart';
import 'core/storage/preferences_service.dart';
import 'data/repositories/playlist_repository_impl.dart';
import 'presentation/stores/player_store.dart';
import 'presentation/stores/playlist_store.dart';
import 'presentation/screens/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPrefs = await SharedPreferences.getInstance();
  final preferencesService = PreferencesService(sharedPrefs);

  final dioClient = DioClient();
  final playlistRepository = PlaylistRepositoryImpl(dioClient.dio);

  final playerStore = PlayerStore(preferencesService);
  final playlistStore = PlaylistStore(playlistRepository);

  runApp(
    MultiProvider(
      providers: [
        Provider<PlayerStore>.value(value: playerStore),
        Provider<PlaylistStore>.value(value: playlistStore),
      ],
      child: const SpotifyCloneApp(),
    ),
  );
}

class SpotifyCloneApp extends StatelessWidget {
  const SpotifyCloneApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Clone',
      theme: SpotifyTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const MainNavigationScreen(),
    );
  }
}