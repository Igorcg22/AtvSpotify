import '../../domain/entities/track.dart';

class TrackModel extends Track {
  TrackModel({
    required String id,
    required String title,
    required String artist,
    required int duration,
    required String imageUrl,
    required String videoUrl,
  }) : super(
          id: id,
          title: title,
          artist: artist,
          duration: duration,
          imageUrl: imageUrl,
          videoUrl: videoUrl,
        );

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    return TrackModel(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      duration: json['duration'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'] ?? '',
    );
  }
}