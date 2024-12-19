import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/android_encoder.dart';
import 'package:intl/intl.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data' show Uint8List;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

class MyVoiceRecorder extends StatefulWidget {
  final String recordName;
  final Function(String, int) onSelectionComplete;

  const MyVoiceRecorder({@required this.recordName, this.onSelectionComplete});
  @override
  _MyVoiceRecorderState createState() => new _MyVoiceRecorderState();
}

enum t_MEDIA {
  FILE,
  BUFFER,
  ASSET,
  STREAM,
}

class _MyVoiceRecorderState extends State<MyVoiceRecorder> {
  bool _isRecording = false;
  bool _isRecorded = false;
  String _path;
  bool _isPlaying = false;
  bool _isDeleted = false;
  StreamSubscription _recorderSubscription;
  StreamSubscription _playerSubscription;
  FlutterSound flutterSound;

  String _recorderTxt = '00:00';
  String _playerTxt = '00:00';
  Uint8List buffer;
  double maxDuration = 1.0;
  t_CODEC _codec = t_CODEC.CODEC_MP3;
  List<String> paths = [
    'sound.aac', // DEFAULT
    'sound.aac', // CODEC_AAC
    'sound.opus', // CODEC_OPUS
    'sound.caf', // CODEC_CAF_OPUS
    'sound.mp3', // CODEC_MP3
    'sound.ogg', // CODEC_VORBIS
    'sound.wav', // CODEC_PCM
  ];

  Permission _permission = Permission.microphone;
  Permission _permission2 = Permission.storage;
  PermissionStatus status, status2;
  bool per1 = false, per2 = false;

  FlutterAudioRecorder _recorder;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  AudioPlayer audioPlayer = AudioPlayer();
  Timer _countdownTimer;

  @override
  void initState() {
    super.initState();
    flutterSound = new FlutterSound();
 
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);
  }
  
  
  Future<int> deleteFile(String customPath) async {
    try {
      File file = File(customPath);

      await file.delete();
    } catch (e) {
      return 0;
    }
  }

  String customPath = "";
  _init() async {
    try { 
      if (await FlutterAudioRecorder.hasPermissions) {
        customPath = '/flutter_audio_recorder';
        Directory appDocDirectory; 
        if (Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path + customPath;
        var dosyaVarmi = await File(customPath + ".wav").exists();

        if (dosyaVarmi) {
          await deleteFile(customPath + ".wav");
        }

        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        var current = await _recorder.current(channel: 0);
        
        setState(() {
          _currentStatus = current.status; 
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("İzinleri kabul etmelisiniz")));
      }
    } catch (e) {
      print(e);
    }
  }

  Recording _current;
  _start() async {
    await _init();
    try {
      await _recorder.start();
      widget.onSelectionComplete("", 90);

      var recording = await _recorder.current(channel: 0);
     
      setState(() {
       
        _current = recording;
        this._recorderTxt = '00:00';
        this._isRecording = true;
        this._isDeleted = false;
      });
      _recorder.current();
       
      Recording current;
      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
      
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }
        current = await _recorder.current(channel: 0);
        
        if (current.duration.inMinutes == 1) _stop();
       
        setState(() {
          _current = current;
          _currentStatus = current.status;
        });
        _recodingTime(current.duration.inMilliseconds);
      });
    } catch (e) {
      print(e);
    }
  }

  _recodingTime(int inMilliseconds) async {
    DateTime date =
        new DateTime.fromMillisecondsSinceEpoch(inMilliseconds, isUtc: true);
    String txt = DateFormat('mm:ss').format(date);
    setState(() {
      this._recorderTxt = txt;
    });
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder.stop();
    /* print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}"); */
    makeBase64(result.path);
    setState(() {
      this._path = result.path;
      this._isRecording = false;
      this._isRecorded = true;
      this._isDeleted = false;
      _currentStatus = _current.status;
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }

  Future startPlayer(_path) async {
      
    if (this._isPlaying) {
      stopPlayer();
      return;
    }
    try {
      if (!await File(_path).exists()) return null;

      audioPlayer = AudioPlayer();
      int result = await audioPlayer.play(_path);

      if (result == 1) {
        this.setState(() {
          this._isPlaying = true;
        });
        audioPlayer.onAudioPositionChanged.listen(((e) {
          DateTime date = new DateTime.fromMillisecondsSinceEpoch(
              e.inMilliseconds,
              isUtc: true);
          String txt = DateFormat('mm:ss').format(date);
          this.setState(() {
            this._playerTxt = txt;
          });
        }));
        audioPlayer.onPlayerCompletion.listen(((e) {
          stopPlayer();
        }));
      }
    } catch (e) {}
  }

  Future stopPlayer() async {
    try {
      int result = await audioPlayer.stop();
      if (result == 1) {
        this.setState(() {
          this._isPlaying = false;
        });
      }
    } catch (e) {}
  }

  Future startRecorder() async {
    /* try {
      String path = await flutterSound.startRecorder();
      widget.onSelectionComplete("", 70);
      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
            e.currentPosition.toInt(),
            isUtc: true);
        String txt = DateFormat('mm:ss').format(date);

        if (date.minute == 1) stopRecorder();

        this.setState(() {
          this._recorderTxt = txt;
        });
      });

      this.setState(() {
        this._isRecording = true;
        this._isDeleted = false;
        this._path = path;
      });
    } catch (e) {
      print(e);
    } */
  }

  void makeBase64(String path) async {
    try {
      if (!await File(path).exists()) return null;
      File file = File(path);
      file.openRead();

      List<int> fileBytes = await file.readAsBytes();
      String base64String = base64Encode(fileBytes);

      String temprecordName = 'data:audio/mp3;base64,$base64String';
     
      widget.onSelectionComplete(temprecordName, 0);
      
    } catch (e) {
      /* print(e.toString()+"<<<<<"); */
      return null;
    }
  }

  /* void stopRecorder() async {
    try {
      String result = await flutterSound.stopRecorder();
     

      if (_recorderSubscription != null) {
        _recorderSubscription.cancel();
        _recorderSubscription = null;
      }

      this.setState(() {
        this._isRecording = false;
        this._isRecorded = true;
        this._isDeleted = false;
      });
      makeBase64(this._path);
    } catch (err) {
      print('error: $err');
    }
  } */

  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  Future<Uint8List> makeBuffer(String path) async {
    try {
      if (!await fileExists(path)) return null;
      File file = File(path);
      file.openRead();
      var contents = await file.readAsBytes();
       
      return contents;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /*  void startPlayer() async {
    if (!this._isDeleted) {
      if (this._isPlaying) {
        stopPlayer();
        return;
      }
      if (buffer == null) return;

      try {
        //String path = await flutterSound.startPlayer(this._path);

        String path = await flutterSound.startPlayerFromBuffer(buffer);
        await flutterSound.setVolume(1.0);
        print('startPlayer: $path');

        _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
          if (e != null) {
            maxDuration = e.duration;
            DateTime date = new DateTime.fromMillisecondsSinceEpoch(
                e.currentPosition.toInt(),
                isUtc: true);
            String txt = DateFormat('mm:ss').format(date);
            this.setState(() {
              this._isPlaying = true;
              this._playerTxt = txt;
            });
          }
        });
        _playerSubscription.onDone(() {
          this.setState(() {
            this._isPlaying = false;
          });
        });
      } catch (err) {
        print('error: $err');
      }
    }
  }
 */
  void pausePlayer() async {
    String result = await flutterSound.pausePlayer();
    print('pausePlayer: $result');
  }

  void resumePlayer() async {
    String result = await flutterSound.resumePlayer();
    print('resumePlayer: $result');
  }

  /* void stopPlayer() async {
    try {
      String result = await flutterSound.stopPlayer();
      if (_playerSubscription != null) {
        _playerSubscription.cancel();
        _playerSubscription = null;
      }
      this.setState(() {
        this._isPlaying = false;
      });
      print('stopPlayer: $result');
    } catch (e) {}
  } */

  void deleteRecord() {
    setState(() {
      this._playerTxt = "00:00";
      this._recorderTxt = "00:00";
      this._isDeleted = true;
      this._isRecorded = false;
      this._isPlaying = false;
    });
    widget.onSelectionComplete("", 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: ColorData.renkYesil),
                  child: _isRecorded
                      ? InkWell(
                          child: Image.asset(
                            this._isPlaying
                                ? "assets/images/ic_voice.png"
                                : "assets/images/ic_play.png",
                            color: ColorData.renkLacivert,
                            height: 36,
                            width: 36,
                          ),
                          onTap: () {
                            startPlayer(this._path);
                          },
                        )
                      : InkWell(
                          child: Image.asset(
                            this._isRecording
                                ? "assets/images/ic_voice.png"
                                : "assets/images/ic_mic.png",
                            color: ColorData.renkLacivert,
                            height: 36,
                            width: 36,
                          ),
                          onTap: () {
                            if (!this._isRecording) {
                              return this._start();
                            }
                          },
                        ),
                ),
                SizedBox(
                  height: 8,
                ),
                _isRecording
                    ? InkWell(
                        child: Container(
                          child: Icon(Icons.stop),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorData.renkYesil),
                        ),
                        onTap: () { 
                          this._stop();
                        },
                      )
                    : Container(),
                _isRecording
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "DURDUR",
                          style: TextStyleData.boldLacivert,
                        ),
                      )
                    : _isRecorded
                        ? Text(
                            this._isPlaying ? this._playerTxt : "DİNLE",
                            style: TextStyleData.boldLacivert,
                          )
                        : Text(
                            this._isRecording ? this._recorderTxt : "KAYDET",
                            style: TextStyleData.boldLacivert,
                          ),
                _isRecording ? Text(this._recorderTxt) : Container(),
              ],
            ),
            SizedBox(
              width: 8,
            ),
            _isRecorded
                ? Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: ColorData.renkYesil),
                        child: InkWell(
                          child: Image.asset(
                            "assets/images/ic_delete.png",
                            color: ColorData.renkLacivert,
                            height: 36,
                            width: 36,
                          ),
                          onTap: () {
                            deleteRecord();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        this._isRecorded ? "SİL" : "",
                        style: TextStyleData.boldLacivert,
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
