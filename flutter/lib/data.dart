class Category {
  final int id;
  final String title;
  final String imageFileName;

  Category(
      {required this.id, required this.title, required this.imageFileName});
}

// 文章对象类定义
class Article {
  final int articleID;
  final String title;
  final String subtitle;
  final String? cover;//封面图可以为空
  final int id;
  final int categoryID;
  int likes;
  final String content;
  final String createdAt;
  final String updatedAt;
  final int deleted;

  Article({
    required this.articleID,
    required this.title,
    required this.subtitle,
    this.cover,
    required this.id,
    required this.categoryID,
    required this.likes,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
  });

  // 解析 JSON 数据为文章对象
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      articleID: json['articleID'],
      title: json['title'],
      subtitle: json['subtitle'],
      cover: json['cover'],
      id: json['id'],
      categoryID: json['categoryId'],
      likes: json['likes'],
      content: json['content'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deleted: json['deleted'],
    );
  }
}
class PostData {
  final int id;
  final String caption;
  final String title;
  final String likes;
  final String time;
  final bool isBookmarked;
  final String imageFileName;

  PostData(
      {required this.id,
      required this.caption,
      required this.title,
      required this.likes,
      required this.time,
      required this.isBookmarked,
      required this.imageFileName});
}

class AppData{
  static List<Category> get categories {
    return [
      Category(
          id: 103, title: '生活', imageFileName: 'large_post_3.jpg'),
      Category(id: 102, title: '娱乐', imageFileName: 'large_post_2.jpg'),
      Category(id: 104, title: '旅行', imageFileName: 'large_post_4.jpg'),
      Category(
        id: 101,
        title: '科技',
        imageFileName: 'large_post_1.jpg',
      ),
      Category(
          id: 105,
          title: '互联网',
          imageFileName: 'large_post_5.jpg'),
      Category(id: 106, title: '经济', imageFileName: 'large_post_6.jpg'),
    ];
  }

  static List<PostData> get posts {
    return [
      PostData(
          id: 1,
          title: 'BMW M5 Competition Review 2021',
          caption: 'TOP GEAR',
          isBookmarked: false,
          likes: '3.1k',
          time: '1hr ago',
          imageFileName: 'small_post_1.jpg'),
      PostData(
          id: 0,
          title: 'MacBook Pro with M1 Pro and M1 Max review',
          caption: 'THE VERGE',
          isBookmarked: false,
          likes: '1.2k',
          time: '2hr ago',
          imageFileName: 'small_post_2.jpg'),
      PostData(
          id: 2,
          title: 'Step design sprint for UX beginner',
          caption: 'Ux Design',
          isBookmarked: true,
          likes: '2k',
          time: '41hr ago',
          imageFileName: 'small_post_3.jpg'),
    ];
  }
}