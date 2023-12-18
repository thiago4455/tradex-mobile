import 'package:flutter/foundation.dart' as foundation;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;
import 'package:tradex_mobile/core/models.dart';
import 'package:http_parser/http_parser.dart';

const _kLocalApiUrl = 'http://192.168.18.57:8000/api';

class Api{
  static const String _apiUrl = foundation.kReleaseMode
      ? 'https://production.example.com/api'
      : foundation.kProfileMode
          ? 'https://dev.example.com/api'
          : _kLocalApiUrl;

  static const Map<String, String> _baseHeaders = {
    'User-Agent': 'Tradex App'
  };


  static Future<http.Response> fetchGetProducts(){
    return http.get(
      Uri.parse(_apiUrl).addPath('/products/'), headers: _baseHeaders
    );
  }

  static Future<http.Response> fetchGetPricing(String ean){
    return http.get(
      Uri.parse(_apiUrl).addPath('/products/$ean/prices/'), headers: _baseHeaders
    );
  }


  static Future<http.Response> fetchAddPrice(String ean, double price){
    return http.post(
      Uri.parse(_apiUrl).addPath('/products/$ean/prices/'), headers: _baseHeaders, body: {
        "price": price.toString(),
        "product": ean
      }
    );
  }

  static Future<http.StreamedResponse> fetchCreateProduct({required String name,required String ean,required double price,required
   double minPrice,required double maxPrice, XFile? image}) async{
    var req = http.MultipartRequest("POST", Uri.parse(_apiUrl).addPath('/products/'));
    req.fields["name"] = name;
    req.fields["ean"] = ean;
    req.fields["price"] = price.toString();
    req.fields["min_price"] = minPrice.toString();
    req.fields["max_price"] = maxPrice.toString();
    if(image != null){
      req.files.add(await http.MultipartFile.fromPath("image", image.path, filename: image.name, contentType: MediaType("image", image.mimeType ?? "jpg")));
    }
    return await req.send();
  }
}

Future<List<Product>> getProducts() async{
  final response = await Api.fetchGetProducts();
  if (response.statusCode == 200){
    return Product.fromRespose(convert.jsonDecode(response.body));
  } else { 
    throw Exception(response.body);
  }
}



Future<List<Pricing>> getPricing(String ean) async{
  final response = await Api.fetchGetPricing(ean);
  if (response.statusCode == 200){
    return Pricing.fromRespose(convert.jsonDecode(response.body));
  } else { 
    throw Exception(response.body);
  }
}

Future<bool> addPricing(String ean, double price) async{
  final response = await Api.fetchAddPrice(ean, price);
  if (response.statusCode == 201){
    return true;
  } else { 
    return false;
  }
}



Future<bool> createProduct({required String name,required String ean,required double price,required
   double minPrice,required double maxPrice, XFile? image}) async{
  final response = await Api.fetchCreateProduct(name:name, ean:ean, price:price, minPrice:minPrice, maxPrice:maxPrice, image:image);
  if (response.statusCode == 201){
    return true;
  } else { 
    return false;
  }
}

extension UriUtils on Uri {
  Uri addPath(String newPath) {
    return replace(path: path + newPath);
  }
}