import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MaterialApp(
      title: 'Learning and Development',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  List<String> videoFiles = [
    'assets/video/xpert_1.mp4',
    'assets/video/xpert_2.mp4',
    'assets/video/xpert_3.mp4',
    'assets/video/xpert_4.mp4',
    'assets/video/xpert_5.mp4',
    'assets/video/xpert_6.mp4',
    'assets/video/xpert_7.mp4',
  ];

  int currentVideoIndex = 0;
  late VideoPlayerController _controller;
  bool _showFeedbackButtons = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(videoFiles[currentVideoIndex])
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(false);
        _controller.addListener(() {
          if (_controller.value.position >=
              _controller.value.duration - const Duration(seconds: 5)) {
            setState(() {
              _showFeedbackButtons = true;
            });
          }
          if (_controller.value.position >= _controller.value.duration) {
            playNextVideo();
          }
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void playNextVideo() {
    setState(() {
      currentVideoIndex = (currentVideoIndex + 1) % videoFiles.length;
      _showFeedbackButtons = false;
      _controller.dispose();
      _controller = VideoPlayerController.asset(videoFiles[currentVideoIndex])
        ..initialize().then((_) {
          setState(() {});
          _controller.play();
          _controller.setLooping(false);
          _controller.addListener(() {
            if (_controller.value.position >=
                _controller.value.duration - const Duration(seconds: 5)) {
              setState(() {
                _showFeedbackButtons = true;
              });
            }
            if (_controller.value.position >= _controller.value.duration) {
              playNextVideo();
            }
          });
        });
    });
  }

  void collectFeedback(bool learned) {
// Add code here to collect the user's feedback and store it for each individual video
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: playNextVideo,
                child: _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : Container(),
              ),
            ),
            if (_showFeedbackButtons)
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.black54,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Did you learn something from this video?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.green,
                          ),
                          child: TextButton(
                            child: const Text(
                              'Yes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () {
                              collectFeedback(true);
                              setState(() {
                                _showFeedbackButtons = false;
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.red,
                          ),
                          child: TextButton(
                            child: const Text(
                              'No',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () {
                              collectFeedback(false);
                              setState(() {
                                _showFeedbackButtons = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.black,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'XpertLearning Portal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Switch(
                value: _controller.value.isLooping,
                onChanged: (value) {
                  setState(() {
                    _controller.setLooping(value);
                  });
                },
                activeColor: Colors.white,
              ),
            ],
          ),
        ));
  }
}
