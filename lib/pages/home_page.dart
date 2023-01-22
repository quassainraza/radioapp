import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:volume_controller/volume_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _setVolumeValue = 0; //variable to set volume
  late AssetsAudioPlayer audioPlayer; //audioplayer object
  bool isPlaying = false; //for displaying play/pause
  double value = 0; //for getting the value of system volume
  // Interstitial Ads from Firebase Remote Config
  String getAppId() {
    return "ca-app-pub-3940256099942544~3347511713"; // Test App ID
  }

  String getBannerAdUnitId() {
    return "ca-app-pub-3940256099942544/6300978111"; // Test banner ad unit ID
  }

  @override
  void initState() {
    super.initState();
    audioPlayer =
        AssetsAudioPlayer.newPlayer(); //audioplayer object is initialized
    openPlayer(); //async function to open up my assets folder
    setState(() {
      audioPlayer.play(); //refreshing the ui to achieve Autoplay
      isPlaying = true;
    });
    VolumeController()
        .getVolume()
        .then((volume) => _setVolumeValue = volume); //controller to get volume
  }

  void openPlayer() async {
    audioPlayer.open(Audio('assets/Silence.mp3'),
        autoStart: !isPlaying,
        showNotification: true); //open up my assets folder
  }

  @override
  void dispose() {
    audioPlayer
        .dispose(); // works just like destructor to avoid any mem leakage..
    VolumeController().removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBar(
            title: "Online Radio App"
                .text
                .xl4
                .bold
                .black
                .fontFamily("Poppins")
                .make(),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
          ).h(100.0).px12(),
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/Queen.jpg',
                height: 250,
                scale: 1.5,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Artist Name",
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Calibri"),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () async {
                        try {
                          final ByteData bytes =
                              await rootBundle.load('assets/Silence.mp3');
                          await Share.file('esys music', 'Audio.mp3',
                              bytes.buffer.asUint8List(), 'audio/mpeg',
                              text: 'My optional mp3 file.');
                        } catch (e) {
                          //print('error: $e');
                        }
                      },
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.share_rounded,
                        size: 30,
                        color: Colors.black54,
                      ),
                    ),
                    CircleAvatar(
                      radius: 30,
                      child: IconButton(
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 20),
                        iconSize: 30,
                        onPressed: () async {
                          if (isPlaying) {
                            await audioPlayer.pause();
                            setState(() {
                              isPlaying = false;
                            });
                          } else {
                            await audioPlayer.play();
                            setState(() {
                              isPlaying = true;
                            });
                          }
                        },
                      ),
                    ),
                    Slider(
                      min: 0,
                      max: 1,
                      onChanged: (double value) {
                        _setVolumeValue = value;
                        audioPlayer.setVolume(_setVolumeValue);
                        VolumeController().setVolume(_setVolumeValue);
                        setState(() {});
                      },
                      value: _setVolumeValue,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      color: Colors.transparent,
                      child: const IconButton(
                        onPressed: null,
                        icon: Icon(FontAwesomeIcons.facebook,
                            color: Colors.blue, size: 30.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      color: Colors.transparent,
                      child: const IconButton(
                        onPressed: null,
                        icon: Icon(FontAwesomeIcons.instagram,
                            color: Colors.red, size: 30.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      color: Colors.transparent,
                      child: const IconButton(
                        onPressed: null,
                        icon: Icon(FontAwesomeIcons.twitter,
                            color: Colors.blue, size: 30.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      color: Colors.transparent,
                      child: const IconButton(
                        onPressed: null,
                        icon: Icon(FontAwesomeIcons.youtube,
                            color: Colors.red, size: 30.0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ) //Column
              ),
        ],
      ),
    );
  }
}

Future<String> getTemporaryDirectoryPath() async {
  final tempDir = await getTemporaryDirectory();
  return tempDir.path;
}
