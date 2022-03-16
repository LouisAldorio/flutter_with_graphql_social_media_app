import 'package:flutter/material.dart';
import 'package:social_media_app/store/actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:social_media_app/store/app_state.dart';

class CustomFloatingActionButton extends StatefulWidget {
  const CustomFloatingActionButton({Key? key}) : super(key: key);

  @override
  State<CustomFloatingActionButton> createState() => _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState extends State<CustomFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: SizedBox(
          height: 80,
          width: 80,
          child: StoreConnector<AppState,VoidCallback>(
            builder: (BuildContext context, callback){
              return FloatingActionButton(
                backgroundColor: Colors.transparent,
                elevation: 0,
                onPressed: () {
                  callback();
                },
                child: Container(
                  height: 75,
                  width: 75,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 4),
                      shape: BoxShape.circle,
                      color: Colors.green
                  ),
                  child: Icon(Icons.add, size: 40),
                ),
              );
              // return Text("asd", style: Theme.of(context).textTheme.displayMedium);
            },
            converter: (store) {
              return () => store.dispatch(
                  ChangeBottomNavigationAction(
                      payload: store.state.currentBottomNavigationIndex + 1
                  )
              );
            },
          )
      ),
    );
  }
}
