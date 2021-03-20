import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify2_app/core/services/player_service.dart';
import 'package:spotify2_app/core/services/player_service.dart';
import 'package:spotify2_app/presentation/components/ProfileComponents/vertical_playlist.dart';
import 'package:spotify2_app/presentation/screens/player_screen.dart';

class SongSlider extends StatefulWidget {
  @override
  _SongSliderState createState() => _SongSliderState();
}

class _SongSliderState extends State<SongSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<SliderState>(
            stream: PlayerService.getCurrentMediaDurations(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                double remainingDuration = 0.0;
                if(snapshot?.data?.duration?.inSeconds?.toDouble() != null){
                  remainingDuration =
                      snapshot.data?.duration?.inSeconds?.toDouble() -
                          snapshot.data?.position?.inSeconds?.toDouble();
                }

                return Column(
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        thumbColor: Theme.of(context).primaryColor,
                        activeTrackColor: Colors.green,
                        inactiveTrackColor: Colors.grey[800],
                      ),
                      child: Slider(
                        onChanged: (val) async {
                          PlayerService.seekTo(Duration(seconds: val.toInt()));
                        },
                        min: 0,
                        max: (snapshot.data?.duration?.inSeconds?.toDouble() != null) ? snapshot.data?.duration?.inSeconds?.toDouble() : 0.0,
                        value: snapshot.data?.position?.inSeconds?.toDouble(),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (snapshot.data?.duration != null)
                              ? Text(
              snapshot.data?.duration?.inSeconds?.toDouble()?.toString(),
                            style: Theme.of(context).textTheme.subtitle2,
                          )
                              : Text(
                            0.0.toString(),
                            style: Theme.of(context).textTheme.subtitle2,
                          ),

                          Text(
                            remainingDuration.toString(),
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.favorite_outline,
                color: Colors.white,
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous),
                    color: Colors.white,
                    onPressed: () async {
                      await PlayerService.skipPrev();
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  StreamBuilder<PlayerState>(
                      stream: PlayerService.getPlayerStateStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(70)),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.green,
                              child: IconButton(
                                icon: snapshot.data.playing?Icon(Icons.pause) : Icon(Icons.play_arrow),
                                color: Colors.white,
                                iconSize: 30,
                                onPressed: () async {
                                  snapshot.data.playing ? await PlayerService.pause() :
                                  await PlayerService.play();
                                },
                              ),
                            ),
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next),
                    color: Colors.white,
                    onPressed: () async {
                      await PlayerService.skipNext();
                    },
                  ),
                ],
              ),
              Icon(
                Icons.arrow_circle_down,
                color: Colors.white,
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.shuffle,
                color: Colors.white,
              ),
              Icon(
                Icons.cloud_download,
                color: Colors.white,
              )
            ],
          ),
        ),
      ],
    );
  }
}
