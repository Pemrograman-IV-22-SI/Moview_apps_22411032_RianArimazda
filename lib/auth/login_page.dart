import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_apps/admin/home_admin.dart';
import 'package:movie_apps/api_service/api.dart';
import 'package:movie_apps/auth/register_page.dart';
import 'package:movie_apps/users/home_users.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String routeName = "/login-page";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final dio = Dio();
  bool isloding = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Image.asset(
                "assets/mobile.png",
                width: 150,
                height: 150,
              ),
              const SizedBox(
                height: 16,
              ),
              const Text("Login Akun!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                obscureText: true,
              ),
              const SizedBox(
                height: 16,
              ),
              isloding
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (usernameController.text.isEmpty &&
                            usernameController.text == '') {
                          toastification.show(
                              context: context,
                              title:
                                  const Text("Username Tidak Boleh Kosong !"),
                              type: ToastificationType.error,
                              autoCloseDuration: const Duration(seconds: 3),
                              style: ToastificationStyle.fillColored);
                        } else if (passwordController.text.isEmpty &&
                            passwordController.text == '') {
                          toastification.show(
                              context: context,
                              title:
                                  const Text("Passwprd Tidak Boleh Kosong !"),
                              type: ToastificationType.error,
                              autoCloseDuration: const Duration(seconds: 3),
                              style: ToastificationStyle.fillColored);
                        } else {
                          loginResponse();
                        }
                        ;
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          minimumSize: const Size.fromHeight(50)),
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      )),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Belum punya akun ?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterPage.routeName);
                      },
                      child: Text('Daftar disini'))
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  void loginResponse() async {
    try {
      setState(() {
        isloding = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.post(login, data: {
        "username": usernameController.text,
        "password": passwordController.text,
      });
      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        print(response.data['data']);
        var users = response.data['data'];
        if (users['role'] == 1) {
          Navigator.pushNamed(context, HomeAdmin.routeName, arguments: users);
        } else if (users['role'] == 2) {
          Navigator.pushNamed(context, HomeUsers.routeName, arguments: users);
        } else {
          toastification.show(
              context: context,
              title: Text(response.data['msg']),
              type: ToastificationType.error,
              autoCloseDuration: const Duration(seconds: 3),
              style: ToastificationStyle.fillColored);
        }
        ;
      }
    } catch (e) {
      toastification.show(
          context: context,
          title: const Text("Terjadi kesalah di Server"),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored);
    } finally {
      setState(() {
        isloding = false;
      });
    }
  }
}
