import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_prinder/entities/entities.dart';
import 'package:flutter_prinder/models/models.dart';
import 'package:flutter_prinder/selectors/selectors.dart';
import 'package:flutter_prinder/presentation/search_actions.dart';
import 'package:flutter_prinder/containers/swipe_strangers.dart';
import 'package:flutter_prinder/presentation/image_radar.dart';
import 'package:flutter_prinder/observers/search_observer.dart';
import 'package:flutter_prinder/services/services.dart';
import 'package:flutter_prinder/actions/actions.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:http/http.dart' as http;


class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.title, this.store}) : super(key: key);

  final String title;
  final Store<AppState> store;
  @override
  State<StatefulWidget> createState() => SearchPageState();
}


class SearchPageState extends State<SearchPage> implements SearchObserverStateListener {

  int currentImageIndex = 0;
  SearchObserverProvider searchObserver;

  SearchPageState() {
    searchObserver = new SearchObserverProvider();
    searchObserver.subscribe(this);
  }

  @override
  onStateChanged(ObserverState state) {
    //Do something when you detected a change
    if (state == ObserverState.REBUILD) {
      rebuild();
    }
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
              child: vm.hasPrinters
                ? new Padding(
                    padding: new EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0),
                    child: new SwipeStrangers(currentimageIdex: (index) => currentImageIndex = index)
                  )
                : new AvatarGlow(
                    startDelay: Duration(milliseconds: 1000),
                    glowColor: Colors.pink,
                    endRadius: 150.0,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: Material(
                      elevation: 8.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                          backgroundColor:Colors.grey[100] ,
                          backgroundImage: AssetImage('images/gavin.jpg'),
                          maxRadius: 40.0,
                      ),
                    ),
                    shape: BoxShape.circle,
                    animate: true,
                    curve: Curves.fastOutSlowIn,
                  )
            ),
            new SearchActions(
              onRefreshed: vm.onRefreshed,
              onUploadFile: requestPrint,
            )
          ],
        );
      }
    );
  }

  void rebuild() async {
    searchObserver.initState();
    try {
      List<PrinterEntity> printers = await UsersService.loadPrinters(widget.store);

      widget.store.dispatch(new LoadPrintersSuccessAction(printers));

    } catch (error) {
      widget.store.dispatch(new LoadPrintersFailAction(error.message));
    }

    didUpdateWidget(widget);
  }

  void requestPrint () async {
    print('request to print a file in $currentImageIndex');

    String printIndex = printersSelector(widget.store).printers[currentImageIndex].id;
    String printCommand = "http://10.194.48.115:8080/print?DeviceId=$printIndex";

    print(printCommand);

    http.Response response = await http.get(printCommand);
  }
}

class ViewModel {
  ViewModel({
    this.userFirstImageUrl,
    this.hasPrinters,
    this.onRefreshed,
    this.onUploadFile,
  });


  static ViewModel fromStore(Store<AppState> store) {
    return new ViewModel(
      userFirstImageUrl: userFirstImageUrlSelector(store),
      hasPrinters: hasPrintersSelector(store),
      onRefreshed: () => print('refresh'),
      onUploadFile: () => print('upload a file'),
    );
  }

  final String userFirstImageUrl;
  final bool hasPrinters;
  final VoidCallback onRefreshed;
  final VoidCallback onUploadFile;

  void printIndex () {

  }
}
