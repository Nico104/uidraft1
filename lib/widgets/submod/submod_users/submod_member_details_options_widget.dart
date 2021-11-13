import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/custom_color_scheme.dart';

class SubModMemberOptions extends StatelessWidget {
  const SubModMemberOptions(
      {Key? key,
      required this.username,
      required this.subchannelName,
      required this.banUser,
      required this.makeUserSubchannelMod,
      required this.unbanUser,
      required this.removeUserSubchannelMod,
      required this.userRole})
      : super(key: key);

  final String username;
  final String subchannelName;
  final int userRole;
  final Future<void> Function() banUser;
  final Future<void> Function() makeUserSubchannelMod;
  final Future<void> Function() unbanUser;
  final Future<void> Function() removeUserSubchannelMod;

  @override
  Widget build(BuildContext context) {
    return getRightUserOptions(context);
  }

  Column getRightUserOptions(BuildContext context) {
    switch (userRole) {
      case 2:
        //Mod
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                side: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.brandColor),
              ),
              onPressed: () {
                removeUserSubchannelMod();
                banUser();
              },
              child: Text(
                'Ban',
                style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.brandColor),
              ),
            ),
            const SizedBox(height: 15),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                side: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.brandColor),
              ),
              onPressed: () {
                removeUserSubchannelMod();
              },
              child: Text(
                'Remove Mod',
                style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.brandColor),
              ),
            ),
            const SizedBox(height: 15),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                side: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.brandColor),
              ),
              onPressed: () {
                Beamer.of(context).beamToNamed('profile/' + username);
              },
              child: Text(
                'Show Profile',
                style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.brandColor),
              ),
            )
          ],
        );
      case 1:
        //Banned
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                side: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.brandColor),
              ),
              onPressed: () => unbanUser.call(),
              child: Text(
                'Unban',
                style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.brandColor),
              ),
            ),
            const SizedBox(height: 15),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                side: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.brandColor),
              ),
              onPressed: () async {
                await unbanUser();
                makeUserSubchannelMod();
              },
              child: Text(
                'Make Mod',
                style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.brandColor),
              ),
            ),
            const SizedBox(height: 15),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                side: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.brandColor),
              ),
              onPressed: () {
                Beamer.of(context).beamToNamed('profile/' + username);
              },
              child: Text(
                'Show Profile',
                style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.brandColor),
              ),
            )
          ],
        );
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                side: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.brandColor),
              ),
              onPressed: () => banUser.call(),
              child: Text(
                'Ban',
                style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.brandColor),
              ),
            ),
            const SizedBox(height: 15),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                side: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.brandColor),
              ),
              onPressed: () => makeUserSubchannelMod.call(),
              child: Text(
                'Make Mod',
                style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.brandColor),
              ),
            ),
            const SizedBox(height: 15),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                side: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.brandColor),
              ),
              onPressed: () {
                Beamer.of(context).beamToNamed('profile/' + username);
              },
              child: Text(
                'Show Profile',
                style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.brandColor),
              ),
            )
          ],
        );
    }
  }
}
