import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spotify_favorites/models/album.dart';
import 'package:spotify_favorites/models/artist.dart';
import 'package:spotify_favorites/utils/theme.dart';
import 'package:spotify_favorites/utils/constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ArtistPage extends StatefulWidget {
  final Artist artist;

  ArtistPage(this.artist);

  @override
  _ArtistPageState createState() => _ArtistPageState(artist);
}

class _ArtistPageState extends State<ArtistPage> {
//------------------------------------------------------------------------------------------------------------
// BUILDER

  _ArtistPageState(this.artist);

//-----------------------------------------------------------------------------------------------------------
// MODELS

  Artist artist;
  List<Album> albums = new List<Album>();

//-----------------------------------------------------------------------------------------------------------
// STATE VARIABLES

  bool _saving = false;

//-----------------------------------------------------------------------------------------------------------
// STATUS METHODS

  @override
  void initState() {
    super.initState();
    this.getAlbumsRequest();
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

  void _updateAlbums(albums) {
    this.setState(() {
      this.albums = albums;
    });
  }

//-----------------------------------------------------------------------------------------------------------
// METHODS

  goToAlbum(album) async {
    var url = album.url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: Constants.INVALID_URL_TXT);
    }
  }

//------------------------------------------------------------------------------------------------------------
// API REQUESTS

  Future getAlbumsRequest() async {
    _loadStart();

    String apiWithID =
        Constants.API_GET_ALBUMS_TXT.replaceAll('{id}', artist.id);
    String url = Constants.SERVER_TXT + apiWithID;

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
          _updateAlbums(albumsFromJson(response.body).albums);
        }
        _loadEnd();
      });
    } catch (error) {
      Fluttertoast.showToast(msg: Constants.CONNECTION_ERROR_TXT);
    }
  }

//------------------------------------------------------------------------------------------------------------
// WIDGETS

  Widget image() {
    return Image.network(
      artist.image,
      height: 300,
    );
  }

  Widget albumList() {
    return ListView.builder(
      itemCount: albums == null ? 0 : albums.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => goToAlbum(albums[index]),
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
                                child: Text(albums[index].name,
                                    style: mainTheme().textTheme.subtitle1)),
                          ],
                        )),
                  ),
                  Container(
                      height: 30,
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Image.network(albums[index].image))
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
          child: Container(
              child: Column(
        children: <Widget>[
          Container(
              padding:
                  EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
              child: Text(artist.name, style: mainTheme().textTheme.headline6)),
          Container(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(artist.popularity.toString(),
                  style: mainTheme().textTheme.headline6)),
          image(),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: albumList(),
          )
        ],
      ))),
    );
  }
}
