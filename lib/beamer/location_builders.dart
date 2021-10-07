import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:uidraft1/main.dart';
import 'package:uidraft1/screens/feed/feed_screen.dart';



// OPTION A:
final simpleLocationBuilder = SimpleLocationBuilder(
  routes: {
    '/': (context, state) => BeamPage(
          key: const ValueKey('home'),
          title: 'Home',
          child: const MyHomePage(title: "test",),
        ),
    '/books': (context, state) => BeamPage(
          key: const ValueKey('books'),
          title: 'Books',
          child: const FeedScreen(),
        ),
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