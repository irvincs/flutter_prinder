import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_prinder/actions/actions.dart';
import 'package:flutter_prinder/containers/main_page.dart';
import 'package:flutter_prinder/containers/profile_details_page.dart';
import 'package:flutter_prinder/containers/preferences_page.dart';
import 'package:flutter_prinder/middleware/middlewares.dart';
import 'package:flutter_prinder/models/models.dart';
import 'package:flutter_prinder/reducers/app_state_reducer.dart';
import 'package:flutter_prinder/utils/redux_logging.dart';


class MyApp extends StatelessWidget {
  final store = new Store<AppState>(
    appReducer,
    distinct: true,
    initialState: new AppState.loading(),
    middleware: createAllMiddlewares()
      ..addAll(createLoggingMiddlewares())
  );

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
        title: 'Prinder',
        routes: {
          '/': (context) {
            return new StoreBuilder<AppState>(
              onInit: (store) {
                store.dispatch(new LoadAppAction());
              },
              builder: (context, store) {
                return new MainPage();
              }
            );
          },
          '/user-profile-details': (context) {
            return new StoreBuilder<AppState>(
              builder: (context, store) => new ProfileDetailsPage(),
            );
          }
        },
      ),
    );
  }
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');
  PrefService.setDefaultValues({'user_description' : 'This is my description'});
  runApp(MyApp());
}