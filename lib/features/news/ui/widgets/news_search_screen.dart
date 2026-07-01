import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:travel_map/features/news/domain/models/news_post.dart';
import 'package:travel_map/shared/theme/app_colors.dart';
import 'package:travel_map/shared/theme/app_typography.dart';
import 'package:travel_map/features/news/ui/widgets/news_screen.dart'; // to reuse sheets if needed

class NewsSearchScreen extends StatefulWidget {
  const NewsSearchScreen({
    super.key,
    required this.posts,
  });

  final List<NewsPost> posts;

  static const routeName = 'news-search';
  static const routePath = '/news-search';

  @override
  State<NewsSearchScreen> createState() => _NewsSearchScreenState();
}

class _NewsSearchScreenState extends State<NewsSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<String> _recentSearches = [
    'Lễ hội',
    'Nhãn lồng',
    'Đình làng',
    'Đoàn thanh niên',
  ];

  final List<String> _trendingSearches = [
    'Mùa nhãn 2026',
    'Hội rước kiệu',
    'Tiến Thắng',
    'HTX',
  ];

  // Random post count generator for trending tags
  final Map<String, int> _trendingPostCounts = {};

  @override
  void initState() {
    super.initState();
    final random = Random();
    for (var trend in _trendingSearches) {
      _trendingPostCounts[trend] = random.nextInt(80) + 20;
    }
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Remove diacritics for normalization
  String _normalize(String input) {
    var str = input.toLowerCase();
    final diacriticsMap = {
      'a': 'áàảãạăắằẳẵặâấầẩẫậ',
      'd': 'đ',
      'e': 'éèẻẽẹêếềểễệ',
      'i': 'íìỉĩị',
      'o': 'óòỏõọôốồổỗộơớờởỡợ',
      'u': 'úùủũụưứừửữự',
      'y': 'ýỳỷỹỵ'
    };
    for (var entry in diacriticsMap.entries) {
      for (var char in entry.value.codeUnits) {
        str = str.replaceAll(String.fromCharCode(char), entry.key);
      }
    }
    return str;
  }

  List<NewsPost> get _searchResults {
    final queryNormalized = _normalize(_query.trim());
    if (queryNormalized.isEmpty) return [];

    return widget.posts.where((post) {
      final contentNormalized = _normalize(post.content);
      final authorNormalized = _normalize(post.authorName);
      final categoryNormalized = _normalize(post.category);

      return contentNormalized.contains(queryNormalized) ||
          authorNormalized.contains(queryNormalized) ||
          categoryNormalized.contains(queryNormalized);
    }).toList();
  }

  void _onSearchSubmit(String text) {
    setState(() {
      _searchController.text = text;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = _searchResults;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header: Search box matching prototype
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.chevronLeft,
                        size: 18,
                        color: AppColors.foreground,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.search,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              style: TextStyle(
                                fontSize: AppTypography.s13,
                                color: AppColors.foreground,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Tìm bài viết theo tiêu đề, nội dung…',
                                hintStyle: TextStyle(
                                  fontSize: AppTypography.s12,
                                  color: AppColors.mutedForeground,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          if (_query.isNotEmpty)
                            GestureDetector(
                              onTap: () => _searchController.clear(),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: AppColors.muted,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  LucideIcons.x,
                                  size: 12,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 0.5,
              color: AppColors.border,
            ),

            // Body content
            Expanded(
              child: _query.isEmpty
                  ? _buildEmptyQueryState()
                  : results.isEmpty
                      ? _buildNoResultsState()
                      : _buildResultsList(results),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyQueryState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches ("Tìm gần đây")
          Text(
            'TÌM GẦN ĐÂY',
            style: TextStyle(
              fontSize: AppTypography.s10,
              fontWeight: FontWeight.bold,
              color: AppColors.mutedForeground,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches.map((search) {
              return ActionChip(
                onPressed: () => _onSearchSubmit(search),
                avatar: const Icon(
                  LucideIcons.clock,
                  size: 12,
                  color: AppColors.mutedForeground,
                ),
                backgroundColor: AppColors.secondary,
                label: Text(
                  search,
                  style: TextStyle(
                    fontSize: AppTypography.s11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.foreground,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide.none,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Trending Searches ("Đang quan tâm")
          Text(
            'ĐANG QUAN TÂM',
            style: TextStyle(
              fontSize: AppTypography.s10,
              fontWeight: FontWeight.bold,
              color: AppColors.mutedForeground,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _trendingSearches.length,
            itemBuilder: (context, index) {
              final trend = _trendingSearches[index];
              final count = _trendingPostCounts[trend] ?? 25;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => _onSearchSubmit(trend),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.5),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '#${index + 1}',
                              style: TextStyle(
                                fontSize: AppTypography.s10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trend,
                                style: TextStyle(
                                  fontSize: AppTypography.s12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.foreground,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$count bài viết',
                                style: TextStyle(
                                  fontSize: AppTypography.s10,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          LucideIcons.search,
                          size: 14,
                          color: AppColors.mutedForeground,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.search,
                size: 20,
                color: AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Không tìm thấy bài viết',
              style: TextStyle(
                fontSize: AppTypography.s13,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Thử từ khoá khác hoặc kiểm tra chính tả.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppTypography.s11,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(List<NewsPost> results) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final post = results[index];
        final coverImage = post.imageUrls.isNotEmpty ? post.imageUrls[0] : null;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () {
              // Open comments sheet for the post as detail view
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => _CommentsSheetHelper(post: post),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.5),
                  width: 0.5,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (coverImage != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        coverImage,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 64,
                          height: 64,
                          color: AppColors.secondary,
                          child: const Icon(
                            LucideIcons.image,
                            size: 20,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                post.category.toUpperCase(),
                                style: TextStyle(
                                  fontSize: AppTypography.s9,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              post.timeAgo,
                              style: TextStyle(
                                fontSize: AppTypography.s10,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          post.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppTypography.s11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.foreground,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          post.authorName,
                          style: TextStyle(
                            fontSize: AppTypography.s10,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Private helper to wrap the comments bottom sheet for a post
class _CommentsSheetHelper extends StatefulWidget {
  const _CommentsSheetHelper({required this.post});
  final NewsPost post;

  @override
  State<_CommentsSheetHelper> createState() => _CommentsSheetHelperState();
}

class _CommentsSheetHelperState extends State<_CommentsSheetHelper> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, String>> _comments = [
    {
      'name': 'Nguyễn Văn Nam',
      'avatar': 'N',
      'text': 'Đẹp quá bác ơi, bài viết rất ý nghĩa cho bà con xã Tiến Thắng!',
      'time': '10 phút trước',
      'likes': '5',
    },
    {
      'name': 'Lê Thị Mai',
      'avatar': 'M',
      'text': 'Cuối tuần này gia đình mình nhất định sẽ ghé thăm!',
      'time': '25 phút trước',
      'likes': '3',
    },
  ];

  void _handleAddComment() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _comments.insert(0, {
          'name': 'Bạn',
          'avatar': 'T',
          'text': text,
          'time': 'Vừa xong',
          'likes': '0',
        });
        _commentController.clear();
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Sheet Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.4), width: 0.5)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.chevronLeft,
                      size: 18,
                      color: AppColors.foreground,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bình luận',
                        style: TextStyle(
                          fontSize: AppTypography.s15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.foreground,
                        ),
                      ),
                      Text(
                        '${_comments.length} bình luận · cho phép đính kèm ảnh',
                        style: TextStyle(
                          fontSize: AppTypography.s11,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Comment List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final c = _comments[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          c['avatar']!,
                          style: TextStyle(
                            fontSize: AppTypography.s12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c['name']!,
                                    style: TextStyle(
                                      fontSize: AppTypography.s12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.foreground,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    c['text']!,
                                    style: TextStyle(
                                      fontSize: AppTypography.s13,
                                      color: AppColors.foreground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                children: [
                                  Text(
                                    c['time']!,
                                    style: TextStyle(
                                      fontSize: AppTypography.s10,
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Thích',
                                    style: TextStyle(
                                      fontSize: AppTypography.s11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                  if (c['likes'] != '0') ...[
                                    const SizedBox(width: 16),
                                    const Icon(
                                      Icons.favorite,
                                      size: 10,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      c['likes']!,
                                      style: TextStyle(
                                        fontSize: AppTypography.s11,
                                        color: AppColors.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom Input Bar
          Container(
            padding: EdgeInsets.fromLTRB(
              12,
              10,
              12,
              MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.4), width: 0.5)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    'T',
                    style: TextStyle(
                      fontSize: AppTypography.s12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: _commentController,
                      style: TextStyle(fontSize: AppTypography.s13),
                      decoration: InputDecoration(
                        hintText: 'Viết bình luận...',
                        hintStyle: TextStyle(
                          fontSize: AppTypography.s13,
                          color: AppColors.mutedForeground,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: (_) => _handleAddComment(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _handleAddComment,
                  icon: const Icon(
                    LucideIcons.send,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
