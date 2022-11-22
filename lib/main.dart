import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:demo04/prod_custom_sliver.dart';
import 'package:demo04/title_sliver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) async => buildAlertDialog(context));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
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
            _buildContent(context),
            _buildContent(context),
          ],
        ),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            buildSliverAppBar(),
          ];
        },
      ),
    );
  }

  SliverAppBar buildSliverAppBar() {
    return SliverAppBar(
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
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          100,
          (index) => InkWell(
            onTap: () => buildAlertDialog(context),
            child: Container(
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
      ),
    );
  }

  buildAlertDialog(BuildContext context) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: '更新提示',
      message:
          '1、万物更新，旧疾当愈，往事清零，爱恨随意，常安，长安。\n2、媳妇更新了她的签名：我愿用身上的10斤肉换取母亲的1年的寿命。然后岳母大人在后面评论：闺女，你妈我还不想变成千年老妖……\n3、人若是更新不了自己，只能在“旧”和“重复”之中迷惑。',
      okLabel: '确认更新',
      cancelLabel: '稍后再说',
      barrierDismissible: false,
      useActionSheetForIOS: true,
    );
    if (result == OkCancelResult.ok && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('同意更新')));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const TitleSliver()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('稍后更新')));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const ProdCustomSliver()));
    }

    print('-----$result');
  }
}
