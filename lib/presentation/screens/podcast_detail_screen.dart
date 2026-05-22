import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/track.dart';
import '../stores/player_store.dart';
import 'video_player_screen.dart';

class PodcastDetailScreen extends StatefulWidget {
  final Map<String, dynamic> podcast;

  const PodcastDetailScreen({Key? key, required this.podcast}) : super(key: key);

  @override
  State<PodcastDetailScreen> createState() => _PodcastDetailScreenState();
}

class _PodcastDetailScreenState extends State<PodcastDetailScreen> {
  bool isFollowing = false;
  bool isNotificationActive = false;

  bool autoDownload = false;
  bool autoRemove = true;

  String _formatDuration(int seconds) {
    final int hours = (seconds / 3600).floor();
    final int minutes = ((seconds % 3600) / 60).floor();
    if (hours > 0) {
      return '$hours h $minutes min';
    }
    return '$minutes min';
  }

  void _showPodcastSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF282828),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
                    child: Text(
                      'Configurações do Programa',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const Divider(color: Colors.white10),
                  SwitchListTile(
                    activeColor: const Color(0xFF1DB954),
                    title: const Text('Baixar novos episódios', style: TextStyle(color: Colors.white, fontSize: 14)),
                    subtitle: const Text('Salva automaticamente no dispositivo', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    value: autoDownload,
                    onChanged: (val) {
                      setModalState(() {
                        autoDownload = val;
                      });
                      setState(() {
                        autoDownload = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    activeColor: const Color(0xFF1DB954),
                    title: const Text('Remover episódios concluídos', style: TextStyle(color: Colors.white, fontSize: 14)),
                    subtitle: const Text('Apaga do armazenamento após ouvir', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    value: autoRemove,
                    onChanged: (val) {
                      setModalState(() {
                        autoRemove = val;
                      });
                      setState(() {
                        autoRemove = val;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerStore = context.read<PlayerStore>();
    final episodes = widget.podcast['episodes'] as List<Map<String, dynamic>>;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: const Color(0xFF121212),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF383838), Color(0xFF121212)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.podcast['imageUrl'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PODCAST',
                              style: TextStyle(fontSize: 10, letterSpacing: 1.5, color: Colors.grey, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.podcast['name'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            Text(
                              'Show por ${widget.podcast['host']}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.podcast['description'],
                    style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isFollowing = !isFollowing;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: isFollowing ? const Color(0xFF1DB954) : Colors.white24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: Text(
                          isFollowing ? 'SEGUINDO' : 'SEGUIR',
                          style: TextStyle(
                            color: isFollowing ? const Color(0xFF1DB954) : Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: Icon(
                          isNotificationActive ? Icons.notifications_active : Icons.notifications_none,
                          color: isNotificationActive ? const Color(0xFF1DB954) : Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isNotificationActive = !isNotificationActive;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isNotificationActive
                                    ? 'Notificações ativadas para novos episódios de ${widget.podcast['name']}.'
                                    : 'Notificações desativadas para ${widget.podcast['name']}.',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined, color: Colors.white),
                        onPressed: () => _showPodcastSettings(context),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white10, height: 32),
                  const Text(
                    'Todos os episódios',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          Observer(
            builder: (_) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final ep = episodes[index];
                    final isCurrentPlaying = playerStore.currentTrack?.id == ep['id'];
                    final currentPosition = isCurrentPlaying ? playerStore.playbackPosition : 0.0;
                    final totalDuration = ep['duration'].toDouble();
                    final progress = currentPosition / totalDuration;

                    return GestureDetector(
                      onTap: () {
                        final track = Track(
                          id: ep['id'],
                          title: ep['title'],
                          artist: ep['artist'],
                          duration: ep['duration'],
                          imageUrl: ep['imageUrl'],
                          videoUrl: '',
                        );
                        playerStore.selectTrack(track);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const VideoPlayerScreen()),
                        );
                      },
                      child: Card(
                        color: const Color(0xFF1E1E1E),
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network(ep['imageUrl'], width: 40, height: 40, fit: BoxFit.cover),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ep['title'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                                        ),
                                        Text(
                                          'Episódio • ${_formatDuration(ep['duration'])}',
                                          style: const TextStyle(color: Colors.grey, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    isCurrentPlaying && playerStore.isPlaying
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_fill,
                                    color: const Color(0xFF1DB954),
                                    size: 30,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ep['description'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.3),
                              ),
                              if (isCurrentPlaying && currentPosition > 0) ...[
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(2),
                                        child: LinearProgressIndicator(
                                          value: progress.clamp(0.0, 1.0),
                                          backgroundColor: Colors.white10,
                                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1DB954)),
                                          minHeight: 4,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Restam ${((totalDuration - currentPosition) / 60).round()} min',
                                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: episodes.length,
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}