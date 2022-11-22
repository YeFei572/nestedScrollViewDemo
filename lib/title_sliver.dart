import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TitleSliver extends StatefulWidget {
  const TitleSliver({Key? key}) : super(key: key);

  @override
  State<TitleSliver> createState() => _TitleSliverState();
}

class _TitleSliverState extends State<TitleSliver> {
  late ScrollController _scrollController;
  bool showTitle = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > 130 && !showTitle) {
        debugPrint('显示了');
        setState(() => showTitle = true);
      }
      if (_scrollController.offset < 130 && showTitle) {
        debugPrint('消失了');
        setState(() => showTitle = false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [_buildSliverAppBar()];
        },
        controller: _scrollController,
        body: SingleChildScrollView(
          child: Column(
            children: List.generate(
              100,
              (index) => Container(
                decoration: BoxDecoration(
                  color: Colors.primaries[index % Colors.primaries.length],
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.all(20),
                height: 80,
                width: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildSliverAppBar() {
    return SliverAppBar(
      title: Visibility(
        visible: showTitle,
        child: const Text('测试标题'),
      ),
      centerTitle: true,
      pinned: true,
      floating: false,
      snap: false,
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          'assets/images/img.png',
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
