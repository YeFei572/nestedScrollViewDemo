import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
  if (Platform.isAndroid) {
    /// 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //这个是状态栏的颜色根据自己的需要自己更改
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool shown = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController(keepScrollOffset: false);
    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && shown == false) {
        setState(() => shown = true);
      }
      if (_scrollController.offset < 200) {
        setState(() => shown = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: shown,
        child: FloatingActionButton(
          mini: true,
          backgroundColor: Colors.blue[300],
          child: const Icon(Icons.vertical_align_top),
          onPressed: () {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
            );
          },
        ),
      ),
      body: NestedScrollView(
        controller: _scrollController,
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildContent(),
            _buildContent(),
          ],
        ),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  'assets/images/img.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
              floating: true,
              bottom: TabBar(
                controller: _tabController,
                tabs: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text('节假日'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text('工作日'),
                  ),
                ],
              ),
            )
          ];
        },
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          100,
          (index) => Container(
            decoration: BoxDecoration(
              color: Colors.primaries[index % Colors.primaries.length],
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(20),
            height: 100,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
