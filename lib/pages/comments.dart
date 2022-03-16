import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:social_media_app/components/comment.dart';
import 'package:social_media_app/model/author.dart';
import 'package:social_media_app/model/comment.dart';
import 'package:social_media_app/services/comment.dart';

class Comments extends StatefulWidget {
  const Comments({Key? key}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {

  int limit = 10;
  int page = 1;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
          document: gql(getComments),
          variables: {
            "page": page,
            "limit": limit
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

        List? comments = result.data?['comments']?['data'];
        int? totalPage = result.data?["comments"]?["totalPages"];

        if (comments == null) {
          return const Text('No Posts');
        }

        // Build post list
        return NotificationListener(
            child: Builder(
                builder: (context) => ListView.builder(
                    itemCount: page < totalPage! ? comments.length + 1 : comments.length,
                    controller: scrollController,
                    itemBuilder: (context, index) {

                      if(index == comments.length && page <= totalPage) {
                        return Center(
                          child: Container(
                            margin: EdgeInsets.all(20),
                            child: SpinKitWave(
                              color: Colors.green,
                              size: 35.0,
                            ),
                          ),
                        );
                      }

                      // Show your info
                      final post = comments[index];

                      return Column(
                        children: [
                          CommentCard(
                            comment: Comment(
                              id: post["id"],
                                  body: post["body"],
                                  author: Author(
                                      id: post["author"]["id"],
                                      name: post["author"]["name"]
                                  )
                              ),
                            )
                        ],
                      );
                    }
                )
            ),
            onNotification: (dynamic t) {
              if (t is ScrollEndNotification &&
                  scrollController.position.pixels >= scrollController.position.maxScrollExtent * 0.8 &&
                  result.isNotLoading && page < totalPage!) {

                page += 1;
                fetchMore!(FetchMoreOptions(
                  variables: {
                    "page": page,
                    "limit": limit
                  },
                  updateQuery: (previousResultData, fetchMoreResultData) {

                    final List<dynamic> posts = [
                      ...previousResultData?['comments']['data'] as List<dynamic>,
                      ...fetchMoreResultData?['comments']['data'] as List<dynamic>
                    ];
                    fetchMoreResultData?['comments']['data'] = posts;
                    return fetchMoreResultData;
                  },
                ));
              }
              return true;
            });
      },
    );
  }
}


