import 'dart:convert';

Artists artistsFromJson(String str) => Artists.fromJson(json.decode(str));
Artist artistFromJson(String str) => Artist.fromJson(json.decode(str));

class Artists {
  List<Artist> artists;

  Artists({this.artists});

  factory Artists.fromJson(Map<String, dynamic> json) {
    List<Artist> artistsTemp = new List<Artist>();
    Artist artistTemp = new Artist();
    for (var i = 0; i < json["artists"].length; i++) {
      artistTemp = Artist.fromJson(json["artists"][i]);
      artistsTemp.add(artistTemp);
    }
    return Artists(
      artists: artistsTemp,
    );
  }
}

class Artist {
  String name;
  int popularity;
  String image;
  String id;
  Map<String, dynamic> jsonValue;

  Artist({this.name, this.popularity, this.image, this.id, this.jsonValue});

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
      name: json["name"],
      popularity: json["popularity"],
      image: json["images"][0]["url"],
      id: json["id"],
      jsonValue: json);
}
