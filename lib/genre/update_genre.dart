import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_apps/api_service/api.dart';
import 'package:movie_apps/genre/genre.dart';
import 'package:toastification/toastification.dart';

class UpdateGenre extends StatefulWidget {
  const UpdateGenre({super.key});
  static String routeName = "/edit_genre";

  @override
  State<UpdateGenre> createState() => _UpdateGenreState();
}

class _UpdateGenreState extends State<UpdateGenre> {
  final dio = Dio();

  bool isloding = false;

  TextEditingController nameController = TextEditingController();
  String name = "";
  int? idGenre;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    name = args['name'];
    idGenre = args['idGenre'];
    if (nameController.text.isEmpty) {
      nameController.text = name;
    }
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
              const Text("Form Input Genre!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Jenis Genre",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 16,
              ),
              isloding
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isEmpty &&
                            nameController.text == '') {
                          toastification.show(
                              context: context,
                              title: const Text("Genre Tidak Boleh Kosong !"),
                              type: ToastificationType.error,
                              style: ToastificationStyle.fillColored);
                        } else {
                          UpdateGenreResponse(idGenre!, nameController.text);
                        }
                        ;
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          minimumSize: const Size.fromHeight(50)),
                      child: const Text(
                        "Input Genre",
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

  void UpdateGenreResponse(int idGenre, name) async {
    try {
      setState(() {
        isloding = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.put(editgenre + idGenre.toString(), data: {
        "name": name,
      });
      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        Navigator.pushNamed(context, Genre.routeName);
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
