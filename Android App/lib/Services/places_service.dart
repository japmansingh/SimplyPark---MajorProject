import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:minor_project/Models/place.dart';

class PlacesService {
  final key = 'AIzaSyBaSIzjAQ2dq2QdwkSS2xP93wAXwmCmkFA';

  Future<List<Place>> getPlaces(double lat, double lng) async {
    var response = await http.get('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=parking&rankby=distance&key=$key');
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place)).toList();
  }

}