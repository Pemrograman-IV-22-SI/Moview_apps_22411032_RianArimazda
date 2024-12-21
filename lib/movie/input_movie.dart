import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_apps/admin/model/genre_model.dart';
import 'package:movie_apps/api_service/api.dart';
import 'package:movie_apps/movie/movie.dart';
import 'package:toastification/toastification.dart';
import 'package:dropdown_search/dropdown_search.dart';

class InputMovie extends StatefulWidget {
  const InputMovie({super.key});
  static const routeName = '/input-movie';

  @override
  State<InputMovie> createState() => _InputMovieState();
}

class _InputMovieState extends State<InputMovie> {
  final dio = Dio();

  int? idGenre;

  bool isloding = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  GenreModel? _selectedGenre;

  Future<List<GenreModel>> getData() async {
    try {
      var response = await Dio().get(getAllGenre);
      final data = response.data["data"];
      if (data != null) {
        return GenreModel.fromJsonList(data);
      }
    } catch (e) {
      throw Exception('Terjadi Kesalahan: $e');
    }
    return [];
  }

  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();
        setState(() {
          _imageBytes = imageBytes;
        });
      }
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
              const Text("Form Input Movie!",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
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
                controller: ratingController,
                decoration: const InputDecoration(
                  labelText: "Rating",
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
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Desc",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.white),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 16,
              ),
              const SizedBox(
                height: 16,
              ),
              DropdownSearch<GenreModel>(
                popupProps: PopupProps.dialog(
                  itemBuilder:
                      (BuildContext context, GenreModel item, bool isDisabled) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListTile(
                        title: Text(item.name),
                        leading: CircleAvatar(child: Text(item.name[0])),
                      ),
                    );
                  },
                  showSearchBox: true,
                  searchFieldProps: const TextFieldProps(
                    decoration: InputDecoration(
                      hintText: "Search Genre...",
                    ),
                  ),
                ),
                asyncItems: (String? filter) => getData(),
                itemAsString: (GenreModel? item) => item?.userAsString() ?? "",
                onChanged: (GenreModel? data) {
                  setState(() {
                    _selectedGenre = data;
                    idGenre = data?.idGenre;
                  });
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Select Genre",
                    hintStyle: TextStyle(color: Colors.white),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
                selectedItem: _selectedGenre,
                dropdownBuilder:
                    (BuildContext context, GenreModel? selectedItem) {
                  return Text(
                    selectedItem?.name ?? "Select Genre",
                    style: const TextStyle(
                      color: Colors.white, // Warna teks yang dipilih
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () {
                    pickImage();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size.fromHeight(50)),
                  child: Text(
                    "Pilih Gambar",
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                height: 16,
              ),
              _imageBytes != null
                  ? Image.memory(
                      _imageBytes!,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    )
                  : const Text(
                      'Tidak ada gambar yang dipilih',
                      style: TextStyle(color: Colors.white),
                    ),
              const SizedBox(
                height: 32,
              ),
              isloding
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        inputMovieResponse();
                        // if (titleController.text.isEmpty &&
                        //     titleController.text == '') {
                        //   toastification.show(
                        //       context: context,
                        //       title: const Text("Title Tidak Boleh Kosong !"),
                        //       type: ToastificationType.error,
                        //       style: ToastificationStyle.fillColored);
                        // } else {
                        //   registerResponse();
                        // }
                        // ;
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          minimumSize: const Size.fromHeight(50)),
                      child: const Text(
                        "Input Movie",
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

  void registerResponse() async {
    try {
      setState(() {
        isloding = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.post(insert, data: {
        "name": titleController.text,
      });
      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        Navigator.pushNamed(context, MoviePage.routeName);
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

  void inputMovieResponse() async {
    try {
      setState(() {
        isloding = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      FormData formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(_imageBytes!, filename: 'test.jpgr'),
        "title": titleController.text,
        "price": priceController.text,
        "genre": idGenre.toString(),
        "rating": ratingController.text,
        "description": descriptionController.text,
      });
      Response response;
      response = await dio.post(inputMovie, data: formData);
      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        Navigator.pushNamed(context, MoviePage.routeName);
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
