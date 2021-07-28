import 'package:flutter/material.dart';

import 'ball.dart';
import 'bat.dart';
import 'dart:math';

enum Direction {
  up,
  down,
  left,
  right,
}

class Pong extends StatefulWidget {
  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  double width = 0;
  double height = 0;
  double posX = 0;
  double posY = 0;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;
  late Animation<double> animation;
  late AnimationController controller;
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  double increment = 3;
  double randX = 1;
  double randY = 1;
  int score = 0;

  double randomNumber() {
    var ran = new Random();
    int myNum = ran.nextInt(101);
    return (50 + myNum) / 100;
  }

  @override
  void initState() {
    super.initState();
    posX = 0;
    posY = 0;

    controller = AnimationController(
      duration: const Duration(minutes: 10000),
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation.addListener(() {
      safeSetState(() {
        (hDir == Direction.right)
            ? posX += ((increment * randX).round())
            : posX -= ((increment * randX).round());
        (vDir == Direction.down)
            ? posY += ((increment * randY).round())
            : posY -= ((increment * randY).round());
      });
      checkBorders();
    });
    controller.forward();
  }

  void checkBorders() {
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if (posX >= width - 50 && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }
    if (posY >= height - 50 - batHeight && vDir == Direction.down) {
      if (posX >= (batPosition - 50) && posX <= (batPosition + batWidth + 50)) {
        vDir = Direction.up;
        randY = randomNumber();
        setState(() {
          score++;
        });
      } else {
        controller.stop();
        showMessage(context);
      }
    }
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randY = randomNumber();
    }
  }

  void moveBat(DragUpdateDetails update, BuildContext context) {
    safeSetState(() {
      batPosition += update.delta.dx;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void showMessage(BuildContext context){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Game Over'),
        content: Text('Would you like to play again ?'),
        actions: [
          FlatButton(onPressed: (){
            setState(() {
              posX = 0;
              posY = 0;
              score = 0;
            });
            Navigator.of(context).pop();
            controller.repeat();
          }, 
          child: Text('Yes'),
          ),
          FlatButton(onPressed: (){
            Navigator.of(context).pop();
            dispose();
          },
           child: Text('No'),
           ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      height = constraints.maxHeight;
      width = constraints.maxWidth;
      batWidth = width / 5;
      batHeight = height / 20;

      return Stack(
        children: [
          Positioned(
            child: Text('Score: ' + score.toString()),
            top: 0,
            right: 24,
          ),
          Positioned(
            child: Ball(),
            top: posY,
            left: posX,
          ),
          Positioned(
            bottom: 0,
            left: batPosition,
            child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails update) =>
                    moveBat(update, context),
                child: Bat(batWidth, batHeight)),
          ),
        ],
      );
    });
  }

  void safeSetState(Function function) {
    if (mounted && controller.isAnimating) {
      setState(() {
        function();
      });
    }
  }
}
