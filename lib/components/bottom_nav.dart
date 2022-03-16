import 'package:flutter/material.dart';
import 'package:social_media_app/store/actions.dart';
import 'package:social_media_app/store/app_state.dart';

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {

  int _selectedIndex = store.state.currentBottomNavigationIndex;

  void _changeSelectedNavBar(int index) {
    store.dispatch(ChangeBottomNavigationAction(payload: index));
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

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
            label: 'Users'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: ''
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _changeSelectedNavBar,
      );
  }
}


