import 'package:flutter/material.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Test"),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: MaterialButton(
            onPressed: () => Navigator.of(context).pushNamed('/welcome'),
            color: Colors.blue,
            child: const Text("Welcome"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: MaterialButton(
            onPressed: () => Navigator.of(context).pushNamed('/signup'),
            color: Colors.blue,
            child: const Text("SignUp"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: MaterialButton(
            onPressed: () => Navigator.of(context).pushNamed('/login'),
            color: Colors.blue,
            child: const Text("Login"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: MaterialButton(
            onPressed: () => Navigator.of(context).pushNamed('/uploadvideo'),
            color: Colors.blue,
            child: const Text("Upload"),
          ),
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(300);
}
