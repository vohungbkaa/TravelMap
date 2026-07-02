import 'dart:async';
import 'package:travel_map/shared/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:travel_map/features/news/domain/models/news_post.dart';
import 'package:travel_map/features/news/ui/widgets/news_search_screen.dart';
import 'package:travel_map/features/news/ui/widgets/news_notifications_screen.dart';
import 'package:travel_map/features/news/ui/widgets/news_create_post_screen.dart';
import 'package:travel_map/features/news/ui/widgets/news_detail_screen.dart';
import 'package:travel_map/features/news/ui/view_models/news_view_model.dart';
import 'package:travel_map/shared/base/models/loading_type.dart';
import 'package:travel_map/shared/base/models/paging_param.dart';
import 'package:travel_map/shared/base/widgets/base_paging_screen.dart';
import 'package:travel_map/shared/theme/app_colors.dart';

IconData _getFilledIcon(IconData outlineIcon) {
  if (outlineIcon == LucideIcons.heart) return Icons.favorite;
  if (outlineIcon == LucideIcons.thumbsUp) return Icons.thumb_up;
  if (outlineIcon == LucideIcons.laugh) return Icons.emoji_emotions;
  if (outlineIcon == LucideIcons.partyPopper) return Icons.celebration;
  if (outlineIcon == LucideIcons.frown) return Icons.sentiment_dissatisfied;
  if (outlineIcon == LucideIcons.angry) return Icons.mood_bad;
  return outlineIcon;
}

class NewsScreen
    extends BasePagingScreen<NewsViewModel, NewsPost, DefaultPagingParam> {
  const NewsScreen({super.key});

  static const routeName = 'news';
  static const routePath = '/news';

  @override
  NewsViewModel getViewModel(BuildContext context) =>
      context.read<NewsViewModel>();

  @override
  DefaultPagingParam? getLoadParam(BuildContext context) =>
      DefaultPagingParam(pageSize: 10);

  @override
  LoadingType get loadingType => LoadingType.shimmer;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildListView(
    BuildContext context,
    NewsViewModel viewModel,
    List<NewsPost> items,
  ) {
    return Column(
      children: [
        const _NewsHeader(),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.axisDirection == AxisDirection.down) {
                final maxScroll = scrollInfo.metrics.maxScrollExtent;
                final currentScroll = scrollInfo.metrics.pixels;
                if (maxScroll - currentScroll <= loadMoreThreshold) {
                  unawaited(viewModel.loadMore());
                }
              }
              return false;
            },
            child: RefreshIndicator(
              onRefresh: () => viewModel.loadData(isPullToRefresh: true),
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: items.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const _ComposerCard();
                  }
                  if (index == items.length + 1) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: viewModel.isLoadingMore,
                      builder: (context, isLoadingMore, _) {
                        if (isLoadingMore) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
                              '— Hết bài mới —',
                              style: TextStyle(
                                fontSize: AppTypography.s12,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return buildItem(context, items[index - 1]);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildItem(BuildContext context, NewsPost item) {
    return _PostCardWidget(item: item);
  }
}

class _PostCardWidget extends StatefulWidget {
  const _PostCardWidget({required this.item});

  final NewsPost item;

  @override
  State<_PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<_PostCardWidget> {
  bool _showReactionPicker = false;
  String? _selectedReactionEmoji;
  String _selectedReactionLabel = 'Thả tim';
  Color _selectedReactionColor = AppColors.mutedForeground;
  IconData _selectedReactionIcon = LucideIcons.heart;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    _likesCount = widget.item.likesCount;
  }

  void _onSelectReaction(
    String emoji,
    String label,
    Color color,
    IconData icon,
  ) {
    setState(() {
      if (_selectedReactionEmoji == emoji) {
        _selectedReactionEmoji = null;
        _selectedReactionLabel = 'Thả tim';
        _selectedReactionColor = AppColors.mutedForeground;
        _selectedReactionIcon = LucideIcons.heart;
        _likesCount--;
      } else {
        if (_selectedReactionEmoji == null) {
          _likesCount++;
        }
        _selectedReactionEmoji = emoji;
        _selectedReactionLabel = label;
        _selectedReactionColor = color;
        _selectedReactionIcon = icon;
      }
      _showReactionPicker = false;
    });
  }

  void _showCommentsBottomSheet(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _CommentsSheetWidget(post: widget.item),
      ),
    );
  }

  void _showReactionsBottomSheet(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const _ReactionsSheetWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetailScreen(post: item),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author Header (Matching prototype: avatar 32x32, subtitle timeAgo · category, trailing more_horizontal, no separate badge pill)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(item.authorAvatar),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                    Text(
                                      item.authorName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppTypography.s12,
                                        color: AppColors.foreground,
                                      ),
                                    ),
                                    Text(
                                      '${item.timeAgo} · ${item.category}',
                                      style: TextStyle(
                                        fontSize: AppTypography.s11,
                                        color: AppColors.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                LucideIcons.moreHorizontal,
                                size: 20,
                                color: AppColors.mutedForeground,
                              ),
                            ],
                          ),
                        ),

                        // Post Text
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 2,
                          ),
                          child: Text(
                            item.content,
                            style: TextStyle(
                              fontSize: AppTypography.s14,
                              height: 1.45,
                              color: AppColors.foreground,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Post Image / Video
                  if (item.imageUrls.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTap: () {
                          final isVideo = item.id == '3';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MediaViewerScreen(
                                src: item.imageUrls.first,
                                type: isVideo ? 'video' : 'image',
                                duration: isVideo ? '0:42' : null,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item.imageUrls.first,
                                height: 190,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                color: item.id == '3' ? Colors.black.withValues(alpha: 0.15) : null,
                                colorBlendMode: item.id == '3' ? BlendMode.darken : null,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 150,
                                  color: AppColors.muted,
                                  child: const Center(
                                    child: Icon(
                                      LucideIcons.image,
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (item.id == '3') ...[
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: AppColors.softShadow,
                                ),
                                child: const Center(
                                  child: Icon(
                                    LucideIcons.play,
                                    size: 20,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 6,
                                right: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '0:42',
                                    style: TextStyle(
                                      fontSize: AppTypography.s9,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                  // Reaction Summary Row (Matching Prototype exactly)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => _showReactionsBottomSheet(context),
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 50,
                                height: 22,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      child: _buildReactionBadge(
                                        LucideIcons.heart,
                                        AppColors.primary,
                                      ),
                                    ),
                                    Positioned(
                                      left: 14,
                                      child: _buildReactionBadge(
                                        LucideIcons.thumbsUp,
                                        const Color(0xFF1877F2),
                                      ),
                                    ),
                                    Positioned(
                                      left: 28,
                                      child: _buildReactionBadge(
                                        LucideIcons.laugh,
                                        AppColors.gold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$_likesCount',
                                style: TextStyle(
                                  fontSize: AppTypography.s12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.foreground,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showCommentsBottomSheet(context),
                          child: Text(
                            '${item.commentsCount} bình luận · 12 chia sẻ',
                            style: TextStyle(
                              fontSize: AppTypography.s12,
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: AppColors.border.withValues(alpha: 0.4),
                    indent: 12,
                    endIndent: 12,
                  ),

                  // Post Action Buttons (Thả tim / Reaction, Bình luận, Chia sẻ)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      children: [
                        // Reaction / Like Button with Long-press & Tap Handler
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (_selectedReactionEmoji != null) {
                                _onSelectReaction(
                                  '❤️',
                                  'Thả tim',
                                  AppColors.mutedForeground,
                                  LucideIcons.heart,
                                );
                              } else {
                                _onSelectReaction(
                                  '❤️',
                                  'Yêu thích',
                                  AppColors.primary,
                                  LucideIcons.heart,
                                );
                              }
                            },
                            onLongPress: () {
                              setState(() {
                                _showReactionPicker = !_showReactionPicker;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _selectedReactionEmoji != null
                                        ? _getFilledIcon(_selectedReactionIcon)
                                        : _selectedReactionIcon,
                                    size: 20,
                                    color: _selectedReactionColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _selectedReactionLabel,
                                    style: TextStyle(
                                      fontSize: AppTypography.s11,
                                      fontWeight: FontWeight.w600,
                                      color: _selectedReactionColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Comment Button
                        Expanded(
                          child: InkWell(
                            onTap: () => _showCommentsBottomSheet(context),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.messageCircle,
                                    size: 20,
                                    color: AppColors.mutedForeground,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Bình luận',
                                    style: TextStyle(
                                      fontSize: AppTypography.s11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Share Button
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.share2,
                                    size: 20,
                                    color: AppColors.mutedForeground,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Chia sẻ',
                                    style: TextStyle(
                                      fontSize: AppTypography.s11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

          // Facebook-style Animated Reaction Selector Bar
          if (_showReactionPicker)
            Positioned(
              bottom: 44,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ReactionPickerItem(
                      emoji: '👍',
                      label: 'Thích',
                      color: const Color(0xFF1877F2),
                      icon: LucideIcons.thumbsUp,
                      onTap: () => _onSelectReaction(
                        '👍',
                        'Thích',
                        const Color(0xFF1877F2),
                        LucideIcons.thumbsUp,
                      ),
                    ),
                    _ReactionPickerItem(
                      emoji: '❤️',
                      label: 'Yêu thích',
                      color: AppColors.primary,
                      icon: LucideIcons.heart,
                      onTap: () => _onSelectReaction(
                        '❤️',
                        'Yêu thích',
                        AppColors.primary,
                        LucideIcons.heart,
                      ),
                    ),
                    _ReactionPickerItem(
                      emoji: '😆',
                      label: 'Haha',
                      color: AppColors.gold,
                      icon: LucideIcons.laugh,
                      onTap: () => _onSelectReaction(
                        '😆',
                        'Haha',
                        AppColors.gold,
                        LucideIcons.laugh,
                      ),
                    ),
                    _ReactionPickerItem(
                      emoji: '😮',
                      label: 'Bất ngờ',
                      color: Colors.purple,
                      icon: LucideIcons.partyPopper,
                      onTap: () => _onSelectReaction(
                        '😮',
                        'Bất ngờ',
                        Colors.purple,
                        LucideIcons.partyPopper,
                      ),
                    ),
                    _ReactionPickerItem(
                      emoji: '😢',
                      label: 'Buồn',
                      color: Colors.blueGrey,
                      icon: LucideIcons.frown,
                      onTap: () => _onSelectReaction(
                        '😢',
                        'Buồn',
                        Colors.blueGrey,
                        LucideIcons.frown,
                      ),
                    ),
                    _ReactionPickerItem(
                      emoji: '😡',
                      label: 'Phẫn nộ',
                      color: Colors.redAccent,
                      icon: LucideIcons.angry,
                      onTap: () => _onSelectReaction(
                        '😡',
                        'Phẫn nộ',
                        Colors.redAccent,
                        LucideIcons.angry,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReactionBadge(IconData icon, Color bg) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.card, width: 2.0),
      ),
      child: Center(
        child: Icon(
          _getFilledIcon(icon),
          size: 12,
          color: Colors.white,
        ),
      ),
    );
  }
} // Closes _PostCardWidgetState

class _ReactionPickerItem extends StatefulWidget {
  const _ReactionPickerItem({
    required this.emoji,
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_ReactionPickerItem> createState() => _ReactionPickerItemState();
}

class _ReactionPickerItemState extends State<_ReactionPickerItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: AnimatedScale(
            scale: _isHovered ? 1.35 : 1.0,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOutBack,
            child: Text(
              widget.emoji,
              style: TextStyle(fontSize: AppTypography.s24),
            ),
          ),
        ),
      ),
    );
  }
}

class _CommentsSheetWidget extends StatefulWidget {
  const _CommentsSheetWidget({required this.post});

  final NewsPost post;

  @override
  State<_CommentsSheetWidget> createState() => _CommentsSheetWidgetState();
}

class _CommentsSheetWidgetState extends State<_CommentsSheetWidget> {
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
    {
      'name': 'Trần Đức Anh',
      'avatar': 'A',
      'text': 'Đặc sản Tiến Thắng chuẩn OCOP tuyệt vời lắm nha mọi người.',
      'time': '1 giờ trước',
      'likes': '8',
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
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Sheet Header matching Prototype
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
                        radius: 20,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          c['avatar']!,
                          style: TextStyle(
                            fontSize: AppTypography.s12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.card,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
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
                                  const SizedBox(height: 2),
                                  Text(
                                    c['text']!,
                                    style: TextStyle(
                                      fontSize: AppTypography.s13,
                                      height: 1.4,
                                      color: AppColors.foreground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  c['time']!,
                                  style: TextStyle(
                                    fontSize: AppTypography.s11,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Thích',
                                  style: TextStyle(
                                    fontSize: AppTypography.s11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Trả lời',
                                  style: TextStyle(
                                    fontSize: AppTypography.s11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  LucideIcons.heart,
                                  size: 20,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  c['likes']!,
                                  style: TextStyle(
                                    fontSize: AppTypography.s11,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ],
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

          // Bottom Input Bar matching Prototype
          Container(
            padding: EdgeInsets.fromLTRB(
              12,
              10,
              12,
              MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.4), width: 0.5)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    'T',
                    style: TextStyle(
                      fontSize: AppTypography.s12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.card,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.smile,
                          size: 20,
                          color: AppColors.mutedForeground,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            style: TextStyle(fontSize: AppTypography.s13),
                            decoration: InputDecoration(
                              hintText: 'Viết bình luận…',
                              hintStyle: TextStyle(
                                fontSize: AppTypography.s13,
                                color: AppColors.mutedForeground,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onSubmitted: (_) => _handleAddComment(),
                          ),
                        ),
                        const Icon(
                          LucideIcons.imagePlus,
                          size: 20,
                          color: AppColors.mutedForeground,
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          LucideIcons.camera,
                          size: 20,
                          color: AppColors.mutedForeground,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _handleAddComment,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.send,
                      size: 20,
                      color: AppColors.card,
                    ),
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

class _NewsHeader extends StatefulWidget {
  const _NewsHeader();

  @override
  State<_NewsHeader> createState() => _NewsHeaderState();
}

class _NewsHeaderState extends State<_NewsHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bản tin xã',
                style: TextStyle(
                  fontSize: AppTypography.s21,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
              Row(
                children: [
                  _buildHeaderButton(
                    icon: LucideIcons.search,
                    onTap: () {
                      final posts = context.read<NewsViewModel>().items;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsSearchScreen(posts: posts),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 8),
                  Stack(
                    children: [
                      _buildHeaderButton(
                        icon: LucideIcons.bell,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NewsNotificationsScreen(),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppColors.destructive,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? AppColors.card : AppColors.primary,
        ),
      ),
    );
  }
}

class _ComposerCard extends StatelessWidget {
  const _ComposerCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NewsCreatePostScreen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                gradient: AppColors.gradientAvatar,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'BN',
                  style: TextStyle(
                    fontSize: AppTypography.s12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.card,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Bạn muốn chia sẻ điều gì với làng?',
                style: TextStyle(
                  fontSize: AppTypography.s12,
                  color: AppColors.mutedForeground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Liker {
  final String name;
  final String avatar;
  final String sub;
  final String emoji;
  final String label;
  final IconData icon;
  final Color color;

  const _Liker({
    required this.name,
    required this.avatar,
    required this.sub,
    required this.emoji,
    required this.label,
    required this.icon,
    required this.color,
  });
}

class _ReactionsSheetWidget extends StatefulWidget {
  const _ReactionsSheetWidget();

  @override
  State<_ReactionsSheetWidget> createState() => _ReactionsSheetWidgetState();
}

class _ReactionsSheetWidgetState extends State<_ReactionsSheetWidget> {
  String _selectedTab = 'all';
  final Set<String> _followedUsers = <String>{};

  final List<_Liker> _sampleLikers = [
    const _Liker(name: 'Nguyễn Thị Hoa', avatar: 'NH', sub: 'Thôn Đoài', emoji: '❤️', label: 'Yêu thích', icon: LucideIcons.heart, color: AppColors.primary),
    const _Liker(name: 'Trần Văn Minh', avatar: 'TM', sub: 'Thôn Đông', emoji: '👍', label: 'Thích', icon: LucideIcons.thumbsUp, color: Color(0xFF1877F2)),
    const _Liker(name: 'Lê Thị Hoàng', avatar: 'LH', sub: 'Thôn Trung', emoji: '❤️', label: 'Yêu thích', icon: LucideIcons.heart, color: AppColors.primary),
    const _Liker(name: 'Phạm Thu Hà', avatar: 'PT', sub: 'Thôn Đoài', emoji: '😆', label: 'Haha', icon: LucideIcons.laugh, color: AppColors.gold),
    const _Liker(name: 'Đỗ Quang Huy', avatar: 'ĐQ', sub: 'Thôn Tây', emoji: '😮', label: 'Bất ngờ', icon: LucideIcons.partyPopper, color: Colors.purple),
    const _Liker(name: 'Vũ Mai Anh', avatar: 'VM', sub: 'Thôn Đông', emoji: '❤️', label: 'Yêu thích', icon: LucideIcons.heart, color: AppColors.primary),
    const _Liker(name: 'Bùi Văn Sơn', avatar: 'BS', sub: 'Thôn Trung', emoji: '😢', label: 'Buồn', icon: LucideIcons.frown, color: Colors.blueGrey),
    const _Liker(name: 'Hoàng Lan', avatar: 'HL', sub: 'Thôn Đoài', emoji: '👍', label: 'Thích', icon: LucideIcons.thumbsUp, color: Color(0xFF1877F2)),
    const _Liker(name: 'Đặng Hữu', avatar: 'ĐH', sub: 'Thôn Tây', emoji: '😆', label: 'Haha', icon: LucideIcons.laugh, color: AppColors.gold),
    const _Liker(name: 'Phan Hồng', avatar: 'PH', sub: 'Thôn Đông', emoji: '😡', label: 'Phẫn nộ', icon: LucideIcons.angry, color: Colors.redAccent),
    const _Liker(name: 'Trịnh Minh Anh', avatar: 'TA', sub: 'Thôn Đoài', emoji: '❤️', label: 'Yêu thích', icon: LucideIcons.heart, color: AppColors.primary),
    const _Liker(name: 'Cao Văn Phú', avatar: 'CP', sub: 'Thôn Trung', emoji: '👍', label: 'Thích', icon: LucideIcons.thumbsUp, color: Color(0xFF1877F2)),
  ];

  @override
  Widget build(BuildContext context) {
    final Map<String, int> counts = {
      'all': _sampleLikers.length,
      '❤️': 0,
      '👍': 0,
      '😆': 0,
      '😮': 0,
      '😢': 0,
      '😡': 0,
    };
    for (var l in _sampleLikers) {
      counts[l.emoji] = (counts[l.emoji] ?? 0) + 1;
    }

    final filteredLikers = _selectedTab == 'all'
        ? _sampleLikers
        : _sampleLikers.where((l) => l.emoji == _selectedTab).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header Widget (03- cảm xúc Title)
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
                        'Cảm xúc',
                        style: TextStyle(
                          fontSize: AppTypography.s15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.foreground,
                        ),
                      ),
                      Text(
                        '${_sampleLikers.length} người đã bày tỏ cảm xúc',
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

          // Tabs list matching Prototype exactly
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.4), width: 0.5)),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildTabButton('all', 'Tất cả ${counts['all']}'),
                _buildReactionTabButton('❤️', counts['❤️'] ?? 0, AppColors.primary, LucideIcons.heart),
                _buildReactionTabButton('👍', counts['👍'] ?? 0, const Color(0xFF1877F2), LucideIcons.thumbsUp),
                _buildReactionTabButton('😆', counts['😆'] ?? 0, AppColors.gold, LucideIcons.laugh),
                _buildReactionTabButton('😮', counts['😮'] ?? 0, Colors.purple, LucideIcons.partyPopper),
                _buildReactionTabButton('😢', counts['😢'] ?? 0, Colors.blueGrey, LucideIcons.frown),
                _buildReactionTabButton('😡', counts['😡'] ?? 0, Colors.redAccent, LucideIcons.angry),
              ],
            ),
          ),

          // User list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredLikers.length,
              itemBuilder: (context, index) {
                final l = filteredLikers[index];
                final isFollowed = _followedUsers.contains(l.name);
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.4), width: 0.5)),
                  ),
                  child: Row(
                    children: [
                      // Avatar with Overlay Emoji Badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: AppColors.secondary,
                            child: Text(
                              l.avatar,
                              style: TextStyle(
                                fontSize: AppTypography.s12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondaryForeground,
                              ),
                            ),
                          ),
                          Positioned(
                            right: -3,
                            bottom: -3,
                            child: Container(
                              padding: const EdgeInsets.all(1.5),
                              decoration: const BoxDecoration(
                                color: AppColors.card,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  )
                                ],
                              ),
                              child: Text(
                                l.emoji,
                                style: TextStyle(fontSize: AppTypography.s10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.name,
                              style: TextStyle(
                                fontSize: AppTypography.s13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.foreground,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              '${l.sub} · ${l.label}',
                              style: TextStyle(
                                fontSize: AppTypography.s11,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Follow toggle button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isFollowed) {
                              _followedUsers.remove(l.name);
                            } else {
                              _followedUsers.add(l.name);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isFollowed ? AppColors.secondary : AppColors.card,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isFollowed ? Colors.transparent : AppColors.primary,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            isFollowed ? 'Đang theo dõi' : 'Theo dõi',
                            style: TextStyle(
                              fontSize: AppTypography.s11,
                              fontWeight: FontWeight.bold,
                              color: isFollowed ? AppColors.mutedForeground : AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String tabId, String text) {
    final isSelected = _selectedTab == tabId;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = tabId),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.border,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: AppTypography.s11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.primaryForeground : AppColors.foreground,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReactionTabButton(String emoji, int count, Color color, IconData icon) {
    final isSelected = _selectedTab == emoji;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = emoji),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.border,
            width: 1,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    _getFilledIcon(icon),
                    size: 8,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: AppTypography.s11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primaryForeground : AppColors.foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
