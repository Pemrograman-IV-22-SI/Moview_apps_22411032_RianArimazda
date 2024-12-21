import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_apps/admin/home_admin.dart';
import 'package:movie_apps/api_service/api.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:toastification/toastification.dart';

class TransaksiAdmin extends StatefulWidget {
  const TransaksiAdmin({super.key});
  static String routeName = '/transaksi-admin';
  @override
  State<TransaksiAdmin> createState() => _TransaksiAdminState();
}

class _TransaksiAdminState extends State<TransaksiAdmin> {
  final dio = Dio();
  bool isloading = false;
  bool isloadingDelete = false;
  var dataTransaksiAdmin = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple,
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, HomeAdmin.routeName);
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
                itemCount: dataTransaksiAdmin.length,
                itemBuilder: (context, index) {
                  var transaksiAdmin = dataTransaksiAdmin[index];
                  var status =
                      transaksiAdmin['status']; // Ambil status dari data

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
                                  transaksiAdmin['movie']['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8), // Spasi antar teks
                                Text(
                                  "Harga Movie: Rp. ${transaksiAdmin['harga']}",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  "Jumlah Beli: ${transaksiAdmin['jumlah']}",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const Divider(
                                  color: Colors.white24,
                                  thickness: 1,
                                ),
                                Text(
                                  "Total: Rp. ${transaksiAdmin['total']}",
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
                          // Status dan tombol konfirmasi
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
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
                              const SizedBox(
                                  height: 10), // Spasi antara badge dan tombol
                              // Tombol Konfirmasi
                              ElevatedButton(
                                onPressed: () {
                                  QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.confirm,
                                      title: 'Konfirmasi Status',
                                      text:
                                          'Yakin ingin merubah status transaksi ?',
                                      confirmBtnText: 'Ya',
                                      cancelBtnText: 'Tidak',
                                      confirmBtnColor: Colors.red,
                                      onConfirmBtnTap: () {
                                        konfirmasiTransaksi(
                                            transaksiAdmin['transactionID']);
                                      });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue, // Warna tombol
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20), // Tombol bulat
                                  ),
                                ),
                                child: const Text(
                                  "Konfirmasi",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
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
      response = await dio.get(getAllTransaksi);
      if (response.data['status'] == true) {
        dataTransaksiAdmin = response.data['data'];
      } else {
        dataTransaksiAdmin = [];
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

  void konfirmasiTransaksi(int id) async {
    try {
      setState(() {
        isloading = true;
      });
      Response response;
      response = await dio.put(confirmTranskasi + id.toString());
      if (response.data['status'] == true) {
        toastification.show(
          context: context,
          title: Text(response.data['msg']),
          type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored,
        );
        Navigator.pushNamed(context, TransaksiAdmin.routeName);
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: const Text('Terjadi kesalahan pada server'),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
        style: ToastificationStyle.fillColored,
      );
      throw Exception('Error $e');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }
}
