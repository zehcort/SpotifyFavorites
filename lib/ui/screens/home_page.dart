import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spotify_favorites/models/artist.dart';
import 'package:spotify_favorites/ui/screens/artist_page.dart';
import 'package:spotify_favorites/ui/screens/favorites_page.dart';
import 'package:spotify_favorites/utils/theme.dart';
import 'package:spotify_favorites/utils/constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//-----------------------------------------------------------------------------------------------------------
// MODELS

  List<Artist> artists = new List<Artist>();
  List<Artist> favoriteArtists = new List<Artist>();

//-----------------------------------------------------------------------------------------------------------
// STATE VARIABLES

  bool _saving = false;

//-----------------------------------------------------------------------------------------------------------
// STATUS METHODS

  @override
  void initState() {
    super.initState();
    this.getArtistListRequest();
    loadOriginalJson();
  }

  @override
  dispose() {
    super.dispose();
  }

  void _loadStart() {
    setState(() {
      _saving = true;
    });
  }

  void _loadEnd() {
    setState(() {
      _saving = false;
    });
  }

  void _updateArtists(artists) {
    this.setState(() {
      this.artists = artists;
    });
  }
  //------------------------------------------------------------------------------------------------------------
  // API REQUESTS

  Future getArtistListRequest() async {
    _loadStart();

    String url = Constants.SERVER_TXT + Constants.API_GET_ARTIST_LIST_TXT;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': Constants.API_AUTH_TOKEN_TXT
    };
    try {
      http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 15))
          .then((http.Response response) {
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 300 || json == null) {
          Fluttertoast.showToast(msg: Constants.CONNECTION_ERROR_TXT);
        } else {
          _updateArtists(artistsFromJson(response.body).artists);
        }
        _loadEnd();
      });
    } catch (error) {
      log(error);
    }
  }

//------------------------------------------------------------------------------------------------------------
// METHODS

  void goFavoritesPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FavoritesPage()));
  }

  void goArtistPage(artist) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ArtistPage(artist)));
  }

  void saveFavorite(artistJson) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/favorite_artists.json');
      String data = await file.readAsString();
      final jsonData = json.decode(data);
      jsonData["artists"].add(artistJson);

      await file.writeAsString(jsonEncode(jsonData));
      Fluttertoast.showToast(msg: Constants.FAVORITE_ADDED_TXT);
    } catch (error) {
      log(error);
    }
  }

  void loadOriginalJson() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/favorite_artists.json");
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/favorite_artists.json');
    await file.writeAsString(data);
  }

  //------------------------------------------------------------------------------------------------------------
  // WIDGETS

  Widget logo() {
    return SvgPicture.asset(
      'assets/spotify_logo.svg',
      width: 100,
    );
  }

  Widget artistList() {
    return ListView.builder(
      itemCount: artists == null ? 0 : artists.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => goArtistPage(artists[index]),
          child: Card(
              color: mainTheme().cardColor,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(artists[index].name,
                                    style: mainTheme().textTheme.subtitle1)),
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () => saveFavorite(artists[index].jsonValue),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.grey,
                        )),
                  )
                ],
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: _saving,
        child: SafeArea(
            child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: 50,
                ),
                logo(),
                GestureDetector(
                  onTap: goFavoritesPage,
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Text(Constants.MY_FAVS_TXT,
                          style: mainTheme().textTheme.subtitle1)),
                )
              ],
            ),
            Expanded(
              child: artistList(),
            )
          ],
        )));
  }
}
