import 'package:flutter/material.dart';
import 'package:code_wizard/screens/create/barcode_view.dart';

import '../../utils/barcode_conf.dart';
import '../../utils/settings.dart';
import '../../widgets/barcode_info.dart';
import '../../widgets/native_ad.dart';

class CreateScreen extends StatefulWidget {
  CreateScreen({Key? key}) : super(key: key);

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
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
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Settings(conf: conf),
        BarcodeView(conf: conf),
        BarcodeInfo(conf: conf),
        NativeExample()
      ],
    );
  }
}
