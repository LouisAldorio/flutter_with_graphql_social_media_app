import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:social_media_app/components/user_card.dart';
import 'package:social_media_app/model/user.dart';
import 'package:social_media_app/services/user.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {

  int limit = 10;
  int page = 1;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
          document: gql(getUsers),
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

        List? users = result.data?['users']?['data'];
        int? totalPage = result.data?["users"]?["totalPages"];

        if (users == null) {
          return const Text('No Posts');
        }

        // Build post list
        return NotificationListener(
            child: Builder(
                builder: (context) => ListView.builder(
                    itemCount: page < totalPage! ? users.length + 1 : users.length,
                    controller: scrollController,
                    itemBuilder: (context, index) {

                      if(index == users.length && page <= totalPage) {
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
                      final user = users[index];

                      return Column(
                        children: [
                          ProfileScreen(
                            user: User(
                              name: user["name"],
                              id: user["id"],
                              city: user["address"]["city"],
                              companyName: user["company"]["name"],
                              email: user["email"],
                              phone: user["phone"],
                              street: user["address"]["street"],
                              suite: user["address"]["suite"],
                              username: user["username"],
                              website: user["website"],
                              zipcode: user["address"]["zipcode"]
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
                      ...previousResultData?['users']['data'] as List<dynamic>,
                      ...fetchMoreResultData?['users']['data'] as List<dynamic>
                    ];
                    fetchMoreResultData?['users']['data'] = posts;
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
