import 'package:code_wizard/utils/ads_util.dart';
import 'package:code_wizard/widgets/banner_ad.dart';
import 'package:code_wizard/widgets/native_ad.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:code_wizard/constants/app_colors.dart';
import 'package:code_wizard/models/spending_category_model.dart';
import 'package:code_wizard/screens/scanner/scanner_screen.dart';
import 'package:code_wizard/widgets/price_text.dart';
import 'package:code_wizard/widgets/spending_category.dart';

class HomeScreen extends StatefulWidget {
  static const categoryModels = [
    SpendingCategoryModel(
      'GROCERIES',
      'assets/image1.png',
      28,
      AppColors.categoryColor1,
    ),
    SpendingCategoryModel(
      'FOOD',
      'assets/image2.png',
      28,
      AppColors.categoryColor2,
    ),
    SpendingCategoryModel(
      'BEAUTY',
      'assets/image3.png',
      28,
      AppColors.categoryColor3,
    ),
    SpendingCategoryModel(
      'OTHERS',
      'assets/image4.png',
      28,
      AppColors.secondaryAccent,
    ),
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AdsUtil adsUtil = AdsUtil();
  @override
  void initState() {
    adsUtil.createInterstitialAd();
    super.initState();
  }

  Future scanBarcode() async {
    try {
      await FlutterBarcodeScanner.scanBarcode(
              "#ff6666", "Cancel", true, ScanMode.BARCODE)
          .then((result) => {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ScannerScreen(
                              result: result,
                            )))
                // print(result)
              });
    } on PlatformException {
      print("Failed to get platform version");
    }
    if (!mounted) return;
  }

  @override
  void dispose() {
    AdsUtil().interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Container(
            height: 80,
            child: Stack(children: [
              Container(
                  color: Theme.of(context).canvasColor,
                  height: 50,
                  padding: EdgeInsets.only(left: 36, top: 5),
                  width: double.infinity,
                  child: Container()),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Supports \nall upto',
                              style:
                                  TextStyle(color: AppColors.primaryWhiteColor),
                            ),
                            SizedBox(width: 32),
                            PriceText(
                              price: 100,
                              color: AppColors.primaryWhiteColor,
                            ),
                          ],
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        decoration: BoxDecoration(
                            color: AppColors.secondaryAccent,
                            borderRadius: BorderRadius.circular(32)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: AppColors.secondaryAccent),
                        // Wrap the IconButton in a Material widget for the
                        // IconButton's splash to render above the container.
                        child: Material(
                          borderRadius: BorderRadius.circular(32),
                          type: MaterialType.transparency,
                          // Hard Edge makes sure the splash is clipped at the border of this
                          // Material widget, which is circular due to the radius above.
                          clipBehavior: Clip.hardEdge,
                          child: IconButton(
                            padding: EdgeInsets.all(16),
                            color: AppColors.primaryWhiteColor,
                            iconSize: 32,
                            icon: Icon(
                              Icons.qr_code_scanner,
                            ),
                            onPressed: () {
                              adsUtil.showInterstitialAd(() => scanBarcode());
                            },
                          ),
                        ),
                      ),
                    ]),
              )
            ]),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ListView(children: [
                MyBannerAdWidget(),
                for (var model in HomeScreen.categoryModels)
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36.0, vertical: 16),
                      child: GestureDetector(
                        // onTap: () => scanBarcode(),
                        onTap: () =>
                            adsUtil.showInterstitialAd(() => scanBarcode()),
                        child: SpendingCategory(model),
                      )),
                NativeExample()
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
