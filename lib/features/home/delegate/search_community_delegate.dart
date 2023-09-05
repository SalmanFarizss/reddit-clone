import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_5/core/common/circle_loader.dart';
import 'package:project_5/core/utilities.dart';
import 'package:project_5/features/community/controller/community_controller.dart';
import 'package:project_5/models/community_models.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchCommunityDelegate({required this.ref});
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return ref.watch(searchResultProvider(query)).when(
          data: (data) => ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              CommunityModel community = data[index];
              return ListTile(
                onTap: () => navigateToSearchResult(context, community),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(community.avatar),
                ),
                title: Text('r/${community.name}'),
              );
            },
            itemCount: data.length,
          ),
          error: (error, stackTrace) =>
              errorSnackBar(context, error.toString()),
          loading: () => const CircleLoader(),
        );
  }

  void navigateToSearchResult(BuildContext context, CommunityModel community) {
    Routemaster.of(context).push('/r/${community.name}');
  }
}
