import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_apps/api_service/api.dart';
import 'package:movie_apps/users/home_users.dart';
import 'package:toastification/toastification.dart';

class BeliMovie extends StatefulWidget {
  const BeliMovie({super.key});
  static String routeName = '/beli-movie';

  @override
  State<BeliMovie> createState() => _BeliMovieState();
}

class _BeliMovieState extends State<BeliMovie> {
  final dio = Dio();
  bool isloading = false;
  var total = 0.0;
  String? userID;
  int? movieid;
  var user;

  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController jumlahbeliController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    titleController.text = args['movie']['title'];
    priceController.text = args['movie']['price'].toString();
    movieid = args['movie']['idMovie'];
    userID = args['user']['username'];
    user = args['user'];

    return Scaffold(
      backgroundColor: const Color(0xFF232429),
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
              const Text("Form Beli Movie!",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Image.network('$imageUrl/${args['movie']['image']}',
                  width: 200, height: 200, fit: BoxFit.cover),
              const SizedBox(
                height: 32,
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  enabled: false,
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.white),
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: "Price",
                  enabled: false,
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.white),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: jumlahbeliController,
                decoration: const InputDecoration(
                  labelText: "Jumlah Beli",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.white),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      total = double.parse(priceController.text) *
                          double.parse(value);
                      totalController.text = total.toString();
                    } else {
                      total = 0.0;
                      totalController.text = total.toString();
                    }
                  });
                },
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: totalController,
                decoration: const InputDecoration(
                  labelText: "Total",
                  enabled: false,
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.white),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 16,
              ),
              isloading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (jumlahbeliController.text.isEmpty &&
                            jumlahbeliController.text == '') {
                          toastification.show(
                              context: context,
                              title: const Text(
                                  "Jumlah beli tidak boleh kosong !"),
                              autoCloseDuration: const Duration(seconds: 3),
                              type: ToastificationType.error,
                              style: ToastificationStyle.fillColored);
                        } else {
                          responseTransaksi();
                        }
                        ;
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          minimumSize: const Size.fromHeight(50)),
                      child: const Text(
                        "Beli Movie",
                        style: TextStyle(color: Colors.white),
                      )),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      )),
    );
  }

  void responseTransaksi() async {
    try {
      setState(() {
        isloading = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.post(insertTransaksi, data: {
        "userID": userID,
        "movieID": movieid,
        "harga": priceController.text,
        "jumlah": jumlahbeliController.text,
        "total": totalController.text
      });
      if (response.data['status'] == true)
        toastification.show(
            context: context,
            title: Text(response.data["msg"]),
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
      Navigator.pushNamed(context, HomeUsers.routeName, arguments: user);
    } catch (e) {
      toastification.show(
          context: context,
          title: const Text("Terjadi kesalahan pada server"),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored);
    } finally {
      isloading = false;
    }
  }
}
