import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_profile/screens/home_screen.dart';
import 'package:personal_profile/screens/create_profile_screen.dart';
import 'package:personal_profile/screens/view_profile_screen.dart';
import 'package:personal_profile/screens/edit_profile_screen.dart';
import 'package:personal_profile/screens/enter_profile_id_screen.dart';

final router = GoRouter(
  initialLocation: '/',
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
      path: '/enter-id',
      builder: (context, state) => const EnterProfileIdScreen(),
    ),
    GoRoute(
      path: '/view/:id',
      builder: (context, state) => ViewProfileScreen(
        id: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/edit/:id',
      builder: (context, state) => EditProfileScreen(
        id: state.pathParameters['id']!,
      ),
    ),
  ],
);
