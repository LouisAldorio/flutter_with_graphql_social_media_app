import 'package:flutter/material.dart';

class PostArgument {
  String id;
  PostArgument({ required this.id });
}

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {

  PostArgument? data;

  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context)?.settings.arguments as PostArgument;

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: NetworkImage(
        //         "https://source.unsplash.com/random/300x300/?boys"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
                tag: "card_thumbnail${data?.id}",
                child: Image(
                  image: NetworkImage("https://source.unsplash.com/random/300x300/?girl"),
                  fit: BoxFit.cover,
                )
            ),
            Text("asdasdqwe")
          ],
        )
      )
    );
  }
}
