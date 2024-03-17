import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:code_wizard/utils/barcode_conf.dart';
import 'package:code_wizard/widgets/barcode_error.dart';

import '../../widgets/download.dart';

class BarcodeView extends StatefulWidget {
  const BarcodeView({
    Key? key,
    required this.conf,
  }) : super(key: key);

  final BarcodeConf conf;

  @override
  State<BarcodeView> createState() => _BarcodeViewState();
}

class _BarcodeViewState extends State<BarcodeView> {
  @override
  Widget build(BuildContext context) {
    try {
      widget.conf.barcode.verify(widget.conf.normalizedData);
    } on BarcodeException catch (error) {
      return BarcodeError(message: error.message);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Card(
          child: Column(
            children: [
              BarcodeWidget(
                drawText: true,
                barcode: widget.conf.barcode,
                data: widget.conf.normalizedData,
                width: widget.conf.width,
                height: widget.conf.height,
                style: TextStyle(
                  fontSize: widget.conf.fontSize,
                  color: Colors.black,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Download(conf: widget.conf),
            ],
          ),
        ),
      ),
    );
  }
}
