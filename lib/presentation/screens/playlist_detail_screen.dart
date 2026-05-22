import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/entities/track.dart';
import '../stores/player_store.dart';
import 'video_player_screen.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final Playlist playlist;

  const PlaylistDetailScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  bool isPlaylistLiked = false;
  bool isDownloading = false;
  bool isDownloaded = false;

  void _simulateDownload() async {
    if (isDownloaded) {
      setState(() {
        isDownloaded = false;
      });
      return;
    }

    setState(() {
      isDownloading = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        isDownloading = false;
        isDownloaded = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Playlist "${widget.playlist.name}" baixada para ouvir offline.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showTrackOptions(BuildContext context, Track track) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF282828),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(track.imageUrl, width: 40, height: 40, fit: BoxFit.cover),
                ),
                title: Text(track.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                subtitle: Text(track.artist, style: const TextStyle(color: Colors.grey)),
              ),
              const Divider(color: Colors.white10),
              ListTile(
                leading: const Icon(Icons.playlist_add, color: Colors.white),
                title: const Text('Adicionar à fila de reprodução', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.album, color: Colors.white),
                title: const Text('Ver Álbum', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined, color: Colors.white),
                title: const Text('Compartilhar faixa', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerStore = context.read<PlayerStore>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          // AppBar limpa focada apenas na imagem de capa
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: const Color(0xFF121212),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blueGrey.shade800.withOpacity(0.6),
                      const Color(0xFF121212),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          widget.playlist.imageUrl,
                          height: 140,
                          width: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Metadados alinhados e espaçados abaixo da capa
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título grande alinhado à esquerda
                  Text(
                    widget.playlist.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Informações de autoria e likes estilo Spotify
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 10,
                        backgroundColor: Color(0xFF1DB954),
                        child: Icon(Icons.music_note, size: 10, color: Colors.black),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Spotify',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '•  254.120 curtidas  •  ${widget.playlist.tracks.length} músicas',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Descrição da Playlist
                  Text(
                    widget.playlist.description,
                    style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  
                  // Botões de ação (Curtir, Download e Play)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero, // Correção aplicada aqui
                        alignment: Alignment.centerLeft,
                        icon: Icon(
                          isPlaylistLiked ? Icons.favorite : Icons.favorite_border,
                          color: isPlaylistLiked ? const Color(0xFF1DB954) : Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          setState(() {
                            isPlaylistLiked = !isPlaylistLiked;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: _simulateDownload,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: isDownloading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Color(0xFF1DB954),
                                  ),
                                )
                              : Icon(
                                  isDownloaded ? Icons.arrow_circle_down : Icons.arrow_circle_down_outlined,
                                  color: isDownloaded ? const Color(0xFF1DB954) : Colors.white,
                                  size: 28,
                                ),
                        ),
                      ),
                      const Spacer(),
                      FloatingActionButton(
                        onPressed: () {
                          if (widget.playlist.tracks.isNotEmpty) {
                            playerStore.selectTrack(widget.playlist.tracks.first, playlist: widget.playlist);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const VideoPlayerScreen(),
                              ),
                            );
                          }
                        },
                        backgroundColor: const Color(0xFF1DB954),
                        child: const Icon(Icons.play_arrow, color: Colors.black, size: 32),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Lista de músicas da Playlist
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final track = widget.playlist.tracks[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(track.imageUrl, width: 48, height: 48, fit: BoxFit.cover),
                  ),
                  title: Text(
                    track.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(track.artist, style: const TextStyle(color: Colors.grey)),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onPressed: () => _showTrackOptions(context, track),
                  ),
                  onTap: () {
                    playerStore.selectTrack(track, playlist: widget.playlist);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VideoPlayerScreen(),
                      ),
                    );
                  },
                );
              },
              childCount: widget.playlist.tracks.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}