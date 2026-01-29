// lib/views/reading_screen.dart
// Màn hình đọc truyện

import 'package:flutter/material.dart';
import '../models/story.dart';

class ReadingScreen extends StatefulWidget {
  final Story story;

  const ReadingScreen({super.key, required this.story});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  double _fontSize = 18.0;
  bool _showControls = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _increaseFontSize() {
    if (_fontSize < 28) {
      setState(() => _fontSize += 2);
    }
  }

  void _decreaseFontSize() {
    if (_fontSize > 12) {
      setState(() => _fontSize -= 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showControls
          ? AppBar(
              title: Text(
                widget.story.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                // Nút giảm cỡ chữ
                IconButton(
                  onPressed: _decreaseFontSize,
                  icon: const Icon(Icons.text_decrease),
                  tooltip: 'Giảm cỡ chữ',
                ),
                // Hiển thị cỡ chữ hiện tại
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_fontSize.toInt()}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Nút tăng cỡ chữ
                IconButton(
                  onPressed: _increaseFontSize,
                  icon: const Icon(Icons.text_increase),
                  tooltip: 'Tăng cỡ chữ',
                ),
              ],
            )
          : null,
      body: GestureDetector(
        onTap: () {
          setState(() => _showControls = !_showControls);
        },
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: _showControls ? 16 : 50,
              bottom: 100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề
                Text(
                  widget.story.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Tác giả
                Text(
                  'Tác giả: ${widget.story.author}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                // Nội dung truyện
                SelectableText(
                  widget.story.content,
                  style: TextStyle(
                    fontSize: _fontSize,
                    height: 1.8,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                // Kết thúc
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.auto_stories,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '~ Hết ~',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Nút quay về đầu
      floatingActionButton:
          _scrollController.hasClients && _scrollController.offset > 200
          ? FloatingActionButton.small(
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              },
              child: const Icon(Icons.arrow_upward),
            )
          : null,
    );
  }
}
