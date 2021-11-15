import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:uidraft1/admin%20tools/create_tag.dart';
import 'package:uidraft1/error/error_feed_widget.dart';
import 'package:uidraft1/main.dart';
import 'package:uidraft1/screens/auth/auth_screen.dart';
import 'package:uidraft1/screens/auth/change_password_screen.dart';
import 'package:uidraft1/screens/feed/feed_screen.dart';
import 'package:uidraft1/screens/profile/create/create_profile_screen.dart';
import 'package:uidraft1/screens/profile/profile_screen.dart';
import 'package:uidraft1/screens/search/search_screen.dart';
import 'package:uidraft1/screens/studio/studio_screen.dart';
import 'package:uidraft1/screens/subchannel/create/create_subchannel_screen.dart';
import 'package:uidraft1/screens/subchannel/subchannel_screen.dart';
import 'package:uidraft1/screens/subchannelmod/submod_screen.dart';
import 'package:uidraft1/screens/uploadVideo/upload_video_screen.dart';
import 'package:uidraft1/screens/videoplayer/videoplayer_screen.dart';
import 'package:uidraft1/widgets/auth/password/change_password_widget.dart';
import 'package:uidraft1/widgets/slider/slidertest.dart';

// OPTION A:
final simpleLocationBuilder = SimpleLocationBuilder(
  routes: {
    '/': (context, state) => BeamPage(
          key: const ValueKey('home'),
          title: 'Home',
          child: const MyHomePage(
            title: "test",
          ),
        ),
    '/feed': (context, state) => BeamPage(
          key: const ValueKey('feed'),
          title: 'feed',
          child: const FeedScreen(),
        ),

    '/error/feed': (context, state) => BeamPage(
          key: const ValueKey('error-feed'),
          title: 'feed',
          child: const ErrorFeed(),
        ),

    '/signup': (context, state) => BeamPage(
          key: const ValueKey('signup'),
          title: 'Who are you?',
          // child: const SignUpScreen(),
          child: const AuthScreen(
            isLoginInitial: false,
          ),
        ),

    '/login': (context, state) => BeamPage(
          key: const ValueKey('login'),
          title: 'Who are you?',
          // child: const LoginScreen(),
          child: const AuthScreen(
            isLoginInitial: true,
          ),
        ),

    '/changepassword': (context, state) => BeamPage(
          key: const ValueKey('update-password'),
          title: 'Change Password',
          child: const ChangePasswordScreen(),
        ),

    '/profile/:username': (context, state) {
      String username =
          (context.currentBeamLocation.state).pathParameters['username']!;

      return BeamPage(
        key: ValueKey('profile-$username'),
        title: 'Profile',
        child: ProfileScreen(
          username: username,
        ),
      );
    },

    '/subchannel/:subchannelname': (context, state) {
      String subchannelName =
          (context.currentBeamLocation.state).pathParameters['subchannelname']!;

      return BeamPage(
        key: ValueKey('subchannel-$subchannelName'),
        title: 'Subchannel',
        child: SubchannelScreen(
          subchannelName: subchannelName,
        ),
      );
    },

    //For extern calls
    '/whatch/:postId': (context, state) {
      String postId =
          (context.currentBeamLocation.state).pathParameters['postId']!;

      return BeamPage(
        key: ValueKey('videoplayer-$postId'),
        title: 'VideoPlayer',
        child: VideoPlayerScreen(
          postId: int.parse(postId),
          firtTimeExternAccess: true,
        ),
      );
    },

    //For intern calls
    '/whatchintern/:postId': (context, state) {
      String postId =
          (context.currentBeamLocation.state).pathParameters['postId']!;

      return BeamPage(
        key: ValueKey('videoplayer-$postId'),
        title: 'VideoPlayer',
        child: VideoPlayerScreen(
          postId: int.parse(postId),
          firtTimeExternAccess: false,
        ),
      );
    },

    '/createtag': (context, state) => BeamPage(
          key: const ValueKey('createtag'),
          title: 'createtag',
          child: const CreateTagLargeScreen(),
        ),

    'uploadvideo': (context, state) => BeamPage(
          key: const ValueKey('uploadvideotest'),
          type: BeamPageType.fadeTransition,
          title: 'uploadvideotest',
          child: const UploadVideoScreen(),
        ),

    'createsubchannel': (context, state) => BeamPage(
          key: const ValueKey('createsubchannel'),
          title: 'createsubchannel',
          child: const CreateSubchannelScreen(),
        ),

    'updateprofile': (context, state) => BeamPage(
          key: const ValueKey('updateProfile'),
          title: 'updateProfile',
          child: const UpdateProfileScreen(),
        ),

    'studio': (context, state) => BeamPage(
          key: const ValueKey('studio'),
          title: 'studio',
          child: const StudioScreen(),
        ),

    'submod/:subchannelname': (context, state) {
      String subchannelname =
          (context.currentBeamLocation.state).pathParameters['subchannelname']!;

      return BeamPage(
        key: const ValueKey('submod'),
        title: 'submod',
        child: SubMod(subchannelName: subchannelname),
      );
    },

    'slidertest': (context, state) => BeamPage(
          key: const ValueKey('slidertest'),
          title: 'slidertest',
          child: const Slidertest(),
        ),

    'search/:search': (context, state) {
      String search =
          (context.currentBeamLocation.state).pathParameters['search']!;

      if (search.isEmpty) {
        Beamer.of(context).beamToNamed('/feed');
      } else {
        return BeamPage(
          type: BeamPageType.fadeTransition,
          key: ValueKey('search-$search'),
          title: 'Search',
          child: SearchScreen(search: search),
        );
      }
    },

    // 'SliderXlider': (context, state) => BeamPage(
    //       key: const ValueKey('SliderXlider'),
    //       title: 'SliderXlider',
    //       child: SliderXlider(
    //         title: 'yo',
    //       ),
    //     ),

    // 'auth': (context, state) => BeamPage(
    //       key: const ValueKey('auth'),
    //       title: 'auth',
    //       child: const AuthScreen(
    //         isLoginInitial: false,
    //       ),
    //     ),

    // '/books/:bookId': (context, state) {
    //   final book = books.firstWhere((book) =>
    //       book['id'] ==
    //       (context.currentBeamLocation.state as BeamState)
    //           .pathParameters['bookId']);

    //   return BeamPage(
    //     key: ValueKey('book-${book['id']}'),
    //     title: book['title'],
    //     child: BookDetailsScreen(book: book),
    //   );
    // }
  },
);

// // OPTION B:
// final beamerLocationBuilder = BeamerLocationBuilder(
//   beamLocations: [
//     BooksLocation(),
//   ],
// );

// class BooksLocation extends BeamLocation<BeamState> {
//   BooksLocation({RouteInformation? routeInformation}) : super(routeInformation);

//   @override
//   List<String> get pathPatterns => [
//         '/',
//         '/books/:bookId',
//       ];

//   @override
//   List<BeamPage> buildPages(BuildContext context, BeamState state) {
//     return [
//       BeamPage(
//         key: ValueKey('home'),
//         title: 'Home',
//         child: HomeScreen(),
//       ),
//       if (state.uri.pathSegments.contains('books'))
//         BeamPage(
//           key: ValueKey('books'),
//           title: 'Books',
//           child: BooksScreen(),
//         ),
//       if (state.pathParameters.containsKey('bookId'))
//         BeamPage(
//           key: ValueKey('book-${state.pathParameters['bookId']}'),
//           title: books.firstWhere(
//               (book) => book['id'] == state.pathParameters['bookId'])['title'],
//           child: BookDetailsScreen(
//             book: books.firstWhere(
//                 (book) => book['id'] == state.pathParameters['bookId']),
//           ),
//         ),
//     ];
//   }
// }