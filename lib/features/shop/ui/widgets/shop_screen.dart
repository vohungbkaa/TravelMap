import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:travel_map/features/shop/domain/models/shop_product.dart';
import 'package:travel_map/features/shop/ui/view_models/shop_view_model.dart';
import 'package:travel_map/features/shop/ui/widgets/product_detail_screen.dart';
import 'package:travel_map/shared/base/models/loading_type.dart';
import 'package:travel_map/shared/base/models/paging_param.dart';
import 'package:travel_map/shared/base/widgets/base_paging_screen.dart';
import 'package:travel_map/shared/theme/app_colors.dart';
import 'package:travel_map/shared/theme/app_typography.dart';

class ShopScreen extends BasePagingScreen<ShopViewModel, ShopProduct, DefaultPagingParam> {
  const ShopScreen({super.key});

  static const routeName = 'shop';
  static const routePath = '/shop';

  @override
  ShopViewModel getViewModel(BuildContext context) => context.read<ShopViewModel>();

  @override
  DefaultPagingParam? getLoadParam(BuildContext context) => DefaultPagingParam(pageSize: 10);

  @override
  LoadingType get loadingType => LoadingType.shimmer;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildListView(BuildContext context, ShopViewModel viewModel, List<ShopProduct> items) {
    return _ShopContent(items: items, viewModel: viewModel);
  }

  @override
  Widget buildItem(BuildContext context, ShopProduct item) => const SizedBox.shrink();
}

class _ShopContent extends StatefulWidget {
  const _ShopContent({required this.items, required this.viewModel});

  final List<ShopProduct> items;
  final ShopViewModel viewModel;

  @override
  State<_ShopContent> createState() => _ShopContentState();
}

class _ShopContentState extends State<_ShopContent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Collect unique categories
    final categories = ['Tất cả', ...widget.items.map((p) => p.category).toSet().toList()];

    // Filter items based on selected category and search query
    var filtered = widget.items.where((p) {
      if (_selectedCategory != 'Tất cả' && p.category != _selectedCategory) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.trim().toLowerCase();
        final matchesName = p.name.toLowerCase().contains(q);
        final matchesCategory = p.category.toLowerCase().contains(q);
        final matchesDesc = p.description.toLowerCase().contains(q);
        return matchesName || matchesCategory || matchesDesc;
      }
      return true;
    }).toList();

    final heroProduct = filtered.isNotEmpty ? filtered.first : null;
    final otherProducts = filtered.length > 1 ? filtered.sublist(1) : <ShopProduct>[];

    return Column(
      children: [
        // Shop Header including search bar & category chips
        Container(
          color: AppColors.card,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GIAN TRƯNG BÀY',
                        style: TextStyle(
                          fontSize: AppTypography.s10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mutedForeground,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'Sản vật Tiến Thắng',
                        style: TextStyle(
                          fontSize: AppTypography.s18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.foreground,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.info, size: 16, color: AppColors.foreground),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(LucideIcons.sparkles, size: 12, color: AppColors.gold),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Trưng bày & giới thiệu — liên hệ HTX để đặt mua',
                      style: TextStyle(fontSize: AppTypography.s10, color: AppColors.mutedForeground),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Search Bar matching React design
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.6),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.search,
                      size: 14,
                      color: AppColors.mutedForeground,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(fontSize: AppTypography.s11),
                        decoration: InputDecoration(
                          hintText: 'Tìm sản phẩm, thể loại...',
                          hintStyle: TextStyle(
                            fontSize: AppTypography.s11,
                            color: AppColors.mutedForeground,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () => _searchController.clear(),
                        child: const Icon(
                          LucideIcons.x,
                          size: 14,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Category Chips matching React design
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? Colors.transparent : AppColors.border.withValues(alpha: 0.6),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            fontSize: AppTypography.s10,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? AppColors.primaryForeground : AppColors.mutedForeground,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Shop items scroll list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => widget.viewModel.loadData(isPullToRefresh: true),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  if (filtered.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'Không tìm thấy sản phẩm phù hợp.',
                          style: TextStyle(
                            fontSize: AppTypography.s11,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ),
                    ),

                  // Hero Featured Card
                  if (heroProduct != null) ...[
                    _buildHeroCard(context, heroProduct),
                    const SizedBox(height: 8),
                  ],

                  // Grid 2 Columns for the rest
                  if (otherProducts.isNotEmpty)
                    GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: otherProducts.length,
                      itemBuilder: (context, index) {
                        return _buildProductGridCard(context, otherProducts[index]);
                      },
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context, ShopProduct product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: AppColors.muted),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.foreground.withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                bottom: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.award, size: 10, color: AppColors.foreground),
                          const SizedBox(width: 4),
                          Text(
                            'SẢN PHẨM TIÊU BIỂU',
                            style: TextStyle(
                              fontSize: AppTypography.s11,
                              fontWeight: FontWeight.w900,
                              color: AppColors.foreground,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: AppTypography.s16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      product.origin,
                      style: TextStyle(
                        fontSize: AppTypography.s11,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductGridCard(BuildContext context, ShopProduct product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    product.imageUrl,
                    height: 96,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 96,
                      color: AppColors.muted,
                      child: const Center(child: Icon(LucideIcons.shoppingBag, color: AppColors.mutedForeground)),
                    ),
                  ),
                  Positioned(
                    left: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        product.category,
                        style: TextStyle(
                          fontSize: AppTypography.s8,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                              fontSize: AppTypography.s12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.foreground,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            product.description,
                            style: TextStyle(
                              fontSize: AppTypography.s11,
                              color: AppColors.mutedForeground,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.price,
                            style: TextStyle(
                              fontSize: AppTypography.s12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                LucideIcons.star,
                                size: 10,
                                color: AppColors.gold,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${product.rating} (128)',
                                style: TextStyle(
                                  fontSize: AppTypography.s11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
