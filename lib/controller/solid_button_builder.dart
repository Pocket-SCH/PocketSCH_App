import 'package:flutter/material.dart';

class SolidButtonBuilder extends StatefulWidget {
  final String text;
  final Color color;
  final Color shadowcolor;
  final double hegiht;
  final double shadowheight;
  final double width;
  final TextStyle? textstyle;
  final double position;
  final VoidCallback onPressed;

  SolidButtonBuilder(
      {Key? key,
      this.text = '',
      this.color = Colors.blue,
      this.shadowcolor = Colors.black,
      this.hegiht = 64,
      this.shadowheight = 4,
      this.width = 200,
      this.textstyle,
      this.position = 4,
      required this.onPressed})
      : super(key: key);

  @override
  State<SolidButtonBuilder> createState() => _SolidButtonBuilderState(
      text,
      color,
      shadowcolor,
      hegiht,
      shadowheight,
      width,
      textstyle,
      position,
      onPressed);
}

class _SolidButtonBuilderState extends State<SolidButtonBuilder> {
  double _initPosition = 4;
  late final double _position;
  late final String _text;
  late final Color _color;
  late final Color _shadowColor;
  late final double _height;
  late final double _shadowHeight;
  late final double _width;
  late final TextStyle _textStyle;
  late final VoidCallback _onPressed;

  _SolidButtonBuilderState(
      String text,
      Color color,
      Color shadowcolor,
      double height,
      double shadowheight,
      double width,
      TextStyle? textstyle,
      double position,
      VoidCallback onPressed) {
    this._text = text;
    this._color = color;
    this._shadowColor = shadowcolor;
    this._height = height;
    this._shadowHeight = shadowheight;
    this._width = width;
    this._textStyle = textstyle ??
        TextStyle(
          color: Colors.white,
          fontSize: 22,
        );
    this._position = position;
    this._initPosition = position;
    this._onPressed = onPressed;
  }

  @override
  Widget build(BuildContext context) {
    double _height = this._height - _shadowHeight;
    return GestureDetector(
      onTapUp: (_) {
        setState(() {
          _initPosition = _position;
        });
      },
      onTapDown: (_) {
        setState(() {
          _initPosition = 0;
        });
        _onPressed.call();
      },
      onTapCancel: () {
        setState(() {
          _initPosition = _position;
        });
      },
      // 버튼 아래 그림자 부분
      child: Container(
        height: _height + _shadowHeight,
        width: _width,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                height: _height,
                width: _width,
                decoration: BoxDecoration(
                  color: _shadowColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
              ),
            ),
            // 실제 버튼 부분
            AnimatedPositioned(
              curve: Curves.easeIn,
              bottom: _initPosition,
              duration: Duration(milliseconds: 70),
              child: Container(
                height: _height,
                width: _width,
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Text(
                    _text,
                    style: _textStyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
