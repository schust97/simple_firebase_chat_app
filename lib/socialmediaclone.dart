import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SocialmediaClone extends StatefulWidget {
  const SocialmediaClone({super.key});

  @override
  State<SocialmediaClone> createState() => _SocialmediaCloneState();
}

var passwordController = TextEditingController();
var emailController = TextEditingController();

Future signIn() async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: emailController.text,
    password: passwordController.text,
  );
}

@override
void dispose() {
  emailController.dispose();
  passwordController.dispose();
}

class _SocialmediaCloneState extends State<SocialmediaClone> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
          child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            Icon(Icons.apple),
            SizedBox(
              height: 10,
            ),
            Text("Myfav socialmedia"),
            TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: "email or username"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(hintText: "password"),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: signIn, child: Text("login")),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                child: Text("Register Nox"),
              ),
            )
          ]),
        ),
      )),
    );
  }
}
