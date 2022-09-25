import 'dart:math';
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import "package:flame/game.dart";


class TalkingScreen extends StatefulWidget{
  @override
  _TalkingScreen createState()=> _TalkingScreen();
}


class _TalkingScreen extends State<TalkingScreen>{


  void initState(){
    super.initState();
  }

  



  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        backgroundColor:Color.fromRGBO(97, 104, 223,1),
        elevation:0,
        actions:[
          Expanded(
            child: ElevatedButton(
            child:Image.asset("assets/images/saiko.png"),
            onPressed:(){
              setState((){
                foddacer="saiko";
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
              });
            }
                 ),
         ),

        ]
      ),
      body:GameWidget(game: TalkingGame())
    );
  }
}


var foddacer="gemaplys";

var rng=Random();

int talking=0;


   void grabCellphone() async{
    talking=1;
  }

  void startTalking() async{
    talking=2;

    if(rng.nextInt(2)==0){
    FlameAudio.bgm.play("sim${foddacer}.mp3");
    }else{
      FlameAudio.bgm.play("nao${foddacer}.mp3");
    }

    Future.delayed(Duration(milliseconds:750), (){
      talking=0;
      FlameAudio.bgm.stop();
    });
  }


class TalkingGame extends FlameGame with HasTappables{
  
  late SpriteAnimation idleAnimation;
  late SpriteAnimation cellphoneAnimation;
  late SpriteAnimation talkingAnimation;
  late Button button=Button();

  late SpriteAnimationComponent gemaplys;
  late SpriteComponent background;

  double gemaplysSize=450;

  @override
  Future<void> onLoad() async{
    await super.onLoad();

    //Loading sprites and the music

    final screenWidth=size[0];
    final screenHeight=size[1];


    final spriteSheet=SpriteSheet(image:await images.load("${foddacer}animation.png"), srcSize:Vector2(650,1100));

    idleAnimation=spriteSheet.createAnimation(row: 0,stepTime:1, to:1);
    talkingAnimation=spriteSheet.createAnimation(row: 1, stepTime:.4, to:2);
    cellphoneAnimation=spriteSheet.createAnimation(row: 1, stepTime:.4, to:1);

  
    gemaplys=SpriteAnimationComponent()
    ..animation=cellphoneAnimation
    ..size=size;

    add(gemaplys);

    button=Button()
    ..sprite=await loadSprite("button.webp")
    ..size=Vector2(80, 80)
    ..position=Vector2(screenWidth-100, screenHeight-100);

    add(button);

  }


  @override
  void update(double dt){
    super.update(dt);

    if(talking==0){
      gemaplys.animation=idleAnimation;
    }
    if(talking==1){
      gemaplys.animation=cellphoneAnimation;
    }
    if(talking==2){
      gemaplys.animation=talkingAnimation;
    }
    
  }



  
}


class Button extends SpriteComponent with Tappable{
  @override
  onTapDown(TapDownInfo event){
    try{
      grabCellphone();
      Future.delayed(Duration(seconds: rng.nextInt(6)+2), (){
        startTalking();
      });
    }catch(error){
      print(error);
    }
    return false;
  }
}
