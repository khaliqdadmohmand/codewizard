import 'package:barcode_widget/barcode_widget.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:code_wizard/models/countries.dart';
import 'package:code_wizard/models/coutries_by_barcode.dart';
import 'package:code_wizard/screens/create/barcode_view.dart';
import 'package:code_wizard/utils/barcode_conf.dart';
import 'package:code_wizard/utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/banner_ad.dart';
import '../../widgets/native_ad.dart';

class ScannerScreen extends StatefulWidget {
  ScannerScreen({Key? key, required this.result}) : super(key: key);

  String result;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final BarcodeConf conf = BarcodeConf();
  List<Countries> countries = List.empty();
  List<CountriesByBarCode> countriesByBarCode = List.empty();

  String? countryName;
  String? countryCode;

  @override
  void initState() {
    Helper()
        .loadCountrieByBarcodeFromsJsonData()
        .then((value) => countriesByBarCode = value);
    Helper()
        .loadCountrieFromsJsonData()
        .then((value) => countries = value)
        .then((value) => checkBarcodOrigin());

    super.initState();
  }

  void checkBarcodOrigin() {
    conf.data = widget.result;
    if (Helper().isBarNumeric(widget.result)) {
      conf.type = BarcodeType.CodeEAN13;

      String firstThree = Helper().getFirstThreeDigits(widget.result);

      countriesByBarCode.any((item) => item.barcode == firstThree);

      setState(() {
        CountriesByBarCode codeOrigin = countriesByBarCode.firstWhere(
            (item) => item.barcode == firstThree,
            orElse: () => CountriesByBarCode());
        Countries country = countries.firstWhere(
            (item) =>
                item.name!.toLowerCase() == codeOrigin.country!.toLowerCase(),
            orElse: () => Countries());

        countryName = country.name;
        countryCode = country.code;

        print("====>>" + country.name!);
      });
    } else if (Helper().isBarText(widget.result)) {
      conf.type = BarcodeType.QrCode;
    } else if (Helper().isBarURL(widget.result)) {
      conf.type = BarcodeType.QrCode;
      _launchURL(widget.result);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Padding(
        padding: EdgeInsets.all(
          16,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                  "Based on your scan, it appears you've encountered a fascinating type of result. Scroll down for more info",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall),
              BarcodeView(conf: conf),
              SizedBox(height: 10),
              countryName != null
                  ? Column(
                      children: [
                        Text(
                            "Based on GS1 prefix the corresponding country detail",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall),
                        SizedBox(height: 10),
                        Text('${countryName}, ${countryCode}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.green)),
                        CountryFlag.fromCountryCode(
                          countryCode ?? "AF",
                          height: 100,
                          width: 200,
                          borderRadius: 8,
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Text("Result",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            await Clipboard.setData(
                                ClipboardData(text: "your text"));
                            var snackBar = SnackBar(
                                content: Text('Result coppied to clipboard!'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(widget.result,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: Colors.green)),
                          ),
                        ),
                        Text("Tap to copy!",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelSmall),
                        MyBannerAdWidget(),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  _launchURL(String parsedUrl) async {
    final Uri url = Uri.parse(parsedUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $parsedUrl');
    }
  }
}
