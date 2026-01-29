// lib/services/database_helper.dart
// Singleton class để quản lý cơ sở dữ liệu SQLite

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/story.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Singleton pattern
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  // Lấy instance của database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Khởi tạo database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'stories_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Tạo bảng stories
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE stories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        description TEXT NOT NULL,
        content TEXT NOT NULL,
        is_favorite INTEGER DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    // Thêm dữ liệu mẫu
    await _insertSampleData(db);
  }

  // Thêm dữ liệu mẫu vào database
  Future<void> _insertSampleData(Database db) async {
    final sampleStories = [
      {
        'title': 'Truyện Kiều',
        'author': 'Nguyễn Du',
        'description':
            'Truyện Kiều là một tác phẩm thơ nổi tiếng của Nguyễn Du, được viết bằng chữ Nôm theo thể lục bát, dựa trên cốt truyện của Kim Vân Kiều Truyện.',
        'content': '''Trăm năm trong cõi người ta,
Chữ tài chữ mệnh khéo là ghét nhau.
Trải qua một cuộc bể dâu,
Những điều trông thấy mà đau đớn lòng.

Lạ gì bỉ sắc tư phong,
Trời xanh quen thói má hồng đánh ghen.
Cảo thơm lần giở trước đèn,
Phong tình cổ lục còn truyền sử xanh.

Rằng năm Gia Tĩnh triều Minh,
Bốn phương phẳng lặng hai kinh vững vàng.
Có nhà viên ngoại họ Vương,
Gia tư nghĩ cũng thường thường bậc trung.

Một trai con thứ rốt lòng,
Vương Quan là chữ nối dòng nho gia.
Đầu lòng hai ả tố nga,
Thúy Kiều là chị em là Thúy Vân.

Mai cốt cách tuyết tinh thần,
Mỗi người một vẻ mười phân vẹn mười.
Vân xem trang trọng khác vời,
Khuôn trăng đầy đặn nét ngài nở nang.

Hoa cười ngọc thốt đoan trang,
Mây thua nước tóc tuyết nhường màu da.
Kiều càng sắc sảo mặn mà,
So bề tài sắc lại là phần hơn.''',
        'is_favorite': 1,
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Tắt Đèn',
        'author': 'Ngô Tất Tố',
        'description':
            'Tắt Đèn là tiểu thuyết của nhà văn Ngô Tất Tố, phản ánh cuộc sống cơ cực của người nông dân Việt Nam trước Cách mạng tháng Tám.',
        'content':
            '''Chị Dậu là một người phụ nữ nông dân nghèo khổ, chồng chị bị ốm nặng. Nhà chị nợ thuế, quan lại đến đòi thuế. Chị phải bán con, bán chó để nộp thuế cho chồng.

Mặc dù đã bán hết tài sản, chị vẫn không đủ tiền nộp thuế. Khi quan lại đến bắt chồng chị, chị Dậu đã vùng lên chống trả để bảo vệ chồng.

Đây là một trong những tác phẩm văn học tiêu biểu phản ánh nỗi thống khổ của người nông dân Việt Nam dưới ách áp bức phong kiến và thực dân.

Tác phẩm đã trở thành một tiếng nói mạnh mẽ tố cáo chế độ thực dân phong kiến và ca ngợi tinh thần đấu tranh của người nông dân.''',
        'is_favorite': 0,
        'created_at': DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
      },
      {
        'title': 'Chí Phèo',
        'author': 'Nam Cao',
        'description':
            'Chí Phèo là một truyện ngắn nổi tiếng của nhà văn Nam Cao, kể về cuộc đời bi thảm của một người nông dân bị xã hội đẩy vào con đường tha hóa.',
        'content':
            '''Hắn vừa đi vừa chửi. Bao giờ cũng thế, cứ rượu xong là hắn chửi. Bắt đầu hắn chửi trời. Có hề gì? Trời có của riêng nhà nào? Rồi hắn chửi đời. Thế cũng chẳng sao: Đời là tất cả nhưng cũng chẳng là ai. Tức mình, hắn chửi ngay tất cả làng Vũ Đại.

Nhưng cả làng Vũ Đại ai cũng nhủ: "Chắc nó trừ mình ra!". Không ai lên tiếng cả. Tức thật! Ờ! Thế này thì tức thật! Tức chết đi được mất! Đã thế, hắn phải chửi cha đứa nào không chửi nhau với hắn. Nhưng cũng không ai ra điều. Mẹ kiếp! Thế có phí rượu không?

Chí Phèo nguyên là một đứa trẻ mồ côi, bị bỏ rơi ở lò gạch cũ. Hắn lớn lên nhờ sự đùm bọc của dân làng, làm canh điền cho Bá Kiến. Vì ghen tuông, Bá Kiến đẩy hắn vào tù. Ra tù, hắn trở thành kẻ say rượu và phá phách.

Cuối cùng, hắn gặp Thị Nở - người đàn bà xấu xí nhưng đã đánh thức lại tính người trong hắn. Nhưng xã hội không cho hắn cơ hội làm lại cuộc đời...''',
        'is_favorite': 1,
        'created_at': DateTime.now()
            .subtract(const Duration(days: 2))
            .toIso8601String(),
      },
      {
        'title': 'Lão Hạc',
        'author': 'Nam Cao',
        'description':
            'Lão Hạc là truyện ngắn của Nam Cao, kể về số phận bi thương của một người nông dân nghèo và lòng tự trọng cao quý của ông.',
        'content':
            '''Lão Hạc là một người nông dân nghèo, góa vợ, có một người con trai đi làm ăn xa. Tài sản của lão chỉ có mảnh vườn nhỏ và con chó vàng - kỷ vật của con trai.

Vì hoàn cảnh túng quẫn, lão phải bán con chó yêu quý. Sau khi bán chó, lão đau khổ vô cùng, tự trách mình đã lừa một con chó.

Lão gửi tiền bán chó và mảnh vườn cho ông giáo để giữ cho con. Cuối cùng, lão ăn bả chó tự tử để không phải tiêu vào phần của con.

Cái chết của lão Hạc là tiếng kêu thương về số phận người nông dân nghèo khổ, đồng thời ca ngợi phẩm chất cao đẹp, lòng tự trọng và tình yêu thương con của người cha.''',
        'is_favorite': 0,
        'created_at': DateTime.now()
            .subtract(const Duration(days: 3))
            .toIso8601String(),
      },
      {
        'title': 'Dế Mèn Phiêu Lưu Ký',
        'author': 'Tô Hoài',
        'description':
            'Dế Mèn phiêu lưu ký là tác phẩm văn học thiếu nhi nổi tiếng của nhà văn Tô Hoài, kể về cuộc phiêu lưu của chú Dế Mèn.',
        'content':
            '''Tôi sống độc lập từ thuở bé. Trước kia, ở với mẹ, tôi đã quen nghe tiếng mẹ tôi kể chuyện: "Ngày xửa ngày xưa..." Bây giờ, tôi sống một mình, tôi cũng hay nghĩ đến chuyện ngày xưa ấy.

Tôi là một chàng dế thanh niên cường tráng. Đôi càng tôi mẫm bóng. Những cái vuốt ở chân, ở khuỷu cứ cứng dần lên và nhọn hoắt. Thỉnh thoảng tôi co cẳng lên, đạp thử. Chiếc ghế bành, chẳng hạn, thì tôi đạp tành tành nghe vui tai lắm.

Tôi đi phiêu lưu với người bạn thân Dế Trũi. Chúng tôi đã gặp biết bao nhiêu chuyện thú vị, đã quen biết bao nhiêu người bạn mới. Cuộc sống thật là phong phú và đầy màu sắc!

Qua những cuộc phiêu lưu, tôi học được bài học về tình bạn, về lòng dũng cảm và về ý nghĩa của cuộc sống.''',
        'is_favorite': 1,
        'created_at': DateTime.now()
            .subtract(const Duration(days: 4))
            .toIso8601String(),
      },
    ];

    for (var story in sampleStories) {
      await db.insert('stories', story);
    }
  }

  // ==================== CRUD Operations ====================

  // CREATE - Thêm truyện mới
  Future<int> insertStory(Story story) async {
    final db = await database;
    return await db.insert('stories', story.toMap());
  }

  // READ - Lấy tất cả truyện
  Future<List<Story>> getStories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'stories',
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) => Story.fromMap(maps[i]));
  }

  // READ - Lấy truyện theo ID
  Future<Story?> getStoryById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'stories',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Story.fromMap(maps.first);
    }
    return null;
  }

  // UPDATE - Cập nhật truyện
  Future<int> updateStory(Story story) async {
    final db = await database;
    return await db.update(
      'stories',
      story.toMap(),
      where: 'id = ?',
      whereArgs: [story.id],
    );
  }

  // DELETE - Xóa truyện
  Future<int> deleteStory(int id) async {
    final db = await database;
    return await db.delete('stories', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== Favorites ====================

  // Toggle trạng thái yêu thích
  Future<int> toggleFavorite(int id, bool isFavorite) async {
    final db = await database;
    return await db.update(
      'stories',
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Lấy danh sách truyện yêu thích
  Future<List<Story>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'stories',
      where: 'is_favorite = ?',
      whereArgs: [1],
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) => Story.fromMap(maps[i]));
  }

  // ==================== Search ====================

  // Tìm kiếm truyện theo tên
  Future<List<Story>> searchStories(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'stories',
      where: 'title LIKE ? OR author LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) => Story.fromMap(maps[i]));
  }

  // Đóng database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
