// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:http/http.dart' as http;
import 'package:music_player_flutter/main.dart';
import 'package:music_player_flutter/music_model.dart';

class ApiService {
  fetchMusicData() async {
    List<MusicModel>? tracks = [];
    try {
      final response = await http.get(
        Uri.parse('https://api.deezer.com/artist/321/top?limit=10'),
      ); // Replace with your desired API endpoint
      if (response.statusCode == 200) {
        var dataBody = json.decode(response.body)['data'];
        if (dataBody != null) {
          tracks = (dataBody)
              .map((i) => MusicModel.fromJson(i))
              .toList()
              .cast<MusicModel>();
          print('Music data = ${tracks?.length} >>> ${tracks?.first.title}');
          // Populate the music list
          songsList = [];
          songsList = convertToMediaItemList(tracks!);
          // AudioPlayerHandlerImpl()
          audioHandlerMain
            // ..removeQueueItemAt(0)
            // ..insertQueueItem(0, songsList.first)
            ..addQueueItems(songsList)
            ..updateQueue(songsList);

          print(
              " \n <-- AudioPlayer Queue Length: ${audioHandlerMain.queue.value.length}");
        } else {
          tracks = [];
          print('Failed to load music data');
        }
      } else {
        tracks = [];
        print('Failed to load music data');
      }
    } catch (e) {
      tracks = [];
      print('Error loading music data: ${e.toString()}');
    }
    print('Songs list = ${songsList.length} >>> ${songsList.first.title}');
  }

  List<MediaItem> convertToMediaItemList(List<MusicModel> musicList) {
    return musicList.map((music) {
      return MediaItem(
        id: music.preview ?? '',
        album: music.album?.title ?? '',
        title: music.title ?? '',
        artist: music.artist?.name ?? '',
        duration: Duration(seconds: music.duration ?? 0),
        artUri: music.album != null
            ? Uri.parse(music.album!.coverMedium ?? '')
            : null,
      );
    }).toList();
  }
}
