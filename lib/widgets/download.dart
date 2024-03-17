import 'dart:convert' show utf8;
import 'dart:typed_data';

import 'package:barcode_image/barcode_image.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as im;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../utils/ads_util.dart';
import '../utils/barcode_conf.dart';

class Download extends StatefulWidget {
  const Download({
    Key? key,
    required this.conf,
  }) : super(key: key);

  final BarcodeConf conf;

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  Widget _button(IconData icon, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  AdsUtil adsUtil = AdsUtil();
  @override
  void initState() {
    adsUtil.createInterstitialAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.conf.barcode.isValid(widget.conf.normalizedData)) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _button(Icons.file_download, 'SVG',
              () => adsUtil.showInterstitialAd(() => _exportSvg())),
          _button(Icons.file_download, 'PNG',
              () => adsUtil.showInterstitialAd(() => _exportPng())),
          _button(Icons.file_download, 'PDF',
              () => adsUtil.showInterstitialAd(() => _exportPdf())),
        ],
      ),
    );
  }

  Future<void> _exportPdf() async {
    final bc = widget.conf.barcode;
    final pdf = pw.Document(
      author: 'David PHAM-VAN',
      keywords: 'barcode, dart, ${widget.conf.barcode.name}',
      subject: widget.conf.barcode.name,
      title: 'Barcode demo',
    );
    const scale = 5.0;

    pdf.addPage(pw.Page(
      build: (context) => pw.Center(
        child: pw.Column(children: [
          pw.Header(text: bc.name, level: 2),
          pw.Spacer(),
          pw.BarcodeWidget(
            barcode: bc,
            data: widget.conf.normalizedData,
            width: widget.conf.width * PdfPageFormat.mm / scale,
            height: widget.conf.height * PdfPageFormat.mm / scale,
            textStyle: pw.TextStyle(
              fontSize: widget.conf.fontSize * PdfPageFormat.mm / scale,
            ),
          ),
          pw.Spacer(),
          pw.Paragraph(text: widget.conf.desc),
          pw.Spacer(),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.RichText(
              text: pw.TextSpan(
                text: 'Pdf file built using: ',
                children: [
                  pw.TextSpan(
                    text: 'https://pub.dev/packages/pdf',
                    annotation: pw.AnnotationUrl(
                      'https://pub.dev/packages/pdf',
                    ),
                    style: const pw.TextStyle(
                      color: PdfColors.blue,
                      decoration: pw.TextDecoration.underline,
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    ));

    final location = await getSaveLocation();
    if (location != null) {
      final file = XFile.fromData(
        await pdf.save(),
        name: '${bc.name}.pdf',
        mimeType: 'application/pdf',
      );
      await file.saveTo(location.path);
    }
  }

  Future<void> _exportPng() async {
    final bc = widget.conf.barcode;
    final image = im.Image(
        width: widget.conf.width.toInt() * 2,
        height: widget.conf.height.toInt() * 2);
    im.fill(image, color: im.ColorRgb8(255, 255, 255));
    drawBarcode(image, bc, widget.conf.normalizedData, font: im.arial48);
    final data = im.encodePng(image);

    final location = await getSaveLocation(suggestedName: "khaliq");
    if (location != null) {
      final file = XFile.fromData(
        Uint8List.fromList(data),
        name: '${bc.name}.png',
        mimeType: 'image/png',
      );
      await file.saveTo(location.path);
    }
  }

  Future<void> _exportSvg() async {
    final bc = widget.conf.barcode;

    final data = bc.toSvg(
      widget.conf.normalizedData,
      width: widget.conf.width,
      height: widget.conf.height,
      fontHeight: widget.conf.fontSize,
    );

    final location = await getSaveLocation();
    if (location != null) {
      final file = XFile.fromData(
        Uint8List.fromList(utf8.encode(data)),
        name: '${bc.name}.svg',
        mimeType: 'image/svg+xml',
      );
      await file.saveTo(location.path);
    }
  }
}
