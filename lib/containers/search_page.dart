import 'dart:async';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_prinder/entities/entities.dart';
import 'package:flutter_prinder/models/models.dart';
import 'package:flutter_prinder/selectors/selectors.dart';
import 'package:flutter_prinder/presentation/search_actions.dart';
import 'package:flutter_prinder/containers/swipe_strangers.dart';
import 'package:flutter_prinder/presentation/image_radar.dart';

//class SearchPage extends StatefulWidget {
//  final Function(BuildContext) builder;
//  SearchPage({Key key, this.builder}) : super(key: key);
//
//  @override
//  _SearchPage createState() => new _SearchPage();
//
//  static SearchPage of(BuildContext context) {
//    return context.ancestorStateOfType(const TypeMatcher<SearchPage>());
//  }
//}

class SearchPage extends StatefulWidget {
  final Stream shouldTriggerChange;

//  SearchPage({@required this.shouldTriggerChange});

//  final Function(BuildContext) builder;

  const SearchPage(
      {Key key, @required this.shouldTriggerChange})
      : super(key: key);

  @override
  SearchPageState createState() => new SearchPageState();

//  static SearchPageState of(BuildContext context) {
//    return context.ancestorStateOfType(const TypeMatcher<SearchPageState>());
//  }
}

class SearchPageState extends State<SearchPage> {
  StreamSubscription streamSubscription;

  @override
  initState() {
    super.initState();
    streamSubscription = widget.shouldTriggerChange.listen((_) => rebuild());
  }

  @override
  didUpdateWidget(SearchPage old) async {
    super.didUpdateWidget(old);
    // in case the stream instance changed, subscribe to the new one
    if (widget.shouldTriggerChange != old.shouldTriggerChange) {
      streamSubscription.cancel();
      streamSubscription = widget.shouldTriggerChange.listen((_) => rebuild());
    }
  }

  @override
  dispose() {
    super.dispose();
    streamSubscription.cancel();
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
              onRefreshed: vm.onRefreshed,
              onNopePressed: vm.onNopePressed,
              onSuperLikePressed: vm.onSuperLikePressed,
              onLikePressed: vm.onLikePressed,
              onBoostPressed: vm.onBoostPressed,
            )
          ],
        );
      }
    );

    //return widget.builder(context);
  }

  void rebuild() {
    print('rebuilding a widget');

    setState(() {});
    this.build(this.context);
  }
}

class ViewModel {
  ViewModel({
    this.userFirstImageUrl,
    this.hasStrangers,
    this.onRefreshed,
    this.onNopePressed,
    this.onSuperLikePressed,
    this.onLikePressed,
    this.onBoostPressed,
  });

  static ViewModel fromStore(Store<AppState> store) {
    return new ViewModel(
      userFirstImageUrl: userFirstImageUrlSelector(store),
      hasStrangers: hasStrangersSelector(store),
      onRefreshed: () => print('refresh'),
      onNopePressed: () => print('nope'),
      onSuperLikePressed: () => print('super like'),
      onLikePressed: () => print('like'),
      onBoostPressed: () => print('boost'),
    );
  }

  final String userFirstImageUrl;
  final bool hasStrangers;
  final VoidCallback onRefreshed;
  final VoidCallback onNopePressed;
  final VoidCallback onSuperLikePressed;
  final VoidCallback onLikePressed;
  final VoidCallback onBoostPressed;
}
