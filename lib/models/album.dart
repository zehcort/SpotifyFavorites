import 'dart:convert';

Albums albumsFromJson(String str) => Albums.fromJson(json.decode(str));
Album albumFromJson(String str) => Album.fromJson(json.decode(str));

class Albums {
  List<Album> albums;

  Albums({this.albums});

  factory Albums.fromJson(Map<String, dynamic> json) {
    List<Album> albumsTemp = new List<Album>();
    Album albumTemp = new Album();
    for (var i = 0; i < json["items"].length; i++) {
      albumTemp = Album.fromJson(json["items"][i]);
      albumsTemp.add(albumTemp);
    }
    return Albums(
      albums: albumsTemp,
    );
  }
}

class Album {
  String name;
  String url;
  String image;

  Album({this.name, this.url, this.image});

  factory Album.fromJson(Map<String, dynamic> json) => Album(
      name: json["name"],
      url: json["external_urls"]["spotify"],
      image: json["images"][0]["url"]);
}
