import 'package:redux/redux.dart';
import 'package:social_media_app/store/reducer.dart';

class AppState {
  int currentBottomNavigationIndex;

  AppState({ required this.currentBottomNavigationIndex });
}

final Store<AppState> store = Store<AppState>(globalReducer, initialState: AppState(
  currentBottomNavigationIndex: 0
));