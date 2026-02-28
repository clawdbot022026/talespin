class Story {
  final String id;
  final String title;
  final String authorName;
  final String authorAvatarUrl;
  final List<String> tags;
  final int totalNodes;
  final double weeklyVoteVelocity;

  Story({
    required this.id,
    required this.title,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.tags,
    required this.totalNodes,
    required this.weeklyVoteVelocity,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] as String,
      title: json['title'] as String,
      authorName: json['authorName'] as String,
      authorAvatarUrl: json['authorAvatarUrl'] as String,
      tags: (json['tags'] as String).split(',').map((e) => e.trim()).toList(),
      totalNodes: json['totalNodes'] is int ? json['totalNodes'] as int : (json['totalNodes'] as double).toInt(),
      weeklyVoteVelocity: json['weeklyVoteVelocity'] is double ? json['weeklyVoteVelocity'] as double : (json['weeklyVoteVelocity'] as int).toDouble(),
    );
  }
}

// Temporary Mock Data for Phase 1 Demo
final List<Story> mockTrendingStories = [
  Story(
    id: 's1',
    title: 'The Echo of the Last Martian',
    authorName: '@NovaWeaver',
    authorAvatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=NovaStar',
    tags: ['Sci-Fi', 'Mystery'],
    totalNodes: 450,
    weeklyVoteVelocity: 94.5,
  ),
  Story(
    id: 's2',
    title: 'Do Not Open Door 42',
    authorName: '@UnknownDrifter',
    authorAvatarUrl: 'https://api.dicebear.com/7.x/pixel-art/png?seed=Drifter',
    tags: ['Horror', 'Thriller'],
    totalNodes: 120,
    weeklyVoteVelocity: 82.1,
  ),
  Story(
    id: 's3',
    title: 'The Silicon King\'s Heir',
    authorName: '@CipherGod',
    authorAvatarUrl: 'https://api.dicebear.com/7.x/bottts/png?seed=King',
    tags: ['Cyberpunk', 'Drama'],
    totalNodes: 890,
    weeklyVoteVelocity: 110.4,
  ),
];
