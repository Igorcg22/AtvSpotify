import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../stores/playlist_store.dart';
import '../stores/player_store.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/entities/track.dart';
import 'playlist_detail_screen.dart';
import 'podcast_detail_screen.dart'; // Nova importação para acoplar os Podcasts
import 'video_player_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedSubFilter = 'Melhores resultados';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Lógica de cliques funcionais em cada quadrado de categoria
  void _onCategoryTap(BuildContext context, String categoryName, PlaylistStore playlistStore) {
    final playlists = playlistStore.playlists;

    if (playlists.isEmpty) return;

    if (categoryName == 'Podcasts') {
      // Direciona para a tela do Podcast simulando dados reais do Podpah
      final pod = {
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
      };
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PodcastDetailScreen(podcast: pod),
        ),
      );
      return;
    }

    // Mapeamento dinâmico de categorias para as playlists do banco mockado
    Playlist? targetPlaylist;

    if (categoryName == 'Pop' || categoryName == 'Novos lançamentos') {
      targetPlaylist = playlists.firstWhere((p) => p.id == 'p1', orElse: () => playlists.first);
    } else if (categoryName == 'Rock' || categoryName == 'Latina') {
      targetPlaylist = playlists.firstWhere((p) => p.id == 'p3', orElse: () => playlists.first);
    } else if (categoryName == 'Feito para você' || categoryName == 'Dance/Eletrônica') {
      targetPlaylist = playlists.firstWhere((p) => p.id == 'p2', orElse: () => playlists.first);
    } else {
      targetPlaylist = playlists.first;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaylistDetailScreen(playlist: targetPlaylist!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playlistStore = context.watch<PlaylistStore>();
    final playerStore = context.read<PlayerStore>();

    final List<Map<String, dynamic>> categories = [
      {'title': 'Podcasts', 'color': Colors.deepOrange},
      {'title': 'Feito para você', 'color': Colors.blueAccent},
      {'title': 'Novos lançamentos', 'color': Colors.pinkAccent},
      {'title': 'Pop', 'color': Colors.green},
      {'title': 'Hip-Hop', 'color': Colors.orange},
      {'title': 'Rock', 'color': Colors.redAccent},
      {'title': 'Latina', 'color': Colors.purple},
      {'title': 'Dance/Eletrônica', 'color': Colors.teal},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF242424),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.white70),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'O que você quer ouvir?',
                                hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value.trim();
                                });
                              },
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                              child: const Icon(Icons.close, color: Colors.white70, size: 20),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Observer(
                  builder: (_) {
                    if (_searchQuery.isEmpty) {
                      return _buildCategoriesView(categories, playlistStore);
                    } else {
                      return _buildSearchResults(playlistStore, playerStore);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesView(List<Map<String, dynamic>> categories, PlaylistStore playlistStore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Navegar por todas as seções',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return GestureDetector(
                onTap: () => _onCategoryTap(context, cat['title'], playlistStore),
                child: Container(
                  decoration: BoxDecoration(
                    color: cat['color'],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    cat['title'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(PlaylistStore playlistStore, PlayerStore playerStore) {
    final List<Track> matchedTracks = [];
    final List<Playlist> matchedPlaylists = [];
    final Set<String> matchedArtists = {};

    for (var playlist in playlistStore.playlists) {
      if (playlist.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
        matchedPlaylists.add(playlist);
      }
      for (var track in playlist.tracks) {
        if (track.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            track.artist.toLowerCase().contains(_searchQuery.toLowerCase())) {
          if (!matchedTracks.any((t) => t.id == track.id)) {
            matchedTracks.add(track);
          }
        }
        if (track.artist.toLowerCase().contains(_searchQuery.toLowerCase())) {
          matchedArtists.add(track.artist);
        }
      }
    }

    final hasResults = matchedTracks.isNotEmpty || matchedPlaylists.isNotEmpty;

    if (!hasResults) {
      return Center(
        child: Text(
          'Nenhum resultado encontrado para "$_searchQuery"',
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSubFilterChip('Melhores resultados'),
                _buildSubFilterChip('Artistas'),
                _buildSubFilterChip('Músicas'),
                _buildSubFilterChip('Playlists'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (_selectedSubFilter == 'Melhores resultados' || _selectedSubFilter == 'Artistas') ...[
            const Text(
              'Melhor resultado',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            _buildBestMatchCard(matchedTracks, matchedArtists, playerStore),
            const SizedBox(height: 24),
          ],
          if ((_selectedSubFilter == 'Melhores resultados' || _selectedSubFilter == 'Playlists') &&
              matchedPlaylists.isNotEmpty) ...[
            Text(
              'Inclui "$_searchQuery"',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 190,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: matchedPlaylists.length,
                itemBuilder: (context, index) {
                  final playlist = matchedPlaylists[index];
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
                      width: 120,
                      margin: const EdgeInsets.only(right: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(playlist.imageUrl, height: 120, width: 120, fit: BoxFit.cover),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            playlist.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                          ),
                          Text(
                            'Playlist',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (_selectedSubFilter == 'Melhores resultados' || _selectedSubFilter == 'Músicas') ...[
            const Text(
              'Músicas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: matchedTracks.length,
              itemBuilder: (context, index) {
                final track = matchedTracks[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(track.imageUrl, width: 48, height: 48, fit: BoxFit.cover),
                  ),
                  title: Text(
                    track.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                  ),
                  subtitle: Text(
                    track.artist,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  trailing: const Icon(Icons.more_vert, color: Colors.grey),
                  onTap: () {
                    playerStore.selectTrack(track);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VideoPlayerScreen(),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubFilterChip(String label) {
    final isSelected = _selectedSubFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSubFilter = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1DB954) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBestMatchCard(List<Track> matchedTracks, Set<String> matchedArtists, PlayerStore playerStore) {
    if (matchedArtists.isNotEmpty) {
      final artistName = matchedArtists.first;
      final artistPic = matchedTracks.firstWhere((t) => t.artist == artistName).imageUrl;

      return GestureDetector(
        onTap: () {
          final artistTracks = matchedTracks.where((t) => t.artist == artistName).toList();
          
          final artistPlaylist = Playlist(
            id: 'artist_${artistName.hashCode}',
            name: artistName,
            imageUrl: artistPic,
            description: 'As melhores faixas de sucesso do artista $artistName.',
            tracks: artistTracks,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PlaylistDetailScreen(playlist: artistPlaylist),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(artistPic),
              ),
              const SizedBox(height: 16),
              Text(
                artistName,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Artista',
                      style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (matchedTracks.isNotEmpty) {
      final track = matchedTracks.first;
      return GestureDetector(
        onTap: () {
          playerStore.selectTrack(track);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const VideoPlayerScreen(),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(track.imageUrl, height: 80, width: 80, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              Text(
                track.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                'Música • ${track.artist}',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}