// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:music_player_flutter/music_model.dart';

List<MusicModel>? tracks = [];

class ApiService {
  fetchMusicData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.deezer.com/artist/321/top?limit=10')); // Replace with your desired API endpoint
      if (response.statusCode == 200) {
        var dataBody = json.decode(response.body)['data'];
        if (dataBody != null) {
          tracks = (dataBody)
              .map((i) => MusicModel.fromJson(i))
              .toList()
              .cast<MusicModel>();
        }
      } else {
        tracks = [];
        print('Failed to load music data');
      }
    } catch (e) {
      tracks = [];
      print('Error loading music data: ${e.toString()}');
    }
    print('Music data = ${tracks?.length} >>>\n${tracks?.first.title}');
    return tracks;
  }
}
