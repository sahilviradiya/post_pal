import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/posts_controller.dart';
import 'post_detail_screen.dart';

class PostListScreen extends StatelessWidget {
  final PostController controller = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Posts')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: controller.posts.length,
            itemBuilder: (context, index) {
              final post = controller.posts[index];
              final postId = post['id'];
              final isRead = controller.readStatus[postId] ?? false;
              final timerValue = controller.timers[postId]?.value ?? 0;

              return GestureDetector(
                onTap: () async {
                  // Navigate to details and mark as read
                  await Get.to(() => PostDetailScreen(postId: postId));
                  controller.markAsRead(postId); // Mark as read
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: isRead ? Colors.white : Colors.yellow[100],
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(post['title'],
                              style: const TextStyle(fontSize: 16)),
                        ),
                        Column(
                          children: [
                            const Icon(Icons.timer, size: 20),
                            Text('$timerValue sec',
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
