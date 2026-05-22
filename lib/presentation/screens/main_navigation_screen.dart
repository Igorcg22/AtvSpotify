import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../stores/playlist_store.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'playlist_detail_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const SearchScreen(),
      const MockLibraryScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black.withOpacity(0.95),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: const Color(0xFF1DB954),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.home_filled, size: 26),
              ),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.search, size: 26),
              ),
              label: 'Buscar',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.library_music_outlined, size: 26),
              ),
              label: 'Sua Biblioteca',
            ),
          ],
        ),
      ),
    );
  }
}

class MockLibraryScreen extends StatelessWidget {
  const MockLibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playlistStore = context.watch<PlaylistStore>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://picsum.photos/seed/user/100'),
            ),
            SizedBox(width: 12),
            Text('Sua Biblioteca', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (playlistStore.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1DB954)));
          }

          return ListView.builder(
            itemCount: playlistStore.playlists.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemBuilder: (context, index) {
              final playlist = playlistStore.playlists[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(playlist.imageUrl, width: 64, height: 64, fit: BoxFit.cover),
                ),
                title: Text(
                  playlist.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                ),
                subtitle: Text(
                  'Playlist • ${playlist.tracks.length} músicas',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaylistDetailScreen(playlist: playlist),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}