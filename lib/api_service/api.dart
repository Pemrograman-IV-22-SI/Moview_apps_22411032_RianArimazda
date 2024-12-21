String baseUrl = "http://192.168.56.1:3000";

String register = "$baseUrl/users/register";
String login = "$baseUrl/users/login";

// genre
String getAllGenre = "$baseUrl/genre/get";
String insert = "$baseUrl/genre/insert";
String hapusGenre = "$baseUrl/genre/delete/";
String editgenre = "$baseUrl/genre/edit/";

// image
String imageUrl = "$baseUrl/img/movie/";

// movie
String getAllMovie = "$baseUrl/movie/get";
String hapusMovie = "$baseUrl/movie/delete/";
String inputMovie = "$baseUrl/movie/insert";
String editMovie = "$baseUrl/movie/edit/";

// transaksi
String insertTransaksi = "$baseUrl/transaction/insert";
String getAllTransaksi = "$baseUrl/transaction/get-all";
String getTransaksiId = "$baseUrl/transaction/get/";
String confirmTranskasi = "$baseUrl/transaction/confirm-transaction/";
