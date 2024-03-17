import 'package:flutter/material.dart';

import '../utils/barcode_conf.dart';

class BarcodeInfo extends StatelessWidget {
  const BarcodeInfo({
    Key? key,
    required this.conf,
  }) : super(key: key);

  final BarcodeConf conf;

  @override
  Widget build(BuildContext context) {
    final bc = conf.barcode;

    final charset = StringBuffer();
    for (var c in bc.charSet) {
      if (c > 0x20) {
        charset.write('${String.fromCharCode(c)} ');
      } else {
        charset.write('0x${c.toRadixString(16)} ');
      }
    }

    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${bc.name}\n',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30),
                ),
                const TextSpan(
                  text: '\nDescription:\n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextSpan(
                  text: '${conf.desc}\n',
                ),
                const TextSpan(
                  text: '\nAccepted data:\n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextSpan(
                  text: '$charset\n\n',
                ),
                TextSpan(
                  text: 'Minimum length: ${bc.minLength}\n',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                // if (bc.maxLength < Barcode.infiniteMaxLength)
                TextSpan(
                  text: 'Maximum length: ${bc.maxLength}\n',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            // textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
