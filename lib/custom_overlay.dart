// ignore_for_file: avoid_print, must_be_immutable

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player_flutter/music_player_screen.dart';

OverlayEntry? overlayEntry;
bool hideOverlay = false;

closeOverlay(AudioHandler audioHandler) {
  overlayEntry?.remove();
  audioHandler.pause();
}

void showMusicOverlay(
  BuildContext context, {
  required AudioHandler audioHandler,
}) {
  // getDurationStream() {
  //   return audioHandler.mediaItem.map((item) => item?.duration).distinct();
  // }

  // getBufferedPositionStream() {
  //   return audioHandler.playbackState
  //       .map((state) => state.bufferedPosition)
  //       .distinct().asBroadcastStream();
  // }

  // Stream<Duration> bufferedPositionStream = getBufferedPositionStream();

  // Stream<Duration?> durationStream = getDurationStream();

  // getPositionDataStream() {
  //   return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
  //     AudioService.position,
  //     bufferedPositionStream,
  //     durationStream,
  //     (position, bufferedPosition, duration) => PositionData(
  //       position,
  //       bufferedPosition,
  //       duration ?? Duration.zero,
  //     ),
  //   ).asBroadcastStream();
  // }

  // Stream<PositionData> positionDataStream = getPositionDataStream();

  OverlayEntry buildOverlay() {
    return OverlayEntry(
      builder: (context) => Positioned(
        bottom: 65,
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
                          height: 59,
                          padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade400,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.network(
                                    '${audioHandler.mediaItem.value?.artUri!}',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
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
                                            audioHandler
                                                    .mediaItem.value?.title ??
                                                "No music playing",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            audioHandler
                                                    .mediaItem.value?.artist ??
                                                " ",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 14,
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
                                      final playing = playbackState?.playing;
                                      if (processingState ==
                                              AudioProcessingState.loading ||
                                          processingState ==
                                              AudioProcessingState.buffering) {
                                        return Container(
                                          margin: const EdgeInsets.all(8.0),
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
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          // child: StreamBuilder<PositionData>(
                          //   stream: positionDataStream,
                          //   builder: (context, snapshot) {
                          //     final positionData = snapshot.data ??
                          //         PositionData(
                          //           Duration.zero,
                          //           Duration.zero,
                          //           Duration.zero,
                          //         );

                          //     return ProgressBar(
                          //       thumbRadius: 0,
                          //       barHeight: 2,
                          //       timeLabelLocation: TimeLabelLocation.none,
                          //       baseBarColor: Colors.white,
                          //       progressBarColor: Colors.amber,
                          //       thumbColor: Colors.transparent,
                          //       thumbGlowRadius: 0,
                          //       progress: positionData.position,
                          //       total: positionData.duration,
                          //     );
                          //   },
                          // ),
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
