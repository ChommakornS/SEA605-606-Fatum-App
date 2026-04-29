import 'package:flutter/material.dart';
import '../models/coven_post.dart';
import '../pages/awakening/awakening_page.dart';
import '../pages/edit_post/edit_post_page.dart';

class AppRoutes {
  static const awakening = '/';
  static const shell = '/shell';
  static const editPost = '/edit-post';
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.awakening:
      return MaterialPageRoute(builder: (_) => const AwakeningPage());

    case AppRoutes.editPost:
      final post = settings.arguments as CovenPost;
      return MaterialPageRoute(builder: (_) => EditPostPage(post: post));

    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('404 — Page not found')),
        ),
      );
  }
}
