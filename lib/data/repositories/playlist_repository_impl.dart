import 'package:dio/dio.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/repositories/playlist_repository.dart';
import '../models/playlist_model.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final Dio _dio;

  PlaylistRepositoryImpl(this._dio);

  @override
  Future<List<Playlist>> getPlaylists() async {
    try {
      final response = await _dio.get('/playlists');
      final data = response.data['playlists'] as List;
      return data.map((json) => PlaylistModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao carregar as playlists do servidor.');
    }
  }
}