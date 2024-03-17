class CountriesByBarCode {
  String? country;
  String? barcode;

  CountriesByBarCode({this.country, this.barcode});

  CountriesByBarCode.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    barcode = json['barcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['barcode'] = this.barcode;
    return data;
  }
}
