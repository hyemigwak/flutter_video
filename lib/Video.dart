import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';



class VideoApp extends StatefulWidget {
  const VideoApp({super.key});


  @override
  _VideoApp createState() => _VideoApp();
}

class _VideoApp extends State<VideoApp>{

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  double speed = 1.0;


  @override
  void initState() {
    _controller = VideoPlayerController.network(
        "https://amytest2.s3.ap-northeast-2.amazonaws.com/morning.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.setLooping(false);
    _controller.setPlaybackSpeed(speed);


    super.initState();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30, top: 30),
          child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: () {
                      setState((){
                        if(_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      });
                    },
                    child: Icon(
                      _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: (){
                      setState((){
                        if(_controller.value.volume == 0.0) {
                          _controller.setVolume(1.0);
                        } else {
                          _controller.setVolume(0.0);
                        }

                      });
                    },
                    child: Icon(_controller.value.volume == 1.0 ? Icons.volume_up : Icons.volume_off),
                    ),
                  FloatingActionButton(
                    onPressed: (){

                      setState((){
                        speed -= 0.25;
                        _controller.setPlaybackSpeed(speed);
                      });
                    },
                    child: Icon(Icons.keyboard_double_arrow_left)
                  ),
                  FloatingActionButton(
                    onPressed: (){

                      setState((){
                        speed = 1.0;
                        _controller.setPlaybackSpeed(1.0);
                      });
                    },
                    child: Text("$speed"),
                  ),
                  FloatingActionButton(
                    onPressed: (){
                      setState((){
                        speed += 0.25;
                        _controller.setPlaybackSpeed(speed);
                      });
                    },
                    child: Icon(Icons.keyboard_double_arrow_right)
                  ),
                ]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                    onPressed: (){
                      setState((){
                        _controller.seekTo(Duration(seconds: -3));
                      });
                    },
                    child: Text("3초 전")
                ),
                FloatingActionButton(
                    onPressed: (){
                      setState((){
                        _controller.seekTo(Duration(seconds: 3));
                      });
                    },
                    child: Text("3초 뒤")
                )
              ],
          )
        ],
        ),
      ),


    );
  }
}



