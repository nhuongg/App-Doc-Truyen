// lib/views/story_form_screen.dart
// Form thêm/sửa truyện

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/story_provider.dart';
import '../models/story.dart';

class StoryFormScreen extends StatefulWidget {
  final Story? story; // Null = thêm mới, có giá trị = chỉnh sửa

  const StoryFormScreen({super.key, this.story});

  @override
  State<StoryFormScreen> createState() => _StoryFormScreenState();
}

class _StoryFormScreenState extends State<StoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _contentController;

  bool _isLoading = false;

  bool get isEditing => widget.story != null;

  @override
  void initState() {
    super.initState();
    // Điền sẵn dữ liệu nếu đang chỉnh sửa
    _titleController = TextEditingController(text: widget.story?.title ?? '');
    _authorController = TextEditingController(text: widget.story?.author ?? '');
    _descriptionController = TextEditingController(
      text: widget.story?.description ?? '',
    );
    _contentController = TextEditingController(
      text: widget.story?.content ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // Xác thực không được để trống
  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập $fieldName';
    }
    return null;
  }

  // Lưu truyện
  Future<void> _saveStory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final storyProvider = Provider.of<StoryProvider>(context, listen: false);

    final story = Story(
      id: widget.story?.id,
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      description: _descriptionController.text.trim(),
      content: _contentController.text.trim(),
      isFavorite: widget.story?.isFavorite ?? false,
      createdAt: widget.story?.createdAt ?? DateTime.now(),
    );

    bool success;
    if (isEditing) {
      success = await storyProvider.updateStory(story);
    } else {
      success = await storyProvider.addStory(story);
    }

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing ? 'Đã cập nhật truyện' : 'Đã thêm truyện mới',
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(storyProvider.errorMessage ?? 'Đã xảy ra lỗi'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Chỉnh sửa truyện' : 'Thêm truyện mới'),
        actions: [
          TextButton.icon(
            onPressed: _isLoading ? null : _saveStory,
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: const Text('Lưu'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Tiêu đề
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Tiêu đề *',
                hintText: 'Nhập tiêu đề truyện',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) => _validateNotEmpty(value, 'tiêu đề'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Tác giả
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(
                labelText: 'Tác giả *',
                hintText: 'Nhập tên tác giả',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) => _validateNotEmpty(value, 'tên tác giả'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Mô tả
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Mô tả *',
                hintText: 'Mô tả ngắn về truyện',
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              validator: (value) => _validateNotEmpty(value, 'mô tả'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Nội dung
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Nội dung *',
                hintText: 'Nội dung truyện...',
                prefixIcon: Icon(Icons.article),
                alignLabelWithHint: true,
              ),
              maxLines: 10,
              validator: (value) => _validateNotEmpty(value, 'nội dung'),
            ),
            const SizedBox(height: 24),

            // Nút lưu
            FilledButton.icon(
              onPressed: _isLoading ? null : _saveStory,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(isEditing ? 'Cập nhật truyện' : 'Thêm truyện'),
            ),
          ],
        ),
      ),
    );
  }
}
