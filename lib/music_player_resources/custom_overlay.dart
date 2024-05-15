// ignore_for_file: avoid_print, must_be_immutable

import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_player_flutter/music_player_resources/common.dart';
import 'package:music_player_flutter/views/music_player_screen.dart';

OverlayEntry? overlayEntry;
bool hideOverlay = false;
bool musicOverlayIsActive = false;

closeOverlay(AudioHandler audioHandler) {
  overlayEntry?.remove();
  audioHandler.pause();
  musicOverlayIsActive = false;
}

void showMusicOverlay(
  BuildContext context, {
  required AudioHandler audioHandler,
  required Stream<PositionData> positionDataStream,
}) {
  OverlayEntry buildOverlay() {
    return OverlayEntry(
      builder: (context) => Positioned(
        bottom: 5,
        left: 0,
        right: 0,
        child: hideOverlay
            ? const SizedBox.shrink()
            : Material(
                color: Colors.transparent,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  height: 59,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      showMusicPlayerScreen(context);
                    },
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(23, 23, 23, 1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              StreamBuilder<MediaItem?>(
                                  stream: audioHandler.mediaItem,
                                  builder: (context, snapshot) {
                                    final mediaItem = snapshot.data;

                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 35,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                '${mediaItem?.artUri!}',
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: SizedBox(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  mediaItem?.title ??
                                                      "No music playing",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  mediaItem?.artist ?? " ",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white60,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        StreamBuilder<PlaybackState>(
                                          stream: audioHandler.playbackState,
                                          builder: (context, snapshot) {
                                            final playbackState = snapshot.data;
                                            final processingState =
                                                playbackState?.processingState;
                                            final playing =
                                                playbackState?.playing;
                                            if (processingState ==
                                                    AudioProcessingState
                                                        .loading ||
                                                processingState ==
                                                    AudioProcessingState
                                                        .buffering) {
                                              return Container(
                                                margin:
                                                    const EdgeInsets.all(8.0),
                                                width: 34.0,
                                                height: 34.0,
                                                child:
                                                    const CircularProgressIndicator(
                                                  color: Colors.orange,
                                                ),
                                              );
                                            } else if (playing != true) {
                                              return IconButton(
                                                icon: const Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.white,
                                                ),
                                                onPressed: audioHandler.play,
                                              );
                                            } else {
                                              return IconButton(
                                                icon: const Icon(
                                                  Icons.pause,
                                                  color: Colors.white,
                                                ),
                                                onPressed: audioHandler.pause,
                                              );
                                            }
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {
                                            closeOverlay(audioHandler);
                                          },
                                          child: const Icon(
                                            Icons.close_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          child: StreamBuilder<PositionData>(
                            stream: positionDataStream,
                            builder: (context, snapshot) {
                              final positionData = snapshot.data ??
                                  PositionData(
                                    Duration.zero,
                                    Duration.zero,
                                    Duration.zero,
                                  );

                              return ProgressBar(
                                thumbRadius: 0,
                                barHeight: 2,
                                timeLabelLocation: TimeLabelLocation.none,
                                baseBarColor: Colors.grey,
                                progressBarColor: Colors.amber,
                                thumbColor: Colors.transparent,
                                thumbGlowRadius: 0,
                                progress: positionData.position,
                                total: positionData.duration,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  // Show the overlay
  overlayEntry = buildOverlay();
  Overlay.of(context).insert(overlayEntry!);
}
