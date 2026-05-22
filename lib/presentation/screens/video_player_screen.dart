import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../stores/player_store.dart';
import '../widgets/glassmorphic_control.dart';

class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  String _formatDuration(double seconds) {
    final int minutes = (seconds / 60).floor();
    final int remainingSeconds = (seconds % 60).floor();
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showPlayerOptions(BuildContext context, PlayerStore store) {
    if (store.currentTrack == null) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(store.currentTrack!.imageUrl, width: 100, height: 100, fit: BoxFit.cover),
              ),
              const SizedBox(height: 12),
              Text(
                store.currentTrack!.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
              ),
              Text(
                store.currentTrack!.artist,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const Divider(color: Colors.white10, height: 24),
              ListTile(
                leading: const Icon(Icons.queue_music, color: Colors.white),
                title: const Text('Adicionar à fila', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.favorite_border, color: Colors.white),
                title: const Text('Curtir música', style: TextStyle(color: Colors.white)),
                onTap: () {
                  store.toggleLikeTrack(store.currentTrack!.id);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
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
      body: Stack(
        children: [
          // Background - Canvas Animado Simulado de alta fidelidade
          Observer(
            builder: (_) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: AnimatedScale(
                    scale: playerStore.isPlaying ? 1.05 : 1.0,
                    duration: const Duration(seconds: 2),
                    child: Opacity(
                      opacity: 0.15,
                      child: Image.network(
                        playerStore.currentTrack?.imageUrl ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Header do Player
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down, size: 30, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Column(
                        children: [
                          const Text(
                            'TOCANDO DA PLAYLIST',
                            style: TextStyle(fontSize: 10, letterSpacing: 1.5, color: Colors.grey),
                          ),
                          Observer(
                            builder: (_) {
                              return Text(
                                playerStore.currentPlaylist?.name ?? 'Today\'s Top Hits',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                              );
                            },
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onPressed: () => _showPlayerOptions(context, playerStore),
                      ),
                    ],
                  ),
                ),
                
                // Área Central - Visualizador de Capa com Glassmorphism
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 9 / 13,
                        child: GlassmorphicControl(
                          borderRadius: 24,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Observer(
                                builder: (_) {
                                  return Image.network(
                                    playerStore.currentTrack?.imageUrl ?? '',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: Colors.grey.shade900,
                                      child: const Icon(Icons.music_note, size: 64, color: Colors.white24),
                                    ),
                                  );
                                },
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.transparent, Colors.black87],
                                    begin: Alignment.center,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Informações da Música, Seekbar e Controles
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Metadados da Música
                      Observer(
                        builder: (_) {
                          final track = playerStore.currentTrack;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      track?.title ?? 'Nenhuma música selecionada',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    Text(
                                      track?.artist ?? 'Artista desconhecido',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  playerStore.isCurrentTrackLiked ? Icons.favorite : Icons.favorite_border,
                                  color: playerStore.isCurrentTrackLiked ? const Color(0xFF1DB954) : Colors.white,
                                  size: 28,
                                ),
                                onPressed: () {
                                  if (playerStore.currentTrack != null) {
                                    playerStore.toggleLikeTrack(playerStore.currentTrack!.id);
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Slider/Seekbar de Progresso
                      Observer(
                        builder: (_) {
                          final duration = playerStore.currentTrack?.duration.toDouble() ?? 1.0;
                          return Column(
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Theme.of(context).primaryColor,
                                  inactiveTrackColor: Colors.white24,
                                  thumbColor: Colors.white,
                                  trackHeight: 4,
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                ),
                                child: Slider(
                                  value: playerStore.playbackPosition.clamp(0.0, duration),
                                  max: duration,
                                  onChanged: (val) {
                                    playerStore.updatePosition(val);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDuration(playerStore.playbackPosition),
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                    Text(
                                      _formatDuration(playerStore.currentTrack?.duration.toDouble() ?? 0.0),
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Painel de Controles com Avanço/Retrocesso de 10s Ativos e Funcionais
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Observer(
                            builder: (_) {
                              return IconButton(
                                icon: Icon(
                                  Icons.shuffle,
                                  size: 28,
                                  color: playerStore.isShuffleEnabled ? const Color(0xFF1DB954) : Colors.grey,
                                ),
                                onPressed: () {
                                  playerStore.toggleShuffle();
                                },
                              );
                            },
                          ),
                          // Botão Anterior: Agora recua exatamente 10 segundos da faixa atual
                          IconButton(
                            icon: const Icon(Icons.skip_previous, size: 40, color: Colors.white),
                            onPressed: () {
                              playerStore.seekBackward(); // Ação alterada para retrocesso
                            },
                          ),
                          // Play/Pause
                          Observer(
                            builder: (_) {
                              return CircleAvatar(
                                radius: 36,
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: Icon(
                                    playerStore.isPlaying ? Icons.pause : Icons.play_arrow,
                                    size: 36,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    playerStore.togglePlay();
                                  },
                                ),
                              );
                            },
                          ),
                          // Botão Próximo: Agora avança exatamente 10 segundos sem mudar de música
                          IconButton(
                            icon: const Icon(Icons.skip_next, size: 40, color: Colors.white),
                            onPressed: () {
                              playerStore.seekForward(); // Ação alterada para avanço rápido
                            },
                          ),
                          Observer(
                            builder: (_) {
                              return IconButton(
                                icon: Icon(
                                  Icons.repeat,
                                  size: 28,
                                  color: playerStore.isRepeatEnabled ? const Color(0xFF1DB954) : Colors.grey,
                                ),
                                onPressed: () {
                                  playerStore.toggleRepeat();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}