import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:social_media_app/components/comment.dart';
import 'package:social_media_app/components/user_card.dart';
import 'package:social_media_app/model/author.dart';
import 'package:social_media_app/model/comment.dart';
import 'package:social_media_app/model/user.dart';
import 'package:social_media_app/services/user.dart';


class CreatePostForm extends StatefulWidget {
  const CreatePostForm({Key? key}) : super(key: key);

  @override
  State<CreatePostForm> createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<CreatePostForm> {

  dynamic _selected;

  void showModal(context){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            padding: EdgeInsets.all(8),
            height: 400,
            alignment: Alignment.center,
            child: Query(
              options: QueryOptions(
                  document: gql(getUsers),
                  variables: {
                    "page": null,
                    "limit": null
                  }
              ),
              builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore }) {

                if (result.hasException) {
                  return Text(result.exception.toString());
                }

                if (result.isLoading) {
                  if(result.data == null) {
                    return Center(
                      child: SpinKitWave(
                        color: Colors.green,
                        size: 60.0,
                      ),
                    );
                  }
                }

                List? users = result.data?['users']?['data'];

                // Build post list
                return ListView.builder(
                    itemCount: users?.length,
                    itemBuilder: (context, index) {
                      final user = users![index];
                      return GestureDetector(
                          child: Column(
                            children: [
                              CommentCard(
                                comment: Comment(
                                  author: Author(
                                      name: user["name"],
                                      id: user["id"]
                                  ),
                                  id: user["id"],
                                  body: user["email"],
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              _selected = users[index];
                            });
                            Navigator.pop(context);
                          }
                      );
                    }
                );
              },
            ),
          );
        }
    );
  }



  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        color: Colors.grey[300],
        child: Form(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Title of your New Post",
                      labelText: "Title",
                      icon: Icon(Icons.title),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Content of your New Post",
                      labelText: "Content",
                      icon: Icon(Icons.content_copy),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    child: Text('Show Modal'),
                    onPressed: () => showModal(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
