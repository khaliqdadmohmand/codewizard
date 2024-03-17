import 'package:flutter/material.dart';
import 'package:code_wizard/constants/app_colors.dart';
import 'package:code_wizard/screens/create/create_screen.dart';
import 'package:code_wizard/screens/home_screen.dart';
import 'package:code_wizard/screens/learn/tutorial_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'utils/ads_util.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static const dummyAvatarUrl =
      'https://st2.depositphotos.com/2703645/5669/v/950/depositphotos_56695433-stock-illustration-female-avatar.jpg';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  /// widget list
  final List<Widget> bottomBarPages = [
    HomeScreen(),
    CreateScreen(),
    TutorialScreen(),
  ];

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _bodyView = <Widget>[
    HomeScreen(),
    CreateScreen(),
    TutorialScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late TabController _tabController;
  AdsUtil adsUtil = AdsUtil();

  @override
  void initState() {
    adsUtil.createInterstitialAd();
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  Widget _tabItem(Widget child, String label, {bool isSelected = false}) {
    return AnimatedContainer(
        margin: EdgeInsets.all(8),
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 500),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            child,
            Text(label, style: TextStyle(fontSize: 8)),
          ],
        ));
  }

  final List<String> _labels = ['Home', 'Create', 'Learn'];

  List<Widget> _icons = const [
    Icon(Icons.home_outlined),
    Icon(Icons.qr_code),
    Icon(Icons.school)
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Origin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: AppColors.primaryWhiteColor,
          canvasColor: const Color(0xFFCADCF8),
          backgroundColor: AppColors.primaryWhiteColor,
          textTheme: TextTheme(
              headline1: TextStyle(
                  color: AppColors.headerTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
              headline2:
                  TextStyle(color: AppColors.headerTextColor, fontSize: 24),
              headline3: TextStyle(
                  color: AppColors.primaryWhiteColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold)),
          appBarTheme: AppBarTheme(
              backgroundColor: const Color(0xFFCADCF8), elevation: 0)),
      darkTheme: ThemeData(
          primaryColor: AppColors.darkModeBackground,
          canvasColor: AppColors.darkModeBackground,
          backgroundColor: Colors.red,
          textTheme: TextTheme(
              headline1: TextStyle(
                  color: AppColors.primaryWhiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
              headline2:
                  TextStyle(color: AppColors.primaryWhiteColor, fontSize: 24),
              headline3: TextStyle(
                  color: AppColors.primaryWhiteColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold)),
          appBarTheme: AppBarTheme(
              backgroundColor: AppColors.darkModeBackground, elevation: 0)),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Scan QR & Products',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: AppColors.headerTextColor),
          ),
          actions: [
            GestureDetector(
              onTap: adsUtil.showInterstitialAd(() {}),
              child: CircleAvatar(
                backgroundImage: NetworkImage(MyApp.dummyAvatarUrl),
                radius: 24,
              ),
            ),
            SizedBox(width: 24)
          ],
        ),
        body: Center(
          child: _bodyView.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          height: 100,
          padding: const EdgeInsets.all(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Container(
              color: Colors.teal.withOpacity(0.1),
              child: TabBar(
                  onTap: (x) {
                    setState(() {
                      _selectedIndex = x;
                      if (_selectedIndex != 0) {
                        adsUtil.showInterstitialAd(() {});
                      }
                    });
                  },
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.blueGrey,
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide.none,
                  ),
                  tabs: [
                    for (int i = 0; i < _icons.length; i++)
                      _tabItem(
                        _icons[i],
                        _labels[i],
                        isSelected: i == _selectedIndex,
                      ),
                  ],
                  controller: _tabController),
            ),
          ),
        ),
      ),
    );
  }
}
