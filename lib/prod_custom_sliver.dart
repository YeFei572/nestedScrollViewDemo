import 'package:flutter/material.dart';

class ProdCustomSliver extends StatefulWidget {
  const ProdCustomSliver({Key? key}) : super(key: key);

  @override
  State<ProdCustomSliver> createState() => _ProdCustomSliverState();
}

class _ProdCustomSliverState extends State<ProdCustomSliver> {
  ///定义滑动监听类
  late ScrollController scrollController;

  ///false 代表没折叠  true代表折叠
  bool silverCollapsed = false;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {
      ///130 这个值根据下面的expandedHeight值自己调整 看效果可以就行
      if (scrollController.offset >= 130) {
        silverCollapsed = true;
      } else {
        silverCollapsed = false;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///RefreshIndicator 控制下拉刷新功能
      body: RefreshIndicator(
        ///转动箭头颜色
        color: Colors.red,

        ///背景颜色
        backgroundColor: Colors.lightBlue,
        onRefresh: () async {
          setState(() {
            /// 下拉刷新回调
          });
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,

              ///这个是高度
              expandedHeight: 200.0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(silverCollapsed ? '商品详情' : ''),
                background: Image.asset(
                  'assets/images/img.png',
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  height: 60,
                  color: Colors.primaries[index % Colors.primaries.length],
                );
              }, childCount: 30),
            )
          ],
        ),
      ),
    );
  }
}
