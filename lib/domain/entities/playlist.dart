import 'track.dart';

class Playlist {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final List<Track> tracks;

  Playlist({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.tracks,
  });
}