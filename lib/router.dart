import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_profile/screens/home_screen.dart';
import 'package:personal_profile/screens/create_profile_screen.dart';
import 'package:personal_profile/screens/view_profile_screen.dart';
import 'package:personal_profile/screens/edit_profile_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/create',
      builder: (context, state) => const CreateProfileScreen(),
    ),
    GoRoute(
      path: '/view/:id',
      builder: (context, state) => ViewProfileScreen(
        profileId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/edit/:id',
      builder: (context, state) => EditProfileScreen(
        profileId: state.pathParameters['id']!,
      ),
    ),
  ],
);
