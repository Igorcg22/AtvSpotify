import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../stores/playlist_store.dart';
import '../stores/player_store.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/entities/track.dart';
import 'playlist_detail_screen.dart';
import 'podcast_detail_screen.dart';
import 'video_player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = 'Tudo';

  final List<Map<String, dynamic>> mockPodcasts = [
    {
      'id': 'pod1',
      'name': 'Podpah',
      'host': 'Igão e Mítico',
      'imageUrl': 'https://picsum.photos/seed/podpah/300',
      'description': 'O maior e mais carismático podcast de conversas do Brasil, com entrevistas divertidas e descontraídas.',
      'episodes': [
        {
          'id': 'ep_pod1_1',
          'title': 'Ep. #24 - Papo sobre Tecnologia',
          'artist': 'Podpah',
          'duration': 5400,
          'imageUrl': 'https://picsum.photos/seed/podpah/300',
          'description': 'Nesse episódio, recebemos especialistas para discutir as grandes tendências de tecnologia e IA do momento.'
        },
        {
          'id': 'ep_pod1_2',
          'title': 'Ep. #23 - Empreendedorismo Digital',
          'artist': 'Podpah',
          'duration': 4800,
          'imageUrl': 'https://picsum.photos/seed/podpah/300',
          'description': 'Conversamos sobre como iniciar uma startup no mercado brasileiro de inovação hoje.'
        }
      ]
    },
    {
      'id': 'pod2',
      'name': 'NerdCast',
      'host': 'Jovem Nerd',
      'imageUrl': 'https://picsum.photos/seed/nerdcast/300',
      'description': 'História, ciência, cinema e muita conversa de nerd. O podcast pioneiro do Brasil.',
      'episodes': [
        {
          'id': 'ep_pod2_1',
          'title': 'Ep. #25 - O Futuro da Inteligência Artificial',
          'artist': 'NerdCast',
          'duration': 7200,
          'imageUrl': 'https://picsum.photos/seed/nerdcast/300',
          'description': 'Discutimos as transformações profundas que a tecnologia de inteligência artificial generativa trará.'
        },
        {
          'id': 'ep_pod2_2',
          'title': 'Ep. #24 - História das Revoluções Científicas',
          'artist': 'NerdCast',
          'duration': 6800,
          'imageUrl': 'https://picsum.photos/seed/nerdcast/300',
          'description': 'Uma viagem fantástica pelo conhecimento humano e as mentes brilhantes que mudaram nossa realidade.'
        }
      ]
    },
    {
      'id': 'pod3',
      'name': 'Mano a Mano',
      'host': 'Mano Brown',
      'imageUrl': 'https://picsum.photos/seed/mano/300',
      'description': 'Entrevistas profundas com personalidades da cultura, história, esporte e política lideradas por Mano Brown.',
      'episodes': [
        {
          'id': 'ep_pod3_1',
          'title': 'Ep. #26 - Racionais e a Cultura Periférica',
          'artist': 'Mano a Mano',
          'duration': 8100,
          'imageUrl': 'https://picsum.photos/seed/mano/300',
          'description': 'Uma conversa reflexiva sobre a evolução do rap nacional e seu impacto social nas periferias.'
        },
        {
          'id': 'ep_pod3_2',
          'title': 'Ep. #25 - Entrevista com Pensadores Negros',
          'artist': 'Mano a Mano',
          'duration': 5400,
          'imageUrl': 'https://picsum.photos/seed/mano/300',
          'description': 'Brown debate racismo estrutural, educação e caminhos para a igualdade social com ativistas históricos.'
        }
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlaylistStore>().fetchPlaylists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final playlistStore = context.watch<PlaylistStore>();
    final playerStore = context.read<PlayerStore>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage('https://picsum.photos/seed/user/100'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip('Tudo'),
                            _buildFilterChip('Retrospectiva'),
                            _buildFilterChip('Música'),
                            _buildFilterChip('Podcasts'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Observer(
                  builder: (_) {
                    if (playlistStore.isLoading) {
                      return const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator(color: Color(0xFF1DB954))),
                      );
                    }

                    if (selectedFilter == 'Podcasts') {
                      return _buildPodcastsContent(playerStore);
                    }

                    List<Playlist> filteredPlaylists = playlistStore.playlists;
                    if (selectedFilter == 'Retrospectiva') {
                      filteredPlaylists = playlistStore.playlists.where((p) => p.id == 'p3').toList();
                    } else if (selectedFilter == 'Música') {
                      filteredPlaylists = playlistStore.playlists.where((p) => p.id == 'p1' || p.id == 'p2').toList();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 3.1,
                          ),
                          itemCount: filteredPlaylists.length,
                          itemBuilder: (context, index) {
                            final playlist = filteredPlaylists[index];
                            final isArtist = playlist.id == 'p3';

                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PlaylistDetailScreen(playlist: playlist),
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF282828),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: isArtist 
                                          ? BorderRadius.circular(28) 
                                          : const BorderRadius.horizontal(left: Radius.circular(4)),
                                      child: Padding(
                                        padding: EdgeInsets.all(isArtist ? 4.0 : 0.0),
                                        child: Image.network(
                                          playlist.imageUrl,
                                          width: 56,
                                          height: 56,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        playlist.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        _buildSectionHeader('Seus mixes mais ouvidos'),
                        const SizedBox(height: 12),
                        _buildHorizontalList(filteredPlaylists, isMix: true),
                        const SizedBox(height: 24),
                        _buildSectionHeader('Álbuns com as músicas que você adora'),
                        const SizedBox(height: 12),
                        _buildHorizontalList(filteredPlaylists, isMix: false),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1DB954) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildHorizontalList(List<Playlist> list, {required bool isMix}) {
    if (list.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(child: Text('Nenhum item disponível', style: TextStyle(color: Colors.grey))),
      );
    }

    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final playlist = list[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaylistDetailScreen(playlist: playlist),
                ),
              );
            },
            child: Container(
              width: 135,
              margin: const EdgeInsets.only(right: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          playlist.imageUrl,
                          height: 135,
                          width: 135,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (isMix)
                        Positioned(
                          top: 6,
                          left: 6,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.music_note, color: Color(0xFF1DB954), size: 12),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isMix ? 'Mix de ${playlist.name}' : playlist.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    playlist.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.2),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPodcastsContent(PlayerStore playerStore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        _buildSectionHeader('Seus programas favoritos'),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: mockPodcasts.length,
            itemBuilder: (context, index) {
              final pod = mockPodcasts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PodcastDetailScreen(podcast: pod),
                    ),
                  );
                },
                child: Container(
                  width: 135,
                  margin: const EdgeInsets.only(right: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          pod['imageUrl']!,
                          height: 135,
                          width: 135,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pod['name']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                      ),
                      Text(
                        'Show • ${pod['host']}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader('Episódios recomendados'),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mockPodcasts.length,
          itemBuilder: (context, index) {
            final pod = mockPodcasts[index];
            final latestEpisode = pod['episodes'][0] as Map<String, dynamic>;

            return GestureDetector(
              onTap: () {
                final track = Track(
                  id: latestEpisode['id'],
                  title: latestEpisode['title'],
                  artist: latestEpisode['artist'],
                  duration: latestEpisode['duration'],
                  imageUrl: latestEpisode['imageUrl'],
                  videoUrl: '',
                );
                playerStore.selectTrack(track);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VideoPlayerScreen(),
                  ),
                );
              },
              child: Card(
                color: const Color(0xFF1E1E1E),
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(latestEpisode['imageUrl']!, width: 50, height: 50, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              latestEpisode['title']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              latestEpisode['description']!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.play_circle_fill, color: Color(0xFF1DB954), size: 32),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}