import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:travel_map/shared/theme/app_colors.dart';
import 'package:travel_map/shared/theme/app_typography.dart';

class BlockItem {
  BlockItem({
    required this.id,
    required this.kind,
    String text = '',
    this.color = AppColors.foreground,
    this.src = '',
    String caption = '',
  })  : textController = TextEditingController(text: text),
        captionController = TextEditingController(text: caption);

  final int id;
  final String kind; // 'text', 'image', 'video'
  Color color;
  final String src;
  final TextEditingController textController;
  final TextEditingController captionController;

  void dispose() {
    textController.dispose();
    captionController.dispose();
  }
}

class NewsCreatePostScreen extends StatefulWidget {
  const NewsCreatePostScreen({super.key});

  static const routeName = 'news-create-post';
  static const routePath = '/news-create-post';

  @override
  State<NewsCreatePostScreen> createState() => _NewsCreatePostScreenState();
}

class _NewsCreatePostScreenState extends State<NewsCreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final List<BlockItem> _blocks = [];
  int _nextId = 1;

  final List<String> _sampleMedia = [
    'https://images.unsplash.com/photo-1533105079780-92b9be482077?w=600', // festival
    'https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9?w=600', // village
    'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=600', // longan
    'https://images.unsplash.com/photo-1590001155093-a3c66ab0c3ff?w=600', // temple
    'https://images.unsplash.com/photo-1536882240095-0379873feb4e?w=600', // rice
    'https://images.unsplash.com/photo-1563822249548-9a72b6353cd1?w=600', // tea
  ];

  final List<Map<String, dynamic>> _textColors = [
    {'name': 'Đen', 'color': AppColors.foreground},
    {'name': 'Đỏ', 'color': const Color(0xFFD32F2F)},
    {'name': 'Xanh lá', 'color': const Color(0xFF2E7D32)},
    {'name': 'Xanh dương', 'color': const Color(0xFF1565C0)},
    {'name': 'Tím', 'color': const Color(0xFF6A1B9A)},
  ];

  @override
  void initState() {
    super.initState();
    _addTextBlock();
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (var b in _blocks) {
      b.dispose();
    }
    super.dispose();
  }

  void _addTextBlock() {
    setState(() {
      _blocks.add(
        BlockItem(
          id: _nextId++,
          kind: 'text',
        ),
      );
    });
  }

  void _addImageBlock() {
    setState(() {
      final src = _sampleMedia[_blocks.length % _sampleMedia.length];
      _blocks.add(
        BlockItem(
          id: _nextId++,
          kind: 'image',
          src: src,
        ),
      );
    });
  }

  void _addVideoBlock() {
    setState(() {
      final src = _sampleMedia[(_blocks.length + 1) % _sampleMedia.length];
      _blocks.add(
        BlockItem(
          id: _nextId++,
          kind: 'video',
          src: src,
        ),
      );
    });
  }

  void _removeBlock(int id) {
    setState(() {
      final idx = _blocks.indexWhere((b) => b.id == id);
      if (idx >= 0) {
        _blocks[idx].dispose();
        _blocks.removeAt(idx);
      }
    });
  }

  void _moveBlock(int id, int direction) {
    // direction is -1 (up) or 1 (down)
    final idx = _blocks.indexWhere((b) => b.id == id);
    if (idx < 0) return;
    final newIdx = idx + direction;
    if (newIdx < 0 || newIdx >= _blocks.length) return;

    setState(() {
      final temp = _blocks[idx];
      _blocks[idx] = _blocks[newIdx];
      _blocks[newIdx] = temp;
    });
  }

  void _handleSubmit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tiêu đề bài viết'),
          backgroundColor: AppColors.destructive,
        ),
      );
      return;
    }

    // Show success dialog mimicking review process
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(
              LucideIcons.checkCircle2,
              color: Colors.green,
            ),
            const SizedBox(width: 10),
            Text(
              'Gửi thành công',
              style: TextStyle(
                fontSize: AppTypography.s16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Bài viết của bạn đã được gửi cho Quản trị viên để kiểm duyệt trước khi đăng tải.',
          style: TextStyle(
            fontSize: AppTypography.s12,
            color: AppColors.foreground,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // pop dialog
              Navigator.pop(context); // pop create screen
            },
            child: Text(
              'Đóng',
              style: TextStyle(
                fontSize: AppTypography.s12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.card,
      body: SafeArea(
        child: Column(
          children: [
            // Header matching React CreatePostScreen
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.card,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.border.withValues(alpha: 0.4),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        LucideIcons.x,
                        size: 16,
                        color: AppColors.foreground,
                      ),
                    ),
                  ),
                  Text(
                    'Tạo bài viết',
                    style: TextStyle(
                      fontSize: AppTypography.s14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground,
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleSubmit,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Gửi duyệt',
                        style: TextStyle(
                          fontSize: AppTypography.s11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Author Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      gradient: AppColors.gradientAvatar,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'BN',
                        style: TextStyle(
                          fontSize: AppTypography.s11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bạn (Khách)',
                          style: TextStyle(
                            fontSize: AppTypography.s12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.foreground,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    LucideIcons.globe,
                                    size: 10,
                                    color: AppColors.mutedForeground,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Công khai',
                                    style: TextStyle(
                                      fontSize: AppTypography.s9,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.gold.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Chờ admin duyệt',
                                style: TextStyle(
                                  fontSize: AppTypography.s9,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.foreground,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable editor area
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  TextField(
                    controller: _titleController,
                    style: TextStyle(
                      fontSize: AppTypography.s16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Tiêu đề bài viết…',
                      hintStyle: TextStyle(
                        fontSize: AppTypography.s16,
                        color: AppColors.mutedForeground.withValues(alpha: 0.6),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(_blocks.length, (index) {
                    final block = _blocks[index];
                    return _buildBlockCard(block, index);
                  }),
                  const SizedBox(height: 16),
                  // Rules Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.6),
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: AppTypography.s10,
                              height: 1.4,
                              color: AppColors.mutedForeground,
                            ),
                            children: [
                              TextSpan(
                                text: 'Lưu ý: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.foreground,
                                ),
                              ),
                              const TextSpan(
                                text: 'Bài viết sau khi gửi sẽ chuyển đến quản trị viên (admin) xét duyệt trước khi hiển thị trên bảng tin chung.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Bottom Toolbar matching React design
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.card,
                border: Border(
                  top: BorderSide(
                    color: AppColors.border.withValues(alpha: 0.4),
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'THÊM VÀO BÀI VIẾT',
                    style: TextStyle(
                      fontSize: AppTypography.s9,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mutedForeground,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildToolbarButton(
                        icon: LucideIcons.type,
                        label: 'Văn bản',
                        iconColor: AppColors.primary,
                        onTap: _addTextBlock,
                      ),
                      const SizedBox(width: 8),
                      _buildToolbarButton(
                        icon: LucideIcons.image,
                        label: 'Ảnh',
                        iconColor: AppColors.accent,
                        onTap: _addImageBlock,
                      ),
                      const SizedBox(width: 8),
                      _buildToolbarButton(
                        icon: LucideIcons.video,
                        label: 'Video',
                        iconColor: AppColors.destructive,
                        onTap: _addVideoBlock,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String label,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: AppTypography.s10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlockCard(BlockItem block, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.6),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Block header: Move controls & Trash
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    block.kind == 'text'
                        ? LucideIcons.type
                        : block.kind == 'image'
                            ? LucideIcons.image
                            : LucideIcons.film,
                    size: 14,
                    color: AppColors.mutedForeground,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'KHỐI ${index + 1} · ${block.kind == 'text' ? 'VĂN BẢN' : block.kind == 'image' ? 'ẢNH' : 'VIDEO'}',
                    style: TextStyle(
                      fontSize: AppTypography.s9,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: index > 0 ? () => _moveBlock(block.id, -1) : null,
                    icon: const Icon(LucideIcons.arrowUp, size: 14),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: index < _blocks.length - 1 ? () => _moveBlock(block.id, 1) : null,
                    icon: const Icon(LucideIcons.arrowDown, size: 14),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _removeBlock(block.id),
                    icon: const Icon(LucideIcons.trash2, size: 14, color: AppColors.destructive),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Block content based on kind
          if (block.kind == 'text') ...[
            TextField(
              controller: block.textController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: TextStyle(
                fontSize: AppTypography.s12,
                color: block.color,
                height: 1.4,
              ),
              decoration: InputDecoration(
                hintText: 'Viết nội dung tại đây…',
                hintStyle: TextStyle(
                  fontSize: AppTypography.s12,
                  color: AppColors.mutedForeground.withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 10),
            // Text color picker
            Row(
              children: [
                const Icon(LucideIcons.palette, size: 12, color: AppColors.mutedForeground),
                const SizedBox(width: 6),
                ..._textColors.map((colorMap) {
                  final colorVal = colorMap['color'] as Color;
                  final isSelected = block.color == colorVal;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        block.color = colorVal;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: colorVal,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ] else if (block.kind == 'image') ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                block.src,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: block.captionController,
              style: TextStyle(
                fontSize: AppTypography.s11,
                fontStyle: FontStyle.italic,
                color: AppColors.mutedForeground,
              ),
              decoration: InputDecoration(
                hintText: 'Chú thích ảnh (tuỳ chọn)',
                hintStyle: TextStyle(
                  fontSize: AppTypography.s11,
                  color: AppColors.mutedForeground.withValues(alpha: 0.5),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ] else if (block.kind == 'video') ...[
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    block.src,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    color: Colors.black.withValues(alpha: 0.15),
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      LucideIcons.play,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
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
            ),
            const SizedBox(height: 8),
            TextField(
              controller: block.captionController,
              style: TextStyle(
                fontSize: AppTypography.s11,
                fontStyle: FontStyle.italic,
                color: AppColors.mutedForeground,
              ),
              decoration: InputDecoration(
                hintText: 'Chú thích video (tuỳ chọn)',
                hintStyle: TextStyle(
                  fontSize: AppTypography.s11,
                  color: AppColors.mutedForeground.withValues(alpha: 0.5),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
