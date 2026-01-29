// lib/views/home_screen.dart
// Trang chủ hiển thị danh sách truyện và tìm kiếm

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/story_provider.dart';
import '../models/story.dart';
import 'widgets/story_card.dart';
import 'story_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    // Tải danh sách truyện khi khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StoryProvider>(context, listen: false).loadStories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final provider = Provider.of<StoryProvider>(context, listen: false);
    if (query.isEmpty) {
      provider.clearSearch();
    } else {
      provider.searchStories(query);
    }
  }

  void _navigateToDetail(Story story) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StoryDetailScreen(story: story)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm truyện...',
                  border: InputBorder.none,
                ),
                onChanged: _onSearch,
              )
            : const Text('Trang Chủ'),
        actions: [
          // Nút tìm kiếm
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  Provider.of<StoryProvider>(
                    context,
                    listen: false,
                  ).clearSearch();
                }
              });
            },
          ),
          // Nút chuyển đổi view
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: Consumer<StoryProvider>(
        builder: (context, storyProvider, child) {
          if (storyProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Lấy danh sách truyện (search results hoặc all stories)
          final stories = _searchController.text.isNotEmpty
              ? storyProvider.searchResults
              : storyProvider.stories;

          if (stories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _searchController.text.isNotEmpty
                        ? Icons.search_off
                        : Icons.library_books_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchController.text.isNotEmpty
                        ? 'Không tìm thấy truyện'
                        : 'Chưa có truyện nào',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          // Hiển thị dạng Grid hoặc List
          if (_isGridView) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                return StoryGridCard(
                  story: story,
                  onTap: () => _navigateToDetail(story),
                  onFavoriteToggle: () => storyProvider.toggleFavorite(story),
                );
              },
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              return StoryCard(
                story: story,
                onTap: () => _navigateToDetail(story),
                onFavoriteToggle: () => storyProvider.toggleFavorite(story),
              );
            },
          );
        },
      ),
    );
  }
}
