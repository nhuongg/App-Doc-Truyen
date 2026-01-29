// lib/views/my_stories_screen.dart
// Màn hình quản lý truyện của người dùng (CRUD)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/story_provider.dart';
import '../models/story.dart';
import 'widgets/story_card.dart';
import 'story_form_screen.dart';
import 'story_detail_screen.dart';

class MyStoriesScreen extends StatelessWidget {
  const MyStoriesScreen({super.key});

  // Hiển thị hộp thoại xác nhận xóa
  Future<void> _showDeleteConfirmation(
    BuildContext context,
    Story story,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa truyện "${story.title}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await Provider.of<StoryProvider>(
        context,
        listen: false,
      ).deleteStory(story.id!);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Đã xóa truyện "${story.title}"'
                  : 'Không thể xóa truyện',
            ),
            backgroundColor: success
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Truyện Của Tôi')),
      body: Consumer<StoryProvider>(
        builder: (context, storyProvider, child) {
          final stories = storyProvider.stories;

          if (stories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_note_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Chưa có truyện nào',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nhấn nút + để thêm truyện mới',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              return Dismissible(
                key: Key('story_${story.id}'),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) async {
                  await _showDeleteConfirmation(context, story);
                  return false; // Không tự động dismiss
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Theme.of(context).colorScheme.error,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: StoryCard(
                  story: story,
                  showActions: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoryDetailScreen(story: story),
                      ),
                    );
                  },
                  onFavoriteToggle: () => storyProvider.toggleFavorite(story),
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoryFormScreen(story: story),
                      ),
                    );
                  },
                  onDelete: () => _showDeleteConfirmation(context, story),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StoryFormScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Thêm truyện'),
      ),
    );
  }
}
