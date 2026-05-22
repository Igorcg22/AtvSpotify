import 'dart:async';
import 'package:mobx/mobx.dart';
import '../../domain/entities/track.dart';
import '../../domain/entities/playlist.dart';
import '../../core/storage/preferences_service.dart';

part 'player_store.g.dart';

class PlayerStore = _PlayerStoreBase with _$PlayerStore;

abstract class _PlayerStoreBase with Store {
  final PreferencesService _preferencesService;
  Timer? _playbackTimer;

  _PlayerStoreBase(this._preferencesService) {
    _loadLastPlayedTrack();
    _loadLikedTracks();
  }

  @observable
  Track? currentTrack;

  @observable
  Playlist? currentPlaylist;

  @observable
  bool isPlaying = false;

  @observable
  double playbackPosition = 0.0;

  @observable
  bool isShuffleEnabled = false;

  @observable
  bool isRepeatEnabled = false;

  @observable
  ObservableList<String> likedTrackIds = ObservableList<String>();

  @computed
  bool get hasActiveTrack => currentTrack != null;

  @computed
  bool get isCurrentTrackLiked {
    if (currentTrack == null) return false;
    return likedTrackIds.contains(currentTrack!.id);
  }

  @action
  void selectTrack(Track track, {Playlist? playlist}) {
    currentTrack = track;
    if (playlist != null) {
      currentPlaylist = playlist;
    }
    isPlaying = true;
    playbackPosition = 0.0;
    _preferencesService.saveLastPlayedTrack(track.id);
    _startTimer();
  }

  @action
  void togglePlay() {
    isPlaying = !isPlaying;
    if (isPlaying) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  @action
  void toggleShuffle() {
    isShuffleEnabled = !isShuffleEnabled;
  }

  @action
  void toggleRepeat() {
    isRepeatEnabled = !isRepeatEnabled;
  }

  @action
  void playNextTrack() {
    if (currentPlaylist == null || currentTrack == null) return;
    final tracks = currentPlaylist!.tracks;
    final currentIndex = tracks.indexWhere((t) => t.id == currentTrack!.id);

    if (isShuffleEnabled) {
      final random = DateTime.now().millisecond % tracks.length;
      selectTrack(tracks[random]);
      return;
    }

    if (currentIndex != -1 && currentIndex < tracks.length - 1) {
      selectTrack(tracks[currentIndex + 1]);
    } else if (isRepeatEnabled) {
      selectTrack(tracks.first);
    } else {
      _handleSongFinished();
    }
  }

  @action
  void playPreviousTrack() {
    if (currentPlaylist == null || currentTrack == null) return;
    final tracks = currentPlaylist!.tracks;
    final currentIndex = tracks.indexWhere((t) => t.id == currentTrack!.id);

    if (playbackPosition < 5.0 && currentIndex > 0) {
      selectTrack(tracks[currentIndex - 1]);
    } else {
      playbackPosition = 0.0;
    }
  }

  @action
  void toggleLikeTrack(String trackId) {
    if (likedTrackIds.contains(trackId)) {
      likedTrackIds.remove(trackId);
    } else {
      likedTrackIds.add(trackId);
    }
    _preferencesService.saveLikedTracks(likedTrackIds.toList());
  }

  @action
  void updatePosition(double value) {
    playbackPosition = value;
  }

  // Avança exatamente 10 segundos sem mudar de faixa
  @action
  void seekForward() {
    if (currentTrack == null) return;
    if (playbackPosition + 10 < currentTrack!.duration) {
      playbackPosition += 10;
    } else {
      playbackPosition = currentTrack!.duration.toDouble();
      _handleSongFinished(); // Apenas encerra o progresso
    }
  }

  // Retrocede exatamente 10 segundos
  @action
  void seekBackward() {
    if (playbackPosition - 10 > 0) {
      playbackPosition -= 10;
    } else {
      playbackPosition = 0.0;
    }
  }

  @action
  void _incrementProgress() {
    if (currentTrack == null) return;
    if (playbackPosition < currentTrack!.duration) {
      playbackPosition += 1.0;
    } else {
      playNextTrack();
    }
  }

  @action
  void _handleSongFinished() {
    isPlaying = false;
    playbackPosition = 0.0;
    _stopTimer();
  }

  void _startTimer() {
    _stopTimer();
    _playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _incrementProgress();
    });
  }

  void _stopTimer() {
    _playbackTimer?.cancel();
    _playbackTimer = null;
  }

  void _loadLastPlayedTrack() {
    final lastId = _preferencesService.getLastPlayedTrack();
  }

  void _loadLikedTracks() {
    final list = _preferencesService.getLikedTracks();
    likedTrackIds.clear();
    likedTrackIds.addAll(list);
  }
}