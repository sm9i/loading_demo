import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class Loading extends StatelessWidget {
  Loading({
    Key key,
    @required this.value,
    double itemSize = 15,
    double itemSpace = 10,
    int itemCount = 5,
    this.leftColor = Colors.green,
    this.rightColor = Colors.red,
  })  : this.itemSize = itemSize,
        this.itemSpace = itemSpace,
        this.itemCount = itemCount,
        this.width = (itemSpace + itemSize) * itemCount - itemSpace,
        this.height = itemSize + itemSize + itemSpace,
        super(key: key);

  final double itemSize;

  final double itemSpace;

  final int itemCount;

  final double width;

  final double height;

  final Color leftColor;

  final Color rightColor;

  final double value;

  Widget _buildItem(int index) {
    double left = 0, top = itemSize + itemSpace;
    bool ltr = value <= 0.5;
    double disLeft;
    if (ltr) {
      disLeft = value * 2;
    } else {
      disLeft = (1 - value) * 2;
    }

    if (index == 0) {
      left = (width - itemSize) * disLeft;
      return Positioned(
        left: left,
        top: top,
        child: _buildCell(left),
      );
    }
    double splitTime = 1 / (itemCount - 1);

    double distance = disLeft - (index - 1) * splitTime;
    if (distance < 0 && ltr) {
      left = (itemSize + itemSpace) * index;
      return Positioned(
        left: left,
        top: top,
        child: _buildCell(left),
      );
    } else if (distance < 0) {
      double scale =
          (16 / 5 * distance * (4 * distance + 1) + 1).clamp(0.8, 1.0);
      left = (itemSize + itemSpace) * index;
      return Positioned(
        left: left,
        top: top,
        child: Transform(
          transform: Matrix4.diagonal3Values(1 / scale, scale, 1.0),
          alignment: Alignment.bottomCenter,
          child: _buildCell(left),
        ),
      );
    }
    distance = disLeft - index * splitTime;
    if (distance > 0 && !ltr) {
      left = (itemSize + itemSpace) * (index - 1);
      return Positioned(
        left: left,
        top: top,
        child: _buildCell(left),
      );
    } else if (distance > 0) {
      double scale =
          (16 / 5 * distance * (4 * distance - 1) + 1).clamp(0.8, 1.0);
      left = (itemSize + itemSpace) * (index - 1);
      return Positioned(
        left: left,
        top: top,
        child: Transform(
          transform: Matrix4.diagonal3Values(1 / scale, scale, 1.0),
          alignment: Alignment.bottomCenter,
          child: _buildCell(left),
        ),
      );
    }
    left = (-1 * (itemSize + itemSpace)) /
            splitTime *
            (disLeft - ((index - 1) * splitTime)) +
        (itemSize + itemSpace) * index;
    double v = (disLeft - ((index - 1) * splitTime)) / splitTime;
    double t = (itemSize + itemSpace);
    top = t * (4 * v * (v - 1) + 1);
    return Positioned(
      left: left,
      top: top,
      child: Transform.rotate(
        angle: -math.pi * v,
        child: _buildCell(left),
      ),
    );
  }

  Widget _buildCell(double left) {
    return Container(
      width: itemSize,
      height: itemSize,
      decoration: BoxDecoration(
        color: Color.lerp(leftColor, rightColor, left / (width - itemSize)),
        borderRadius: BorderRadius.all(Radius.circular(itemSize / 5)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Stack(children: List.generate(itemCount, _buildItem)),
    );
  }
}
