import 'package:sigortadefterim/models/GoogleMap.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




//Api faturası ödenince çalışacak...
class MapService {
  static final _service = new MapService();

  static MapService get() {
    return _service;
  }

  final String searchUrl =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&keyword=cruise&key=AIzaSyDC6scoD9XKo0Qv_CaUJ_0pe2-o1z5X_nQ";

  Future<List<Place>> getNearbyPlaces() async {
    var response =
        await http.get(searchUrl, headers: {"Accept": "application/json"});
    var places = <Place>[];

    List data = json.decode(response.body)['results'];

    data.forEach((f) {
      places.add(Place(id: f['id'], name: f['name'], vicinity: f['vicinity']));

      
    });

    print(places);

    return places;
  }
}
