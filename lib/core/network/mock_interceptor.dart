import 'package:dio/dio.dart';

class MockInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path.contains('/playlists')) {
      final mockResponse = {
        'playlists': [
          {
            'id': 'p1',
            'name': 'Today\'s Top Hits',
            'imageUrl': 'https://picsum.photos/seed/tth/300',
            'description': 'Billie Eilish, Sabrina Carpenter and the hottest hits!',
            'tracks': [
              {
                'id': 't1',
                'title': 'Birds of a Feather',
                'artist': 'Billie Eilish',
                'duration': 180,
                'imageUrl': 'https://picsum.photos/seed/birds/300',
                'videoUrl': ''
              },
              {
                'id': 't2',
                'title': 'Espresso',
                'artist': 'Sabrina Carpenter',
                'duration': 152,
                'imageUrl': 'https://picsum.photos/seed/espresso/300',
                'videoUrl': ''
              },
              {
                'id': 't3',
                'title': 'Starboy',
                'artist': 'The Weeknd',
                'duration': 230,
                'imageUrl': 'https://picsum.photos/seed/starboy/300',
                'videoUrl': ''
              },
              {
                'id': 't4',
                'title': 'Cruel Summer',
                'artist': 'Taylor Swift',
                'duration': 178,
                'imageUrl': 'https://picsum.photos/seed/cruel/300',
                'videoUrl': ''
              },
              {
                'id': 't5',
                'title': 'As It Was',
                'artist': 'Harry Styles',
                'duration': 167,
                'imageUrl': 'https://picsum.photos/seed/asitwas/300',
                'videoUrl': ''
              }
            ]
          },
          {
            'id': 'p2',
            'name': 'Chill Vibes',
            'imageUrl': 'https://picsum.photos/seed/chill/300',
            'description': 'Relax and unwind with these smooth, calm tunes.',
            'tracks': [
              {
                'id': 't6',
                'title': 'Midnight City',
                'artist': 'M83',
                'duration': 240,
                'imageUrl': 'https://picsum.photos/seed/midnight/300',
                'videoUrl': ''
              },
              {
                'id': 't7',
                'title': 'Sweater Weather',
                'artist': 'The Neighbourhood',
                'duration': 240,
                'imageUrl': 'https://picsum.photos/seed/sweater/300',
                'videoUrl': ''
              },
              {
                'id': 't8',
                'title': 'Intro',
                'artist': 'The xx',
                'duration': 128,
                'imageUrl': 'https://picsum.photos/seed/intro/300',
                'videoUrl': ''
              },
              {
                'id': 't9',
                'title': 'Nightcall',
                'artist': 'Kavinsky',
                'duration': 258,
                'imageUrl': 'https://picsum.photos/seed/nightcall/300',
                'videoUrl': ''
              }
            ]
          },
          {
            'id': 'p3',
            'name': 'Retro Classics',
            'imageUrl': 'https://picsum.photos/seed/retro/300',
            'description': 'The biggest hits from golden eras of pop and rock music.',
            'tracks': [
              {
                'id': 't10',
                'title': 'Billie Jean',
                'artist': 'Michael Jackson',
                'duration': 294,
                'imageUrl': 'https://picsum.photos/seed/bjean/300',
                'videoUrl': ''
              },
              {
                'id': 't11',
                'title': 'Smooth Operator',
                'artist': 'Sade',
                'duration': 256,
                'imageUrl': 'https://picsum.photos/seed/sade/300',
                'videoUrl': ''
              },
              {
                'id': 't12',
                'title': 'Stayin Alive',
                'artist': 'Bee Gees',
                'duration': 285,
                'imageUrl': 'https://picsum.photos/seed/alive/300',
                'videoUrl': ''
              },
              {
                'id': 't13',
                'title': 'Take On Me',
                'artist': 'a-ha',
                'duration': 225,
                'imageUrl': 'https://picsum.photos/seed/takeon/300',
                'videoUrl': ''
              }
            ]
          }
        ]
      };

      handler.resolve(
        Response(
          requestOptions: options,
          data: mockResponse,
          statusCode: 200,
        ),
      );
    } else {
      handler.next(options);
    }
  }
}