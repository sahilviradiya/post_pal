import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PostController extends GetxController {
  RxBool isLoading = false.obs;
  List<dynamic> posts = [];
  Map<int, RxInt> timers = {}; // Timer for each post
  Map<int, bool> readStatus = {}; // Read status for each posti 7338921400

  @override
  void onInit() {
    super.onInit();
    getAllPosts();
  }

  Future<void> getAllPosts() async {
    isLoading.value = true;
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if (response.statusCode == 200) {
        posts = jsonDecode(response.body);
        for (var post in posts) {
          final id = post['id'];
          timers[id] =
              RxInt(((10 + 5 * id % 3).toInt())); // Initialize random timer
          readStatus[id] = false; // Initially unread
        }
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void markAsRead(int postId) {
    readStatus[postId] = true;
    update(); // Triggers the Obx widget to rebuild
  }
}
