import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_apps/api_service/api.dart';
import 'package:movie_apps/users/home_users.dart';
import 'package:toastification/toastification.dart';

class TransaksiUser extends StatefulWidget {
  const TransaksiUser({super.key});
  static String routeName = '/transaksi-user';
  @override
  State<TransaksiUser> createState() => _TransaksiUserState();
}

class _TransaksiUserState extends State<TransaksiUser> {
  final dio = Dio();
  bool isloading = false;
  bool isloadingDelete = false;
  var dataTransaksiUser = [];
  String? idUser;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    idUser = args['username'];
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple,
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, HomeUsers.routeName,
                      arguments: args);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const Text('Transaksi', style: TextStyle(color: Colors.white))
            ],
          ),
        ),
        backgroundColor: const Color(0xFF232429),
        body: isloading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: dataTransaksiUser.length,
                itemBuilder: (context, index) {
                  var transaksiUser = dataTransaksiUser[index];
                  var status =
                      transaksiUser['status']; // Ambil status dari data

                  return Card(
                    color: Colors.grey[900], // Warna latar belakang card
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(15), // Padding di dalam card
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Ikon di sebelah kiri
                          const Icon(
                            Icons.movie,
                            color: Colors.white,
                            size: 40,
                          ),
                          const SizedBox(
                              width: 15), // Spasi antara ikon dan teks
                          // Informasi transaksi
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaksiUser['movie']['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8), // Spasi antar teks
                                Text(
                                  "Harga Movie: Rp. ${transaksiUser['harga']}",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  "Jumlah Beli: ${transaksiUser['jumlah']}",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const Divider(
                                  color: Colors.white24,
                                  thickness: 1,
                                ),
                                Text(
                                  "Total: Rp. ${transaksiUser['total']}",
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Spasi antara teks dan badge
                          // Badge status
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: status == 1
                                  ? Colors.red
                                  : Colors.green, // Warna badge
                              borderRadius:
                                  BorderRadius.circular(20), // Badge bulat
                            ),
                            child: Text(
                              status == 1 ? "Belum Lunas" : "Lunas",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ));
  }

  void getData() async {
    try {
      setState(() {
        isloading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.get(getTransaksiId + idUser.toString());
      if (response.data['status'] == true) {
        dataTransaksiUser = response.data['data'];
      } else {
        dataTransaksiUser = [];
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: const Text('Server tidak meresponse'),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
        style: ToastificationStyle.fillColored,
      );
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }
}
