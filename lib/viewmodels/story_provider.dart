// lib/viewmodels/story_provider.dart
// Provider quản lý truyện với SQLite

import 'package:flutter/foundation.dart';
import '../models/story.dart';
import '../services/database_helper.dart';

class StoryProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Story> _stories = [];
  List<Story> _favorites = [];
  List<Story> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Story> get stories => _stories;
  List<Story> get favorites => _favorites;
  List<Story> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Tải tất cả truyện từ database
  Future<void> loadStories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _stories = await _dbHelper.getStories();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Không thể tải danh sách truyện.';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Tải danh sách yêu thích
  Future<void> loadFavorites() async {
    try {
      _favorites = await _dbHelper.getFavorites();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Không thể tải danh sách yêu thích.';
      notifyListeners();
    }
  }

  // Thêm truyện mới
  Future<bool> addStory(Story story) async {
    try {
      final id = await _dbHelper.insertStory(story);
      final newStory = story.copyWith(id: id);
      _stories.insert(0, newStory);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Không thể thêm truyện.';
      notifyListeners();
      return false;
    }
  }

  // Cập nhật truyện
  Future<bool> updateStory(Story story) async {
    try {
      await _dbHelper.updateStory(story);
      final index = _stories.indexWhere((s) => s.id == story.id);
      if (index != -1) {
        _stories[index] = story;
      }
      // Cập nhật trong favorites nếu có
      final favIndex = _favorites.indexWhere((s) => s.id == story.id);
      if (favIndex != -1) {
        if (story.isFavorite) {
          _favorites[favIndex] = story;
        } else {
          _favorites.removeAt(favIndex);
        }
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Không thể cập nhật truyện.';
      notifyListeners();
      return false;
    }
  }

  // Xóa truyện
  Future<bool> deleteStory(int id) async {
    try {
      await _dbHelper.deleteStory(id);
      _stories.removeWhere((story) => story.id == id);
      _favorites.removeWhere((story) => story.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Không thể xóa truyện.';
      notifyListeners();
      return false;
    }
  }

  // Toggle yêu thích
  Future<void> toggleFavorite(Story story) async {
    try {
      final newFavoriteStatus = !story.isFavorite;
      await _dbHelper.toggleFavorite(story.id!, newFavoriteStatus);

      // Cập nhật trong danh sách stories
      final index = _stories.indexWhere((s) => s.id == story.id);
      if (index != -1) {
        _stories[index] = story.copyWith(isFavorite: newFavoriteStatus);
      }

      // Cập nhật danh sách favorites
      if (newFavoriteStatus) {
        _favorites.add(story.copyWith(isFavorite: true));
      } else {
        _favorites.removeWhere((s) => s.id == story.id);
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Không thể cập nhật yêu thích.';
      notifyListeners();
    }
  }

  // Tìm kiếm truyện
  Future<void> searchStories(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    try {
      _searchResults = await _dbHelper.searchStories(query);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Không thể tìm kiếm.';
      notifyListeners();
    }
  }

  // Xóa kết quả tìm kiếm
  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  // Lấy truyện theo ID
  Story? getStoryById(int id) {
    try {
      return _stories.firstWhere((story) => story.id == id);
    } catch (e) {
      return null;
    }
  }

  // Xóa thông báo lỗi
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
