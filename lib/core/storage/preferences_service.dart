import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _lastTrackKey = 'last_played_track_id';
  static const String _likedTracksKey = 'liked_tracks_ids';
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  Future<void> saveLastPlayedTrack(String trackId) async {
    await _prefs.setString(_lastTrackKey, trackId);
  }

  String? getLastPlayedTrack() {
    return _prefs.getString(_lastTrackKey);
  }

  Future<void> saveLikedTracks(List<String> trackIds) async {
    await _prefs.setStringList(_likedTracksKey, trackIds);
  }

  List<String> getLikedTracks() {
    return _prefs.getStringList(_likedTracksKey) ?? [];
  }
}