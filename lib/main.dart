import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(
      const MyApp(),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Video Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isFullScreen = false;
  bool _isRotated = false;
  bool _controlsVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/28052-367411298_large.mp4',
    );

    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleRotation() {
    setState(() {
      _isRotated = !_isRotated;
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  void _seekForward() {
    final newPosition =
        _controller.value.position + const Duration(seconds: 10);
    _controller.seekTo(newPosition);
  }

  void _seekBackward() {
    final newPosition =
        _controller.value.position - const Duration(seconds: 10);
    _controller.seekTo(newPosition);
  }

  void _toggleControls() {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTap: _toggleControls,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Transform.rotate(
                        angle:
                            _isRotated ? 3.14159 / 2 : 0, // 90 degrees rotation
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                  if (_controlsVisible) ...[
                    Positioned(
                      left: 40,
                      bottom: 370,
                      child: InkWell(
                        onTap: _seekBackward,
                        child: const Icon(
                          Icons.replay_10,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      bottom: 370,
                      child: InkWell(
                        onTap: _seekForward,
                        child: const Icon(
                          Icons.forward_10,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Positioned(
                    //   left: 10,
                    //   top: 10,
                    //   child: InkWell(
                    //     onTap: _toggleRotation,
                    //     child: Icon(Icons.rotate_90_degrees_ccw, size: 36),
                    //   ),
                    // ),
                    // Positioned(
                    //   right: 10,
                    //   top: 10,
                    //   child: InkWell(
                    //     onTap: _toggleFullScreen,
                    //     child: Icon(
                    //         _isFullScreen
                    //             ? Icons.fullscreen_exit
                    //             : Icons.fullscreen,
                    //         size: 36),
                    //   ),
                    // ),
                    Positioned(
                      bottom: 370,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                          });
                        },
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 290,
                      left: 10,
                      right: 10,
                      child: VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                      ),
                    ),
                  ],
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
