import 'package:flutter/material.dart';

import '../../utils/barcode_conf.dart';
import '../../utils/settings.dart';
import '../../widgets/banner_ad.dart';
import '../../widgets/barcode_info.dart';
import '../../widgets/native_ad.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final BarcodeConf conf = BarcodeConf();

  @override
  void initState() {
    conf.addListener(confListener);
    super.initState();
  }

  @override
  void dispose() {
    conf.removeListener(confListener);
    super.dispose();
  }

  void confListener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Settings(conf: conf),
          BarcodeInfo(conf: conf),
          MyBannerAdWidget()
        ],
      ),
    );
  }
}
