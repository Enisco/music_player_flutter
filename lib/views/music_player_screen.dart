// ignore_for_file: avoid_print, must_be_immutable

import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player_flutter/music_player_resources/common.dart';
import 'package:music_player_flutter/music_player_resources/custom_overlay.dart';
import 'package:music_player_flutter/music_player_resources/music_service.dart';
import 'package:rxdart/rxdart.dart';

showMusicPlayerScreen(
  BuildContext context,
) async {
  hideOverlay = true;
  await showGeneralDialog(
    context: context,
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween(
          begin: const Offset(0.0, 0.5),
          end: const Offset(0.0, 0.0),
        ).animate(animation),
        child: ScaleTransition(
          scale: animation,
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return Material(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: const MusicPlayScreen(),
        ),
      );
    },
  ).whenComplete(() {
    print("Dialog done");
    hideOverlay = false;
  });
}

class MusicPlayScreen extends StatelessWidget {
  const MusicPlayScreen({super.key});

  Stream<Duration> get _bufferedPositionStream => audioHandlerMain.playbackState
      .map((state) => state.bufferedPosition)
      .distinct()
      .asBroadcastStream();
  Stream<Duration?> get _durationStream =>
      audioHandlerMain.mediaItem.map((item) => item?.duration).distinct();
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        AudioService.position,
        _bufferedPositionStream,
        _durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      ).asBroadcastStream();

  @override
  Widget build(BuildContext context) {
    hideOverlay = true;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.brown.shade900,
              Colors.black,
              Colors.black,
            ],
            stops: const [0.1, 0.45, 1],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewPadding.top,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: audioHandlerMain.mediaItem.value?.album == null
                          ? "Artist: "
                          : "Album: ",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white60,
                      ),
                      children: [
                        TextSpan(
                          text: audioHandlerMain.mediaItem.value?.album ??
                              audioHandlerMain.mediaItem.value?.artist ??
                              "Unknown",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            // MediaItem display
            Expanded(
              flex: 3,
              child: StreamBuilder<MediaItem?>(
                stream: audioHandlerMain.mediaItem,
                builder: (context, snapshot) {
                  final mediaItem = snapshot.data;
                  if (mediaItem == null) return const SizedBox();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (mediaItem.artUri != null)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage('${mediaItem.artUri!}'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: Text(
                          mediaItem.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            // fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: Text(
                          mediaItem.artist ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
            // A seek bar.
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data ??
                    PositionData(Duration.zero, Duration.zero, Duration.zero);
                return SeekBar(
                  duration: positionData.duration,
                  position: positionData.position,
                  onChangeEnd: (newPosition) {
                    audioHandlerMain.seek(newPosition);
                  },
                );
              },
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Repeat control
                StreamBuilder<AudioServiceRepeatMode>(
                  stream: audioHandlerMain.playbackState
                      .map((state) => state.repeatMode)
                      .distinct(),
                  builder: (context, snapshot) {
                    final repeatMode =
                        snapshot.data ?? AudioServiceRepeatMode.none;
                    const icons = [
                      Icon(Icons.repeat, color: Colors.grey),
                      Icon(Icons.repeat, color: Colors.orange),
                      Icon(Icons.repeat_one, color: Colors.orange),
                    ];
                    const cycleModes = [
                      AudioServiceRepeatMode.none,
                      AudioServiceRepeatMode.all,
                      AudioServiceRepeatMode.one,
                    ];
                    final index = cycleModes.indexOf(repeatMode);
                    return IconButton(
                      icon: icons[index],
                      onPressed: () {
                        audioHandlerMain.setRepeatMode(
                          cycleModes[(cycleModes.indexOf(repeatMode) + 1) %
                              cycleModes.length],
                        );
                      },
                    );
                  },
                ),

                // Playback controls
                ControlButtons(
                  audioHandler: audioHandlerMain,
                  positionDataStream: _positionDataStream,
                ),

                // Shuffle controls
                StreamBuilder<bool>(
                  stream: audioHandlerMain.playbackState
                      .map((state) =>
                          state.shuffleMode == AudioServiceShuffleMode.all)
                      .distinct(),
                  builder: (context, snapshot) {
                    final shuffleModeEnabled = snapshot.data ?? false;
                    return IconButton(
                      icon: shuffleModeEnabled
                          ? const Icon(Icons.shuffle, color: Colors.orange)
                          : const Icon(Icons.shuffle, color: Colors.grey),
                      onPressed: () async {
                        final enable = !shuffleModeEnabled;
                        await audioHandlerMain.setShuffleMode(
                          enable
                              ? AudioServiceShuffleMode.all
                              : AudioServiceShuffleMode.none,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}

class ControlButtons extends StatefulWidget {
  Stream<PositionData> positionDataStream;
  final AudioPlayerHandler audioHandler;

  ControlButtons({
    super.key,
    required this.audioHandler,
    required this.positionDataStream,
  });

  @override
  State<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<QueueState>(
          stream: widget.audioHandler.queueState,
          builder: (context, snapshot) {
            final queueState = snapshot.data ?? QueueState.empty;
            return IconButton(
              icon: Icon(
                Icons.skip_previous_rounded,
                size: 35,
                color: queueState.hasPrevious
                    ? Colors.white
                    : Colors.white.withOpacity(0.3),
              ),
              onPressed: queueState.hasPrevious
                  ? widget.audioHandler.skipToPrevious
                  : null,
            );
          },
        ),
        SizedBox(
          height: 70,
          child: StreamBuilder<PlaybackState>(
            stream: widget.audioHandler.playbackState,
            builder: (context, snapshot) {
              final playbackState = snapshot.data;
              final processingState = playbackState?.processingState;
              final playing = playbackState?.playing;
              if (processingState == AudioProcessingState.loading ||
                  processingState == AudioProcessingState.buffering) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  height: 70,
                  width: 70,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  ),
                );
              } else if (playing != true) {
                return SizedBox(
                  height: 70,
                  width: 70,
                  child: IconButton(
                    icon: const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.play_arrow,
                        size: 38,
                        color: Colors.black,
                      ),
                    ),
                    iconSize: 64.0,
                    onPressed: () {
                      widget.audioHandler.play();
                      if (musicOverlayIsActive == false) {
                        showMusicOverlay(
                          context,
                          audioHandler: audioHandlerMain,
                          positionDataStream: widget.positionDataStream,
                        );
                        musicOverlayIsActive = true;
                      } else {
                        print("Overlay is already active. Updating");
                      }
                      setState(() {});
                    },
                  ),
                );
              } else {
                return SizedBox(
                  height: 70,
                  width: 70,
                  child: IconButton(
                    icon: const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.pause,
                        size: 38,
                        color: Colors.black,
                      ),
                    ),
                    iconSize: 64.0,
                    onPressed: widget.audioHandler.pause,
                  ),
                );
              }
            },
          ),
        ),
        StreamBuilder<QueueState>(
          stream: widget.audioHandler.queueState,
          builder: (context, snapshot) {
            final queueState = snapshot.data ?? QueueState.empty;
            return IconButton(
              icon: Icon(
                Icons.skip_next_rounded,
                size: 35,
                color: queueState.hasNext
                    ? Colors.white
                    : Colors.white.withOpacity(0.3),
              ),
              onPressed:
                  queueState.hasNext ? widget.audioHandler.skipToNext : null,
            );
          },
        ),
      ],
    );
  }
}
