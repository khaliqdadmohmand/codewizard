import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/settings_widgets.dart';
import 'barcode_conf.dart';

/// Settings widget
class Settings extends StatefulWidget {
  /// Manage the barcode settings
  const Settings({Key? key, required this.conf}) : super(key: key);

  /// Barcode configuration
  final BarcodeConf conf;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final types = <BarcodeType, String>{};
    for (var item in BarcodeType.values) {
      types[item] = Barcode.fromType(item).name;
    }

    return Column(
      children: <Widget>[
        DropdownPreference<BarcodeType>(
          title: 'Barcode Type',
          onRead: (context) => widget.conf.type,
          onWrite: (context, dynamic value) => setState(() {
            widget.conf.type = value;
            ChangeNotifier();
          }),
          values: types,
        ),
        TextPreference(
          title: 'Data',
          onRead: (context) => widget.conf.data,
          onWrite: (context, value) => setState(() {
            widget.conf.data = value;
            ChangeNotifier();
          }),
        )
      ],
    );
  }
}
