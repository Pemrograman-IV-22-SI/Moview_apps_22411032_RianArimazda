import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_apps/admin/model/genre_model.dart';
import 'package:movie_apps/api_service/api.dart';
import 'package:movie_apps/movie/movie.dart';
import 'package:toastification/toastification.dart';

class UpdateMoviePage extends StatefulWidget {
  const UpdateMoviePage({super.key});

  static String routeName = "/edit-movie";

  @override
  State<UpdateMoviePage> createState() => _UpdateMoviePageState();
}

class _UpdateMoviePageState extends State<UpdateMoviePage> {
  final dio = Dio();
  bool isLoading = false;

  int? idGenre;
  String? genre;

  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  GenreModel? _selectedGenre;

  Future<List<GenreModel>> getData() async {
    try {
      Response response;

      response = await dio.get(getAllGenre);

      final data = response.data["data"];
      if (data != null) {
        return GenreModel.fromJsonList(data);
      } else {}
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
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
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    int idMovie = args["idMovie"];
    String title = args["title"];
    String price = args["price"].toString();
    String rating = args["rating"].toString();
    String description = args["description"];
    genre = args["genre_movie_genreTogenre"]["name"].toString();
    _selectedGenre =
        _selectedGenre ?? GenreModel.fromJson(args["genre_movie_genreTogenre"]);

    if (titleController.text.isEmpty ||
        priceController.text.isEmpty ||
        ratingController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      titleController.text = title;
      priceController.text = price;
      ratingController.text = rating;
      descriptionController.text = description;
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Input Movie',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.cyan,
      ),
      backgroundColor: const Color(0xFF232429),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Movie',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 24),
              ),
              Text(
                'Silakan edit data movie.',
                style: TextStyle(
                    color: Colors.grey[400], fontWeight: FontWeight.w100),
              ),
              const SizedBox(
                height: 24,
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: const OutlineInputBorder(),
                  focusColor: Colors.cyan,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: const OutlineInputBorder(),
                  focusColor: Colors.cyan,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: ratingController,
                decoration: InputDecoration(
                  labelText: 'Rating',
                  border: const OutlineInputBorder(),
                  focusColor: Colors.cyan,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: const OutlineInputBorder(),
                  focusColor: Colors.cyan,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.multiline,
                maxLines: null,
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
                  var text = _selectedGenre == null
                      ? genre.toString()
                      : _selectedGenre!.name;
                  return Text(
                    text,
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
                      backgroundColor: Colors.cyan,
                      minimumSize: const Size.fromHeight(50)),
                  child: const Text(
                    'Pilih Gambar',
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                height: 16,
              ),
              _imageBytes != null
                  ? Center(
                      child: Image.memory(
                        _imageBytes!,
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: Image.network("$imageUrl${args["image"]}",
                          width: 300, height: 300, fit: BoxFit.cover),
                    ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 46,
                    width: 100,
                    child: isLoading
                        ? const SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              if (priceController.text.isEmpty) {
                                toastification.show(
                                    context: context,
                                    title:
                                        const Text('Price Tidak Boleh Kosong!'),
                                    type: ToastificationType.error,
                                    autoCloseDuration:
                                        const Duration(seconds: 3),
                                    style: ToastificationStyle.fillColored);
                              } else if (ratingController.text.isEmpty) {
                                toastification.show(
                                    context: context,
                                    title: const Text(
                                        'Rating Tidak Boleh Kosong!'),
                                    type: ToastificationType.error,
                                    autoCloseDuration:
                                        const Duration(seconds: 3),
                                    style: ToastificationStyle.fillColored);
                              } else {
                                updateMovieResponse(idMovie);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.cyan,
                                minimumSize: const Size.fromHeight(50)),
                            child: const Text(
                              'Simpan',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateMovieResponse(idMovie) async {
    try {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      var imgData = _imageBytes != null
          ? MultipartFile.fromBytes(_imageBytes!, filename: 'image.jpg')
          : null;

      FormData formData = FormData.fromMap({
        "image": imgData,
        "title": titleController.text,
        "price": priceController.text,
        "rating": ratingController.text,
        "description": descriptionController.text,
        "genre": _selectedGenre?.idGenre,
      });

      Response response;

      response = await dio.put("$editMovie$idMovie", data: formData);

      if (response.data["status"]) {
        toastification.show(
            title: Text(response.data['msg']),
            autoCloseDuration: const Duration(seconds: 3),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored);

        Navigator.pushNamed(context, MoviePage.routeName);
      } else {
        toastification.show(
            title: Text(response.data['msg']),
            autoCloseDuration: const Duration(seconds: 3),
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored);
      }
    } catch (e) {
      toastification.show(
          title: const Text("Terjadi kesalahan pada server"),
          autoCloseDuration: const Duration(seconds: 3),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
