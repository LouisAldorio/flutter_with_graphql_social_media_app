import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:social_media_app/components/bottom_nav.dart';
import 'package:social_media_app/components/fab.dart';
import 'package:social_media_app/graphql/config.dart';
import 'package:social_media_app/pages/comments.dart';
import 'package:social_media_app/pages/post.dart';
import 'package:social_media_app/pages/posts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_media_app/pages/users.dart';
import "package:social_media_app/themes/color.dart";
import 'package:redux/redux.dart' as redux;
import 'package:flutter_redux/flutter_redux.dart';
import "package:social_media_app/store/app_state.dart";

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {

  final redux.Store<AppState> store;
  const MyApp({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: graphQLConfiguration.client,
        child: StoreProvider(
          store: store,
          child: MaterialApp(
            routes: {
              "/posts": (BuildContext context) => Posts(),
              "/post-detail": (BuildContext context) => Post()
            },
            theme: ThemeData(
              scaffoldBackgroundColor: CustomColor.kBackgroundColor,
              primarySwatch: Colors.green,
              appBarTheme: AppBarTheme(
                  color: CustomColor.kPrimaryColor
              ),
              textTheme: TextTheme(
                // displayLarge: TextStyle(
                //   fontSize: 50,
                //   fontWeight: FontWeight.bold
                // )
                // displayLarge: Typography.englishLike2018.displayLarge?.copyWith(color: Colors.red)
              ),
              typography: Typography.material2018(
                // platform: TargetPlatform.windows,
                // englishLike: Typography.englishLike2018,
                // dense: Typography.dense2018,
                // tall: Typography.tall2018
              ),

              visualDensity: VisualDensity.adaptivePlatformDensity,

            ),
            home: Main(),
          ),
        )
    );
  }
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  static final List<Widget> _widgetOptions = <Widget>[
    Posts(),
    Comments(),
    Users(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, int>(
          builder: (BuildContext context, index) {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _widgetOptions.elementAt(
                  index > _widgetOptions.length - 1 ? _widgetOptions.length - 1 : index
              ),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
            );
          },
          converter: (store) {
            return store.state.currentBottomNavigationIndex;
          }
      ),
      bottomNavigationBar: CustomBottomNavigation(),
      floatingActionButton: CustomFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
    );
  }
}





