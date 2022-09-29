import 'package:flutter/material.dart';

class BackToTop extends StatefulWidget {
  final ScrollController controller;
  final double bottom;

  const BackToTop({Key? key, required this.controller, required this.bottom})
      : super(key: key);

  @override
  State<BackToTop> createState() => _BackToTopState();
}

class _BackToTopState extends State<BackToTop> {
  bool shown = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(isScroll);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(isScroll);
  }

  void isScroll() {
    final bool toShow =
        widget.controller.offset > MediaQuery.of(context).size.height / 2;
    if (toShow ^ shown) {
      setState(() => shown = toShow);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + (widget.bottom),
      right: 20,
      child: Offstage(
        offstage: !shown,
        child: GestureDetector(
          onTap: () => widget.controller.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          ),
          child: Container(
            height: 40,
            width: 40,
            alignment: const Alignment(0, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.1),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: const Icon(
                    Icons.vertical_align_top,
                    size: 20,
                    color: Colors.black38,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 0),
                  child: const Text(
                    'Top',
                    style: TextStyle(fontSize: 10, color: Color(0xFFA1A6AA)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
