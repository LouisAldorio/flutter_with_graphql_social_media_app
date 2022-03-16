import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_media_app/components/post_card.dart';
import 'package:social_media_app/services/post.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {

  int limit = 5;
  int page = 1;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    return Query(
      options: QueryOptions(
        document: gql(getPosts),
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

        List? posts = result.data?['posts']?['data'];
        int? totalPage = result.data?["posts"]?["totalPages"];

        if (posts == null) {
          return const Text('No Posts');
        }

        // Build post list
        return NotificationListener(
            child: Builder(
              builder: (context) => ListView.builder(
                  itemCount: page < totalPage! ? posts.length + 1 : posts.length,
                  controller: scrollController,
                  itemBuilder: (context, index) {

                    if(index == posts.length && page <= totalPage) {
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
                    final post = posts[index];

                    return PostCard(
                        id: post["id"],
                        title: post["title"],
                        body: post["body"],
                        author: post["author"]["name"]
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
                      ...previousResultData?['posts']['data'] as List<dynamic>,
                      ...fetchMoreResultData?['posts']['data'] as List<dynamic>
                    ];
                    fetchMoreResultData?['posts']['data'] = posts;
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
