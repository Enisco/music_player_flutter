// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:music_player_flutter/api_service/api_service.dart';
import 'package:music_player_flutter/music_player_resources/music_model.dart';
import 'package:music_player_flutter/music_player_resources/music_service.dart';
import 'package:music_player_flutter/views/music_player_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    ApiService().fetchMusicData();
  }

  List<MusicModel> musicTracks = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23, 23, 23, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(23, 23, 23, 1),
        title: const Text(
          "Enisco Music Player",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 110,
                color: Colors.black87,
                child: StreamBuilder<Object>(
                  stream: audioHandlerMain.queueState,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: songsList.length,
                        itemBuilder: (context, index) {
                          if (songsList.isEmpty) {
                            return const Text("Fetching songs list");
                          } else {
                            return Material(
                              color: Colors.black,
                              child: ListTile(
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        "${songsList[index].artUri}",
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  songsList[index].title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Text(
                                  songsList[index].artist ?? '',
                                ),
                                onTap: () async {
                                  await audioHandlerMain.skipToQueueItem(index);
                                  await showMusicPlayerScreen(context);
                                },
                              ),
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ),
              Container(
                height: 65,
                color: const Color.fromRGBO(23, 23, 23, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
