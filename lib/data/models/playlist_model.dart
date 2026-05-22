import '../../domain/entities/playlist.dart';
import 'track_model.dart';

class PlaylistModel extends Playlist {
  PlaylistModel({
    required String id,
    required String name,
    required String imageUrl,
    required String description,
    required List<TrackModel> tracks,
  }) : super(
          id: id,
          name: name,
          imageUrl: imageUrl,
          description: description,
          tracks: tracks,
        );

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      tracks: (json['tracks'] as List)
          .map((track) => TrackModel.fromJson(track))
          .toList(),
    );
  }
}