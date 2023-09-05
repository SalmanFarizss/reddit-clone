import 'package:flutter/material.dart';
import 'package:project_5/features/auth/screens/login.dart';
import 'package:project_5/features/community/screens/community_screen.dart';
import 'package:project_5/features/community/screens/edit_community.dart';
import 'package:project_5/features/community/screens/mod_tools.dart';
import 'package:project_5/features/community/screens/new_community.dart';
import 'package:project_5/features/home/screens/home.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute=RouteMap(routes: {
  '/':(_)=>const MaterialPage(child: Login())
});
final loggedInRoute=RouteMap(routes: {
  '/':(_)=>const MaterialPage(child: Home()),
  '/create_community':(_)=>const MaterialPage(child: NewCommunity()),
  '/r/:name':(route)=>MaterialPage(child: CommunityScreen(name: route.pathParameters['name']!)),
  '/mod_tools/:name':(route)=> MaterialPage(child: ModTools(name:route.pathParameters['name']!)),
  '/edit_community/:name':(route)=>MaterialPage(child: EditCommunity(name: route.pathParameters['name']!))

});