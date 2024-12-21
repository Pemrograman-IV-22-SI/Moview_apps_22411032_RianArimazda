import 'package:flutter/material.dart';
import 'package:movie_apps/admin/admin_transaksi.dart';
import 'package:movie_apps/admin/home_admin.dart';
import 'package:movie_apps/auth/login_page.dart';
import 'package:movie_apps/auth/register_page.dart';
import 'package:movie_apps/genre/genre.dart';
import 'package:movie_apps/genre/input_genre.dart';
import 'package:movie_apps/genre/update_genre.dart';
import 'package:movie_apps/movie/input_movie.dart';
import 'package:movie_apps/movie/movie.dart';
import 'package:movie_apps/movie/update_movie.dart';
import 'package:movie_apps/users/beli_movie.dart';
import 'package:movie_apps/users/home_users.dart';
import 'package:movie_apps/users/transaksi.dart';
import 'package:toastification/toastification.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Apps',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        RegisterPage.routeName: (context) => const RegisterPage(),
        HomeAdmin.routeName: (context) => const HomeAdmin(),
        HomeUsers.routeName: (context) => const HomeUsers(),
        TransaksiAdmin.routeName: (context) => const TransaksiAdmin(),
        Genre.routeName: (context) => const Genre(),
        InputGenre.routeName: (context) => const InputGenre(),
        UpdateGenre.routeName: (context) => const UpdateGenre(),
        MoviePage.routeName: (context) => const MoviePage(),
        InputMovie.routeName: (context) => const InputMovie(),
        UpdateMoviePage.routeName: (context) => const UpdateMoviePage(),
        BeliMovie.routeName: (context) => const BeliMovie(),
        TransaksiUser.routeName: (context) => const TransaksiUser(),
      },
    ));
  }
}
