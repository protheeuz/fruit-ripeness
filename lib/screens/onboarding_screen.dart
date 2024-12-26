import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onDone() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _onDone,
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  itemCount: demoData.length,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) => OnBoardContent(
                    animation: demoData[index].animation,
                    title: demoData[index].title,
                    description: demoData[index].description,
                    isLast: index == demoData.length - 1,
                  ),
                ),
              ),
              Row(
                children: [
                  ...List.generate(
                    demoData.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: DotIndicator(
                        isActive: index == _pageIndex,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 55,
                    width: 55,
                    child: InkWell(
                      onTap: () {
                        if (_pageIndex == demoData.length - 1) {
                          _onDone();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [Colors.green, Colors.lightGreen],
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isActive ? 12 : 4,
      width: 4,
      decoration: BoxDecoration(
        color: isActive
            ? Colors.greenAccent
            : Colors.greenAccent.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}

class OnBoard {
  final String animation, title, description;
  final bool isLast;

  OnBoard({
    required this.animation,
    required this.title,
    required this.description,
    this.isLast = false,
  });
}

final List<OnBoard> demoData = [
  OnBoard(
    animation: "assets/animations/animation1.json",
    title: "Hi, check your fruit ripeness\nusing our app",
    description:
        "Upload a picture and let our AI analyze your fruit ripeness!",
  ),
  OnBoard(
    animation: "assets/animations/animation2.json",
    title: "You can check \nevery fruit quality",
    description:
        "Simply upload a picture, and our system will identify fruit quality.",
  ),
  OnBoard(
    animation: "assets/animations/animation3.json",
    title: "Using AI Technology",
    description:
        "Our system leverages machine learning for accurate fruit ripeness detection.",
  ),
  OnBoard(
    animation: "",
    title: "Fruit Ripeness Classification",
    description:
        "Simply upload a picture, and let our system provide the best analysis to ensure your fruit is ready to eat or sell!",
  ),
];

class OnBoardContent extends StatelessWidget {
  const OnBoardContent({
    super.key,
    required this.animation,
    required this.title,
    required this.description,
    this.isLast = false,
  });

  final String animation, title, description;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isLast)
          Lottie.asset(
            animation,
            height: 280,
            width: 200,
          ),
        if (isLast)
          Image.asset(
            'assets/images/fruit_basket.png',
            height: 280,
            width: 200,
          ),
        const SizedBox(height: 50),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
          ),
        ),
        const SizedBox(height: 25),
        if (isLast)
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(
                  horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'GET STARTED',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
      ],
    );
  }
}