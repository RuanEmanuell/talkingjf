import 'dart:math';
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import "package:flame/game.dart";
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';



//Variaveis compartilhadas entre o widget do flame e do flutter
var foddacer="gemaplys";
var rng=Random();
int talking=0;

//Widget do Flutter, controla o icone dos personagens em cima e o botão
class TalkingScreen extends StatefulWidget{
  @override
  _TalkingScreen createState()=> _TalkingScreen();
}

 SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

class _TalkingScreen extends State<TalkingScreen>{

  void initState(){
    super.initState();
    Future.delayed(Duration(milliseconds: 10), (){
    setState((){
      foddacer="saiko";
    });
    _initSpeech();
    });
  }


  //Funções do text to speech
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
  }

  void _stopListening() async {
    await _speechToText.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
      if(result.recognizedWords!=""){
      startTalking();
      _stopListening();
      }

  }


  void grabCellphone() async{
    talking=1;
  }

  void startTalking() async{
    talking=2;

    if(rng.nextInt(2)==0){
    FlameAudio.bgm.play("sim$foddacer.mp3");
    }else{
      FlameAudio.bgm.play("nao$foddacer.mp3");
    }

    Future.delayed(Duration(milliseconds:1000), (){
      talking=0;
      FlameAudio.bgm.stop();
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        backgroundColor:Color.fromRGBO(97, 104, 223,1),
        elevation:0,
        actions:[
          //Colocando os botões em cima
          Expanded(
            child: ElevatedButton(
            child:Image.asset("assets/images/saiko.png"),
            onPressed:(){
              setState((){
                foddacer="saiko";
                talking=0;
                _stopListening();
              });
            }
           ),
          ),
         Expanded(
           child: ElevatedButton(
            child:Image.asset("assets/images/gemaplys.png"),
            onPressed:(){
              setState((){
                foddacer="gemaplys";
                talking=0;
                _stopListening();
              });
            }
           ),
         ),
         Expanded(
           child: ElevatedButton(
            child:Image.asset("assets/images/jean.png"),
            onPressed:(){
              setState((){
                foddacer="jean";
                talking=0;
                _stopListening();
              });
            }
          ),
         ),
        ]
      ),
      //Colocando o jogo em si(código abaixo)
      body:GameWidget(game: TalkingGame()),
      //Colocando o botão de ligar
      floatingActionButton:Container(
      width:100,
      height:100,
      child:FloatingActionButton(
        backgroundColor: Colors.green,
        child:Icon(Icons.call, size:50),
        onPressed:(){
          _startListening();
          grabCellphone();
        }
      ),
      )
      
    );
  }
}


class TalkingGame extends FlameGame {
  
  late SpriteAnimation idleAnimation;
  late SpriteAnimation cellphoneAnimation;
  late SpriteAnimation talkingAnimation;

  late SpriteAnimationComponent character;

  double characterSize=450;

  @override
  Future<void> onLoad() async{
    await super.onLoad();

    //Pegando a largura e altura da tela, respectivamente
    var screenWidth=size[0];
    var screenHeight=size[1];

    final spriteSheet=SpriteSheet(image:await images.load("${foddacer}animation.png"), srcSize:Vector2(650,1100));

    //Definindo as animações do personagem parado, falando e com o telefone
    idleAnimation=spriteSheet.createAnimation(row: 0,stepTime:1, to:1);
    talkingAnimation=spriteSheet.createAnimation(row: 1, stepTime:.4, to:2);
    cellphoneAnimation=spriteSheet.createAnimation(row: 1, stepTime:5, to:1);

  
    //Carregando o personagem
    character=SpriteAnimationComponent()
    ..animation=cellphoneAnimation
    ..size=Vector2(screenWidth, screenHeight);

    add(character);

  }


  @override
  void update(double dt){
    super.update(dt);

    if(talking==0){
      character.animation=idleAnimation;
    }
    if(talking==1){
      character.animation=cellphoneAnimation;
    }
    if(talking==2){
      character.animation=talkingAnimation;
    }
    
  }

  
}

