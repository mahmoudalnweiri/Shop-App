import 'package:flutter/material.dart';
import 'package:shop/modules/login/login_screen.dart';
import 'package:shop/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/images/onBoarding1.png',
      title: 'Title 1',
      body: 'Body Screen 1',
    ),
    BoardingModel(
      image: 'assets/images/onBoarding2.png',
      title: 'Title 2',
      body: 'Body Screen 2',
    ),
    BoardingModel(
      image: 'assets/images/onBoarding3.png',
      title: 'Title 3',
      body: 'Body Screen 3',
    ),
  ];

  bool isLast = false;

  void submit(){
    CacheHelper.setData(key: 'onBoarding', value: true).then((value){
      if(value){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: submit,
            child: const Text(
              'SKIP',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: boardController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemCount: boarding.length,
                itemBuilder: (context, index) {
                  return buildBoardingItem(boarding[index]);
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // بياخذ كونترولر عشان يكون عارف هو تابع لمين وياخذ الـ index الحالي منه
                SmoothPageIndicator(
                  controller: boardController,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Theme.of(context).primaryColor,
                    dotHeight: 10.0,
                    expansionFactor: 3.0,
                    dotWidth: 10.0,
                    spacing: 5,
                  ),
                  count: boarding.length,
                ),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      submit();
                    } else {
                      boardController.nextPage(
                        duration: const Duration(milliseconds: 750),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 32,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Column buildBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: AssetImage(model.image),
            ),
          ),
          Text(
            model.title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            model.body,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ],
      );
}
