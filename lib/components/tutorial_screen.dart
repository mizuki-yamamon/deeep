import 'package:flutter/material.dart';

class TutorialScreen extends StatefulWidget {
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  List<SliderModel>? mySLides;
  int slideIndex = 0;
  PageController controller =
      PageController(initialPage: 1, viewportFraction: 0.8);

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mySLides = firstSlides();
    controller = new PageController(initialPage: 0, viewportFraction: 1);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [const Color(0xff3C8CE7), const Color(0xff00EAFF)])),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            height: MediaQuery.of(context).size.height - 55,
            child: PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  slideIndex = index;
                });
              },
              children: <Widget>[
                SlideTile(
                  imagePath: mySLides![0].getImageAssetPath(),
                  title: mySLides![0].getTitle(),
                  desc: mySLides![0].getDesc(),
                ),
                SlideTile(
                  imagePath: mySLides![1].getImageAssetPath(),
                  title: mySLides![1].getTitle(),
                  desc: mySLides![1].getDesc(),
                ),
                SlideTile(
                  imagePath: mySLides![2].getImageAssetPath(),
                  title: mySLides![2].getTitle(),
                  desc: mySLides![2].getDesc(),
                ),
                SlideTile(
                  imagePath: mySLides![3].getImageAssetPath(),
                  title: mySLides![3].getTitle(),
                  desc: mySLides![3].getDesc(),
                )
              ],
            ),
          ),
          bottomSheet: slideIndex != 3
              ? Container(
                  width: width,
                  height: 55,
                  // margin: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          controller.animateToPage(3,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.linear);
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.blue[50],
                        ),
                        child: Text(
                          "SKIP",
                          style: TextStyle(
                              color: Color(0xFF0074E4),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            for (int i = 0; i < 4; i++)
                              i == slideIndex
                                  ? _buildPageIndicator(true)
                                  : _buildPageIndicator(false),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          print("this is slideIndex: $slideIndex");
                          controller.animateToPage(slideIndex + 1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.linear);
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.blue[50],
                        ),
                        child: Text(
                          "NEXT",
                          style: TextStyle(
                              color: Color(0xFF0074E4),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  width: width,
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: ElevatedButton(
                      child: Text(
                        "早速はじめる！",
                        style: TextStyle(
                          fontFamily: 'font_1_honokamarugo_1.1',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          //fontSize: 10
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.black,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        print("早速はじめる！");
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  //元に戻れないようにする
  Future<bool> _willPopCallback() async {
    return true;
  }
}

class SlideTile extends StatelessWidget {
  String? imagePath, title, desc;

  SlideTile({this.imagePath, this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
                height: height * 0.64,
                child: imagePath!.length < 50
                    ? Image.asset(imagePath!)
                    : Image.network(imagePath!)),
            SizedBox(
              height: 10,
            ),
            Text(
              title!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'font_1_honokamarugo_1.1',
                  fontSize: 20),
            ),
            Text(desc!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    fontFamily: 'font_1_honokamarugo_1.1',
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

//data
class SliderModel {
  String? imageAssetPath;
  String? title;
  String? desc;

  SliderModel({this.imageAssetPath, this.title, this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath!;
  }

  String getTitle() {
    return title!;
  }

  String getDesc() {
    return desc!;
  }
}

List<SliderModel> firstSlides() {
  List<SliderModel> slides = [];
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc(
      "こちらのアプリはセルごとにアイデアを格納し、立体的にアイデアや思考を整理することのできるノートアプリです。＋ボタンで新しいセルを誕生させることができます。タップで表示・編集、ダブルタップでそのセルを元にした次のセルへ移動することができます。");
  sliderModel.setTitle("「Deeep」使用方法");
  sliderModel.setImageAssetPath("assets/tutorial-1.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc(
      "ノートの配置構造として「レイヤー型」「マンダラ型」の二種類を用意しております。そのセルが親になった（ダブルタップされた）時のみ、その構造が有効になります。構造の具体的な説明は次のページで確認出来ます。");
  sliderModel.setTitle("編集画面");
  sliderModel.setImageAssetPath("assets/tutorial-2.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc(
      "親セル(ダブルタップしたセル)を中心に曼荼羅模様のようなマス目を作り、そのマス目一つ一つにアイデアを書き込むことで、アイデアの整理や拡大などを図り、思考を深めることができます。長押しで自由に配置を変えることもできます。");
  sliderModel.setTitle("マンダラ型");
  sliderModel.setImageAssetPath("assets/tutorial-3.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc(
      "親セル(ダブルタップしたセル)が最初に配置され、親セルを元にしたセルを好きな数だけ生成できる構造タイプです。こちらも長押しで自由に配置を変えることもできます。");
  sliderModel.setTitle("レイヤー型");
  sliderModel.setImageAssetPath("assets/tutorial-4.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
