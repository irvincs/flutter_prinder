import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_prinder/actions/actions.dart';
import 'package:flutter_prinder/entities/entities.dart';
import 'package:flutter_prinder/models/models.dart';
import 'package:flutter_prinder/presentation/image_carousel.dart';
import 'package:flutter_prinder/presentation/my_music_tile.dart';
import 'package:flutter_prinder/presentation/rounded_button_icon.dart';
import 'package:flutter_prinder/selectors/selectors.dart';
import 'package:flutter_prinder/utils/formatters.dart';

class ProfileDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, ViewModel>(
      converter: ViewModel.fromStore,
      builder: (context, vm) {
        final double backButtonIconSize = MediaQuery.of(context).size.width / 10;
        return new Scaffold(
          body: new Stack(
            children: <Widget>[
              new ListView(
                padding: new EdgeInsets.only(top: 0.0, bottom: 100.0),
                children: <Widget>[
                  new Stack(
                    children: <Widget>[
                      new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new ImageCarousel(
                            images: vm.user.images,
                            currentImageIndex: vm.selectedImageIndex,
                            tagBase: 'user-profile-image-',
                            onCurrentImageIndexChanged: vm.onCurrentImageIndexChanged,
                          ),
                          new Container(
                            padding: new EdgeInsets.all(20.0),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Container(
                                  padding: new EdgeInsets.only(bottom: 10.0),
                                  child: new Text(
                                    vm.presentationName,
                                    style: new TextStyle(
                                      fontSize: 30.0
                                    ),
                                  ),
                                ),
                                new Row(
                                  children: <Widget>[
                                    new Container(
                                      padding: new EdgeInsets.only(right: 5.0),
                                      child: new Icon(
                                        Icons.place,
                                        size: 18.0,
                                        color: Colors.black45,
                                      ),
                                    ),
                                    new Text(
                                      makeDistanceDescription(vm.user.distance),
                                      style: new TextStyle(
                                        color: Colors.black45,
                                        fontSize: 18.0
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      new Container(
                        alignment: new Alignment(1.0, 0.0),
                        padding: new EdgeInsets.symmetric(horizontal: backButtonIconSize / 2),
                        transform: new Matrix4.translationValues(0.0, MediaQuery.of(context).size.width - (backButtonIconSize / 2 + 10), 1.0),
                        child: new RoundedButtonIcon(
                          color: Colors.redAccent,
                          iconColor: Colors.white,
                          icon: Icons.arrow_downward,
                          iconSize: backButtonIconSize,
                          padding: 10.0,
                          onPressed: vm.onNavigateBack(context),
                        ),
                      )
                    ],
                  ),
                  new Divider(
                    color: Colors.black26,
                    height: 0.5,
                  ),
                  new Container(
                    padding: new EdgeInsets.all(20.0),
                    child: new Text(
                      vm.user.description,
                      style: new TextStyle(
                        color: Colors.black45,
                        fontSize: 20.0
                      ),
                    ),
                  ),
                  new Divider(
                    color: Colors.black26,
                    height: 0.5,
                  ),
                  new Container(
                    padding: new EdgeInsets.all(20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          'My Music',
                          style: new TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 20.0),
                          child: new MyMusicTile(
                            music: 'Rap God',
                            artist: 'Eminem',
                            imageUrl: 'https://assets.audiomack.com/mc-hone/rap-god-eminem-275-275-1522798584.jpg',
                          )
                        )
                      ],
                    )
                  ),
                ],
              ),
              _buildOverlayEditInfoButton(context)
            ]
          ),
        );
      }
    );
  }

  Widget _buildOverlayEditInfoButton(BuildContext context) {
    return new Container(
      alignment: Alignment.bottomCenter,
      margin: new EdgeInsets.only(top: MediaQuery.of(context).size.height - 100),
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: new FractionalOffset(0.5, 0.0),
          end: new FractionalOffset(0.5, 1.0),
          colors: <Color>[
            Colors.white.withOpacity(0.0),
            Colors.white
          ]
        )
      ),
      height: 100.0,
      width: double.infinity,
      child: new GestureDetector(
        onTap: () => print('edit info'),
        child: new Container(
          margin: new EdgeInsets.all(15.0),
          padding: new EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(200.0),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: Colors.black38,
                blurRadius: 1.0,
                spreadRadius: 0.0,
                offset: new Offset(0.5, 2.0)
              )
            ],
            color: Colors.white
          ),
          child: new Text(
            'EDIT INFO',
            style: new TextStyle(
              color: Colors.red,
              fontSize: 24.0
            ),
          ),
        ),
      )
    );
  }
}

class ViewModel {
  ViewModel({
    this.presentationName,
    this.selectedImageUrl,
    this.selectedImageIndex,
    this.user,
    this.onCurrentImageIndexChanged,
  });

  static ViewModel fromStore(Store<AppState> store) =>
    new ViewModel(
      presentationName: userPresentationNameSelector(store),
      selectedImageUrl: userSelectedImageUrlSelector(store),
      selectedImageIndex: userSelectedImageIndexSelector(store),
      user: userSelector(store).user,
      onCurrentImageIndexChanged: (int imageIndex) =>
        store.dispatch(new ChangeSelectedImageIndexAction(imageIndex)),
    );

  final String presentationName;
  final String selectedImageUrl;
  final int selectedImageIndex;
  final UserEntity user;
  final Function onCurrentImageIndexChanged;

  Function onNavigateBack(BuildContext context) =>
    () => Navigator.of(context).pop();
}
