import 'package:mobx/mobx.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/repositories/playlist_repository.dart';

part 'playlist_store.g.dart';

class PlaylistStore = _PlaylistStoreBase with _$PlaylistStore;

abstract class _PlaylistStoreBase with Store {
  final PlaylistRepository _playlistRepository;

  _PlaylistStoreBase(this._playlistRepository);

  @observable
  ObservableList<Playlist> playlists = ObservableList<Playlist>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> fetchPlaylists() async {
    isLoading = true;
    errorMessage = null;
    try {
      final result = await _playlistRepository.getPlaylists();
      playlists.clear();
      playlists.addAll(result);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }
}