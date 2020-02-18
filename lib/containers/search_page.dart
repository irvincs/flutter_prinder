import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_prinder/entities/entities.dart';
import 'package:flutter_prinder/models/models.dart';
import 'package:flutter_prinder/selectors/selectors.dart';
import 'package:flutter_prinder/presentation/search_actions.dart';
import 'package:flutter_prinder/containers/swipe_strangers.dart';
import 'package:flutter_prinder/presentation/image_radar.dart';
import 'package:map_launcher/map_launcher.dart';

//////////////////////////




////////////////
class Search extends StatefulWidget {

  @override
  SearchPage createState() => SearchPage();
}

class SearchPage extends State<Search> {
  bool re = false;
  int val = 0;

  void test() {
    setState(() {
      re = false;
      val = 2;
    });

  }

  @override
  Widget build(BuildContext context) {
    double imageRadarSize = MediaQuery.of(context).size.width / 4;
    return new StoreConnector<AppState, ViewModel>(
      converter: ViewModel.fromStore,
      builder: (context, vm) {
        return new Column(
          children: <Widget>[
            new Expanded(
              child: vm.hasStrangers
                ? new Padding(
                    padding: new EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0),
                    child: new SwipeStrangers()
                  )
                : new ImageRadar(
                    diameter: imageRadarSize,
                    image: vm.userFirstImageUrl == ''
                      ? new AssetImage('images/empty.jpg')
                      : new NetworkImage(vm.userFirstImageUrl)
                  )
            ),
            new SearchActions(
              onBackPressed: vm.onBackPressed,
              onNopePressed: vm.onNopePressed,
              onSuperLikePressed: vm.onSuperLikePressed,
              onLikePressed: vm.onLikePressed,
              //onLikePressed: openMapsSheet(context),
              //
              //
              onBoostPressed: vm.onBoostPressed,
              //onBoostPressed: test(),
            ),
            RaisedButton(
              child: Text(
                'Send text back',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                _sendDataBack(context);
              },
            )
          ],
        );
      }
    );
  }

  void _sendDataBack(BuildContext context) {
      //String textToSendBack = textFieldController.text;
      Navigator.pop(context, "test");
  }
}




class ViewModel {
  ViewModel({
    this.userFirstImageUrl,
    this.hasStrangers,
    this.onBackPressed,
    this.onNopePressed,
    this.onSuperLikePressed,
    this.onLikePressed,
    this.onBoostPressed,
  });


  static ViewModel fromStore(Store<AppState> store) {
    return new ViewModel(
      userFirstImageUrl: userFirstImageUrlSelector(store),
      hasStrangers: hasStrangersSelector(store),
      onBackPressed: () => print('back'),
      onNopePressed: () => print('nope'),
      //onSuperLikePressed: () => print('super like'),
      onSuperLikePressed: () => launcher("Lexmark Printer", 10.3153438,123.9092181),
      onLikePressed: () => print('like'),
      onBoostPressed: () => print('boost'),
    );
  }

  final String userFirstImageUrl;
  final bool hasStrangers;
  final VoidCallback onBackPressed;
  final VoidCallback onNopePressed;
  final VoidCallback onSuperLikePressed;
  final VoidCallback onLikePressed;
  final VoidCallback onBoostPressed;
}
