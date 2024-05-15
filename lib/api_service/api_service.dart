// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:http/http.dart' as http;
import 'package:music_player_flutter/music_player_resources/music_model.dart';
import 'package:music_player_flutter/music_player_resources/music_service.dart';

class ApiService {
  fetchMusicData() async {
    List<MusicModel>? tracks = [];
    try {
      final response = await http.get(
        Uri.parse('https://api.deezer.com/artist/333/top?limit=10'),
      ); // Replace with your desired API endpoint
      if (response.statusCode == 200) {
        var dataBody = json.decode(response.body)['data'];
        if (dataBody != null) {
          tracks = (dataBody)
              .map((i) => MusicModel.fromJson(i))
              .toList()
              .cast<MusicModel>();
          print('Music data = ${tracks?.length} >>> ${tracks?.first.title}');

          songsList = [];
          songsList = convertToMediaItemList(tracks!);

          // Add the retrieved list to playlist Queue
          await audioHandlerMain.addQueueItems(songsList);
          await audioHandlerMain.updateQueue(songsList);
          await audioHandlerMain.playMediaItem(songsList.first);
          print('Done updating queue');
          print("AudioPlayer Queue: ${audioHandlerMain.queue.value.length}");
          print(
              "Duration check: ${songsList.first.duration} - ${songsList[3].duration}");
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
      String artistsNames = getArtistsNames(music.contributors);
      return MediaItem(
        id: music.preview ?? '',
        album: music.album?.title ?? '',
        title: music.title ?? '',
        artist: artistsNames,
        duration: Duration(seconds: music.duration ?? 0),
        artUri: music.album != null
            ? Uri.parse(music.album!.coverMedium ?? '')
            : null,
      );
    }).toList();
  }

  getArtistsNames(List<Contributor>? contributors) {
    String artistsNames = '${contributors?.first.name}';
    if (contributors!.length > 1) {
      for (int i = 1; i < contributors.length; i++) {
        artistsNames = "$artistsNames, ${contributors[i].name}";
      }
    }
    return artistsNames;
  }
}
