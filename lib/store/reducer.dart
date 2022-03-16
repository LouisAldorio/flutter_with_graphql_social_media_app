import 'package:social_media_app/store/actions.dart';
import "package:social_media_app/store/app_state.dart";

AppState globalReducer(AppState previousState, dynamic action) {
  if(action is ChangeBottomNavigationAction) {
    return changeBottomNavigationIndex(previousState, action);
  }
  return previousState;
}

AppState changeBottomNavigationIndex(AppState previousState, ChangeBottomNavigationAction action) {
  return AppState(
    currentBottomNavigationIndex: action.payload
  );
}