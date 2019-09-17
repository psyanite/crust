import 'dart:math';

import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final List<Widget> images;
  final Widget left;
  final Widget callToAction;
  final bool centreDots;

  Carousel({Key key, this.images, this.left, this.callToAction, this.centreDots = false})
      : assert(images != null),
        super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  PageController _controller = PageController();

  @override
  dispose() {
    _controller.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(height: 5.0),
        Container(
          color: Burnt.imgPlaceholderColor,
          height: MediaQuery.of(context).size.width - 30.0,
          child: _gallery(),
        ),
        if (widget.callToAction != null) widget.callToAction,
        Container(height: 10.0),
        Container(
          padding: EdgeInsets.only(top: 6.0, bottom: 10.0),
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              widget.left != null ? widget.left : Container(),
              Dots(controller: _controller, itemCount: widget.images.length),
              if (widget.centreDots) Container()
            ],
          ),
        )
      ],
    );
  }

  Widget _gallery() {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Container(
          child: PageView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _controller,
            children: widget.images,
          ),
        ),
      ],
    );
  }
}

class Dots extends AnimatedWidget {
  final PageController controller;
  final int itemCount;

  Dots({this.controller, this.itemCount}) : super(listenable: controller);

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, _buildDot),
    );
  }

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double size = 6.0 * (1.0 + 0.1 * selectedness);
    Color color = selectedness > 0.5 ? Colors.orange[200] : Colors.orange[100];
    return Container(
      height: 20.0,
      width: 10.0,
      child: Center(
        child: Material(
          color: color,
          type: MaterialType.circle,
          child: Container(
            height: size,
          ),
        ),
      ),
    );
  }
}
