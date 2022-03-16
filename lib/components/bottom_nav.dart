import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:social_media_app/store/actions.dart';
import 'package:social_media_app/store/app_state.dart';
import 'package:redux/redux.dart';

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {

  void _changeSelectedNavBar(int index) {
    store.dispatch(ChangeBottomNavigationAction(payload: index));
  }

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, int>(
        builder: (BuildContext context, index) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon:  Icon(Icons.post_add),
                label:  'Home',
              ),
              BottomNavigationBarItem(
                icon:  Icon(Icons.comment),
                label:  'Comments',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.perm_identity),
                  label: 'Author'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.more_horiz),
                  label: ''
              ),
            ],
            currentIndex: index,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            onTap: _changeSelectedNavBar,
          );
        },
        converter: (Store<AppState >store) {
          return store.state.currentBottomNavigationIndex;
        }
    );
  }
}


