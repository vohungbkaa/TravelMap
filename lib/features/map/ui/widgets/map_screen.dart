import 'dart:async';
import 'package:travel_map/shared/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:travel_map/features/map/domain/models/map_place.dart';
import 'package:travel_map/features/map/ui/view_models/map_view_model.dart';
import 'package:travel_map/features/map/ui/widgets/place_detail_screen.dart';
import 'package:travel_map/shared/base/widgets/base_api_screen.dart';
import 'package:travel_map/shared/theme/app_colors.dart';

class MapScreen extends BaseApiScreen<MapViewModel, List<MapPlace>, void> {
  const MapScreen({super.key});

  static const routeName = 'map';
  static const routePath = '/map';

  @override
  MapViewModel getViewModel(BuildContext context) =>
      context.read<MapViewModel>();

  @override
  void getLoadParam(BuildContext context) {}

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildApiBody(BuildContext context, MapViewModel viewModel) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return _MapContentView(viewModel: viewModel);
      },
    );
  }
}

class _MapContentView extends StatefulWidget {
  const _MapContentView({required this.viewModel});

  final MapViewModel viewModel;

  @override
  State<_MapContentView> createState() => _MapContentViewState();
}

class _MapContentViewState extends State<_MapContentView> {
  late final MapController _mapController;
  late final ScrollController _scrollController;
  String? _previousSelectedId;
  bool _isDistanceMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(covariant _MapContentView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handleSelectedPlaceChange();
  }

  void _handleSelectedPlaceChange() {
    final selectedPlace = widget.viewModel.selectedPlace;
    if (selectedPlace != null && selectedPlace.id != _previousSelectedId) {
      _previousSelectedId = selectedPlace.id;

      // 1. Move/Center map to selected marker
      _mapController.move(
        LatLng(selectedPlace.latitude, selectedPlace.longitude),
        15,
      );

      // 2. Scroll horizontal list to selected place card
      final places = widget.viewModel.filteredPlaces;
      final index = places.indexWhere((p) => p.id == selectedPlace.id);
      if (index != -1 && _scrollController.hasClients) {
        final targetOffset = index * 280.0;
        unawaited(
          _scrollController.animateTo(
            targetOffset,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
        );
      }
    } else if (selectedPlace == null) {
      _previousSelectedId = null;
    }
  }

  void _onPlaceTap(MapPlace place) {
    if (_isDistanceMenuOpen) {
      setState(() => _isDistanceMenuOpen = false);
    }
    widget.viewModel.selectPlace(place);
    _handleSelectedPlaceChange();
  }

  void _navigateToDetail(MapPlace place) {
    if (_isDistanceMenuOpen) {
      setState(() => _isDistanceMenuOpen = false);
    }
    unawaited(context.pushNamed(PlaceDetailScreen.routeName, extra: place));
  }

  void _showMapStyleBottomSheet() {
    final viewModel = widget.viewModel;
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tùy chọn giao diện bản đồ',
                  style: TextStyle(fontSize: AppTypography.s17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildStyleOptionTile(
                  title: 'CartoDB Voyager (Du lịch hiện đại)',
                  subtitle: 'Giao diện mượt mà, màu sắc du lịch tối ưu',
                  styleKey: 'voyager',
                  currentStyle: viewModel.mapStyle,
                  onTap: () {
                    viewModel.setMapStyle('voyager');
                    Navigator.pop(context);
                  },
                ),
                _buildStyleOptionTile(
                  title: 'CartoDB Positron (Sáng tối giản)',
                  subtitle: 'Tone xám trắng hiện đại, tôn nổi bật địa danh',
                  styleKey: 'positron',
                  currentStyle: viewModel.mapStyle,
                  onTap: () {
                    viewModel.setMapStyle('positron');
                    Navigator.pop(context);
                  },
                ),
                _buildStyleOptionTile(
                  title: 'CartoDB Dark Matter (Chế độ tối)',
                  subtitle: 'Tone tối huyền bí, phong cách tương lai',
                  styleKey: 'dark',
                  currentStyle: viewModel.mapStyle,
                  onTap: () {
                    viewModel.setMapStyle('dark');
                    Navigator.pop(context);
                  },
                ),
                _buildStyleOptionTile(
                  title: 'OpenStreetMap (Tiêu chuẩn)',
                  subtitle: 'Bản đồ chi tiết truyền thống',
                  styleKey: 'standard',
                  currentStyle: viewModel.mapStyle,
                  onTap: () {
                    viewModel.setMapStyle('standard');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStyleOptionTile({
    required String title,
    required String subtitle,
    required String styleKey,
    required String currentStyle,
    required VoidCallback onTap,
  }) {
    final isSelected = styleKey == currentStyle;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          fontSize: AppTypography.s14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? AppColors.primary : AppColors.foreground,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: AppTypography.s12, color: AppColors.mutedForeground),
      ),
      trailing: isSelected
          ? const Icon(
              LucideIcons.checkCircle2,
              color: AppColors.primary,
              size: 20,
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildDistanceMenuItem(String label, double? value) {
    final isSelected = value == widget.viewModel.selectedMaxDistance;
    return InkWell(
      onTap: () {
        widget.viewModel.setDistanceFilter(value);
        setState(() => _isDistanceMenuOpen = false);
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: AppTypography.s14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.foreground,
              ),
            ),
            if (isSelected)
              const Icon(
                LucideIcons.check,
                size: 16,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final places = viewModel.filteredPlaces;
    final hasDistanceFilter = viewModel.selectedMaxDistance != null;

    return Stack(
      children: [
        // Map view with dynamic map style
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: const LatLng(21.0285, 105.8542),
            initialZoom: 14,
            onTap: (tapPosition, point) {
              if (_isDistanceMenuOpen) {
                setState(() => _isDistanceMenuOpen = false);
              }
              viewModel.selectPlace(null);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: viewModel.tileUrlTemplate,
              userAgentPackageName: 'com.example.travel_map',
            ),
            MarkerLayer(
              markers: places.map((place) {
                final isSelected = viewModel.selectedPlace?.id == place.id;
                return Marker(
                  point: LatLng(place.latitude, place.longitude),
                  width: isSelected ? 150 : 48,
                  height: isSelected ? 110 : 48,
                  alignment: isSelected
                      ? Alignment.bottomCenter
                      : Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      if (isSelected) {
                        _navigateToDetail(place);
                      } else {
                        _onPlaceTap(place);
                      }
                    },
                    child: _buildMarkerWidget(place, isSelected),
                  ),
                );
              }).toList(),
            ),
          ],
        ),

        // Top Search Bar, Distance Filter Menu & Category Chips
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 12,
          right: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar with Funnel Filter Icon on the Right
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppColors.softShadow,
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.search,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          fontSize: AppTypography.s14,
                          color: AppColors.foreground,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Tìm di tích, điểm du lịch...',
                          hintStyle: TextStyle(
                            fontSize: AppTypography.s13,
                            color: AppColors.mutedForeground,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: viewModel.setSearchQuery,
                      ),
                    ),
                    if (viewModel.searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () => viewModel.setSearchQuery(''),
                        child: const Icon(
                          LucideIcons.x,
                          size: 16,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    const SizedBox(width: 8),
                    Container(
                      height: 20,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(width: 8),
                    // Funnel Filter Icon for Distance Options
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isDistanceMenuOpen = !_isDistanceMenuOpen;
                        });
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            LucideIcons.slidersHorizontal,
                            size: 18,
                            color: hasDistanceFilter || _isDistanceMenuOpen
                                ? AppColors.primary
                                : AppColors.foreground,
                          ),
                          if (hasDistanceFilter)
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Stack containing Category Chips & Overlay Distance Menu
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Category Filter Chips (Main underlying layer)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          'Tất cả loại',
                          LucideIcons.mapPin,
                          AppColors.primary,
                          viewModel.selectedCategory == 'all',
                          () => viewModel.setCategory('all'),
                        ),
                        _buildFilterChip(
                          'Di tích',
                          LucideIcons.landmark,
                          AppColors.primary,
                          viewModel.selectedCategory == 'ditich',
                          () => viewModel.setCategory('ditich'),
                        ),
                        _buildFilterChip(
                          'Du lịch',
                          LucideIcons.treePine,
                          AppColors.accent,
                          viewModel.selectedCategory == 'dulich',
                          () => viewModel.setCategory('dulich'),
                        ),
                        _buildFilterChip(
                          'Đặc sản',
                          LucideIcons.wheat,
                          AppColors.gold,
                          viewModel.selectedCategory == 'dacsan',
                          () => viewModel.setCategory('dacsan'),
                        ),
                      ],
                    ),
                  ),

                  // Floating Distance Selection Menu (Overlaying layer)
                  if (_isDistanceMenuOpen)
                    Positioned(
                      top: 0,
                      right: 4,
                      child: Container(
                        width: 175,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildDistanceMenuItem('Mọi khoảng cách', null),
                            const Divider(height: 1, thickness: 0.5),
                            _buildDistanceMenuItem('Dưới 1 km', 1),
                            const Divider(height: 1, thickness: 0.5),
                            _buildDistanceMenuItem('Dưới 2 km', 2),
                            const Divider(height: 1, thickness: 0.5),
                            _buildDistanceMenuItem('Dưới 5 km', 5),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        // Floating Action Controls (Right side above bottom cards)
        Positioned(
          right: 12,
          bottom: 135,
          child: Column(
            children: [
              // Map Style Switcher Button
              FloatingActionButton.small(
                heroTag: 'map_style_btn',
                backgroundColor: Colors.white,
                elevation: 3,
                onPressed: _showMapStyleBottomSheet,
                child: const Icon(
                  LucideIcons.layers,
                  color: AppColors.foreground,
                  size: 18,
                ),
              ),
              const SizedBox(height: 8),
              // Re-center Location Button
              FloatingActionButton.small(
                heroTag: 'recenter_btn',
                backgroundColor: Colors.white,
                elevation: 3,
                onPressed: () {
                  viewModel.selectPlace(null);
                  _mapController.move(const LatLng(21.0285, 105.8542), 14);
                },
                child: const Icon(
                  LucideIcons.navigation,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
            ],
          ),
        ),

        // Bottom Sheet Horizontal Preview Cards
        Positioned(
          bottom: 16,
          left: 12,
          right: 12,
          child: SizedBox(
            height: 105,
            child: places.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppColors.softShadow,
                    ),
                    child: Center(
                      child: Text(
                        'Không tìm thấy địa điểm phù hợp trong phạm vi',
                        style: TextStyle(
                          fontSize: AppTypography.s14,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      final place = places[index];
                      final isSelected =
                          viewModel.selectedPlace?.id == place.id;
                      return GestureDetector(
                        onTap: () {
                          _onPlaceTap(place);
                          _navigateToDetail(place);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 270,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: isSelected ? 2 : 0,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.25),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : AppColors.softShadow,
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  place.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    width: 80,
                                    height: 80,
                                    color: AppColors.muted,
                                    child: const Icon(
                                      LucideIcons.map,
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      place.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppTypography.s14,
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.foreground,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      place.address,
                                      style: TextStyle(
                                        fontSize: AppTypography.s12,
                                        color: AppColors.mutedForeground,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(
                                          LucideIcons.navigation,
                                          size: 12,
                                          color: AppColors.accent,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          place.distance,
                                          style: TextStyle(
                                            fontSize: AppTypography.s12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.accent,
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
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    String label,
    IconData icon,
    Color color,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      child: FilterChip(
        showCheckmark: false,
        avatar: Icon(
          icon,
          size: 13,
          color: isSelected ? Colors.white : color,
        ),
        label: Text(label),
        labelStyle: TextStyle(
          fontSize: AppTypography.s12,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : AppColors.foreground,
        ),
        selected: isSelected,
        selectedColor: color,
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        onSelected: (_) => onTap(),
      ),
    );
  }

  Widget _buildMarkerWidget(MapPlace place, bool isSelected) {
    final catColor = _getCategoryColor(place.category);

    final avatarWidget = Container(
      width: isSelected ? 44 : 38,
      height: isSelected ? 44 : 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : catColor,
          width: isSelected ? 3 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: isSelected ? 8 : 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Image.network(
          place.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => ColoredBox(
            color: catColor,
            child: const Icon(
              LucideIcons.mapPin,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ),
    );

    if (!isSelected) {
      return avatarWidget;
    }

    // Selected state: Displays callout details badge above place avatar
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                place.title,
                style: TextStyle(
                  fontSize: AppTypography.s12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1),
              Text(
                place.distance,
                style: TextStyle(
                  fontSize: AppTypography.s10,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        avatarWidget,
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'ditich':
        return AppColors.primary;
      case 'dulich':
        return AppColors.accent;
      case 'dacsan':
        return AppColors.gold;
      default:
        return AppColors.primary;
    }
  }
}
