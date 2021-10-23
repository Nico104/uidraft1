import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:uidraft1/admin%20tools/create_tag.dart';
import 'package:uidraft1/error/error_feed_widget.dart';
import 'package:uidraft1/main.dart';
import 'package:uidraft1/screens/auth/auth_screen.dart';
import 'package:uidraft1/screens/feed/feed_screen.dart';
import 'package:uidraft1/screens/profile/create/create_profile_screen.dart';
import 'package:uidraft1/screens/profile/profile_screen.dart';
import 'package:uidraft1/screens/subchannel/create/create_subchannel_screen.dart';
import 'package:uidraft1/screens/subchannel/subchannel_screen.dart';
import 'package:uidraft1/screens/uploadVideo/upload_video_screen.dart';
import 'package:uidraft1/screens/videoplayer/videoplayer_screen.dart';

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

    '/profile': (context, state) => BeamPage(
          key: const ValueKey('profile'),
          title: 'Profile',
          child: const ProfileScreen(),
        ),

    '/subchannel': (context, state) => BeamPage(
          key: const ValueKey('subchannel'),
          title: 'Subchannel',
          child: const SubchannelScreen(),
        ),

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

    'uploadvideotest': (context, state) => BeamPage(
          key: const ValueKey('uploadvideotest'),
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