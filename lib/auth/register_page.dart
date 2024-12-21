import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_apps/api_service/api.dart';
import 'package:movie_apps/auth/login_page.dart';
import 'package:toastification/toastification.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static String routeName = "/register-page";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final dio = Dio();

  bool isloding = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
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
              const Text("Registrasi Akun!",
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
                controller: fullnameController,
                decoration: const InputDecoration(
                  labelText: "Fullname",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "No Telphone",
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
                              style: ToastificationStyle.fillColored);
                        } else if (fullnameController.text.isEmpty &&
                            fullnameController.text == '') {
                          toastification.show(
                              context: context,
                              title:
                                  const Text("Fullname Tidak Boleh Kosong !"),
                              type: ToastificationType.error,
                              style: ToastificationStyle.fillColored);
                        } else if (emailController.text.isEmpty &&
                            emailController.text == '') {
                          toastification.show(
                              context: context,
                              title: const Text("Email Tidak Boleh Kosong !"),
                              type: ToastificationType.error,
                              style: ToastificationStyle.fillColored);
                        } else if (phoneController.text.isEmpty &&
                            phoneController.text == '') {
                          toastification.show(
                              context: context,
                              title: const Text(
                                  "No Telephone Tidak Boleh Kosong !"),
                              type: ToastificationType.error,
                              style: ToastificationStyle.fillColored);
                        } else if (passwordController.text.isEmpty &&
                            passwordController.text == '') {
                          toastification.show(
                              context: context,
                              title:
                                  const Text("Password Tidak Boleh Kosong !"),
                              type: ToastificationType.error,
                              style: ToastificationStyle.fillColored);
                        } else {
                          registerResponse();
                        }
                        ;
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          minimumSize: const Size.fromHeight(50)),
                      child: const Text(
                        "Registrasi",
                        style: TextStyle(color: Colors.white),
                      )),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Sudah punya akun ?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginPage.routeName);
                      },
                      child: Text('Masuk disini'))
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  void registerResponse() async {
    try {
      setState(() {
        isloding = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.post(register, data: {
        "username": usernameController.text,
        "fullname": fullnameController.text,
        "email": emailController.text,
        "noTelp": phoneController.text,
        "password": passwordController.text,
      });
      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        Navigator.pushNamed(context, LoginPage.routeName);
      } else {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.error,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
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
