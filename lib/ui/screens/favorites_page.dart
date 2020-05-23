import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spotify_favorites/models/artist.dart';
import 'package:spotify_favorites/utils/theme.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:path_provider/path_provider.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  //-----------------------------------------------------------------------------------------------------------
// MODELS

  List<Artist> favoriteArtists = new List<Artist>();
//-----------------------------------------------------------------------------------------------------------
// STATE VARIABLES

  bool _saving = false;

//-----------------------------------------------------------------------------------------------------------
// STATUS METHODS

  @override
  void initState() {
    super.initState();
    loadFavorites();
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

  void _updateFavoriteArtists(favoriteArtists) {
    this.setState(() {
      this.favoriteArtists = favoriteArtists;
    });
  }

//------------------------------------------------------------------------------------------------------------
// METHODS

  void loadFavorites() async {
    _loadStart();
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/favorite_artists.json');
      String body = await file.readAsString();
      _updateFavoriteArtists(artistsFromJson(body).artists);
    } catch (error) {
      print("Couldn't read file");
    }
    _loadEnd();
  }

//------------------------------------------------------------------------------------------------------------
// WIDGETS

  Widget artistList() {
    return ListView.builder(
      itemCount: favoriteArtists == null ? 0 : favoriteArtists.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
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
                                child: Text(favoriteArtists[index].name,
                                    style: mainTheme().textTheme.subtitle1)),
                          ],
                        )),
                  ),
                ],
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ModalProgressHUD(
            inAsyncCall: _saving,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: artistList(),
                )
              ],
            )));
  }
}
