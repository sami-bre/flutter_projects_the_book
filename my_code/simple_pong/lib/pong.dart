import 'package:flutter/material.dart';
import 'dart:math';

import 'package:simple_pong/ball.dart';
import 'package:simple_pong/bat.dart';

enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  const Pong({Key? key}) : super(key: key);

  @override
  State<Pong> createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  int score = 0;
  late double width;
  late double height;
  double posX = 0;
  double posY = 0;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;
  double increment = 5;
  double randX = 1;
  double randY = 1;
  Direction vDir = Direction.down;
  Direction hDir = Direction.left;
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    posX = 0;
    posY = 0;
    controller = AnimationController(
      duration: const Duration(minutes: 100000),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation.addListener(() {
      safeSetState(() {
        hDir == Direction.right
            ? posX += (increment * randX)
            : posX -= (increment * randX);
        vDir == Direction.down
            ? posY += (increment * randY)
            : posY -= (increment * randY);
        checkBorders();
      });
    });
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        width = constraints.maxWidth;
        height = constraints.maxHeight;
        batWidth = width / 5;
        batHeight = height / 20;

        return Stack(
          children: <Widget>[
            Positioned(
              top: posY,
              left: posX,
              child: const Ball(),
            ),
            Positioned(
              bottom: 0,
              left: batPosition,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) => moveBat(details),
                child: Bat(batWidth, batHeight),
              ),
            ),
            Positioned(
              top: 0,
              right: 24,
              child: Text('Score: $score'),
            )
          ],
        );
      },
    );
  }

  void checkBorders() {
    double ballDiameter = 50;
    // at each bounce, we change the directiona and the random factor
    // on the increment value. (which are randX and randY)
    if (posX <= 0 && hDir == Direction.left) {
      randX = randomNumber();
      hDir = Direction.right;
    }
    if (posX >= width - ballDiameter && hDir == Direction.right) {
      randX = randomNumber();
      hDir = Direction.left;
    }
    if (posY <= 0 && vDir == Direction.up) {
      randY = randomNumber();
      vDir = Direction.down;
    }
    if (posY >= height - ballDiameter - batHeight && vDir == Direction.down) {
      // check if the bat is here. otherwise, loose
      if (posX >= (batPosition - ballDiameter) &&
          posX <= batPosition + batWidth + ballDiameter) {
        // bounce up
        randY = randomNumber();
        vDir = Direction.up;
        setState(() {
          score++;
        });
      } else {
        controller.stop();
        showMessage();
      }
    }
  }

  void moveBat(DragUpdateDetails details) {
    safeSetState(() {
      batPosition += details.delta.dx;
    });
  }

  void safeSetState(Function function) {
    if (mounted && controller.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  double randomNumber() {
    // this is a number between 0.0 and 1.5
    int rand = Random().nextInt(101);
    return (50 + rand) / 100;
  }

  void showMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: const Text('Would you like to play again?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  score = 0;
                  posX = posY = 0;
                });
                Navigator.pop(context);
                controller.repeat();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                dispose();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
