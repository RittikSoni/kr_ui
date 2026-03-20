import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../config/component_registry.dart';

class VideoShowcasePage extends StatefulWidget {
  const VideoShowcasePage({super.key});

  @override
  State<VideoShowcasePage> createState() => _VideoShowcasePageState();
}

class _VideoShowcasePageState extends State<VideoShowcasePage> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dynamicTheme = DynamicTheme(themeProvider);
    final isMobile = AppTheme.isMobile(context);

    // Filter components that have a videoUrl and match category/search
    var filteredComponents = ComponentRegistry.all
        .where((c) => c.videoUrl != null && c.videoUrl!.isNotEmpty)
        .toList();

    if (_selectedCategory != 'All') {
      filteredComponents = filteredComponents
          .where((c) => c.category == _selectedCategory)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filteredComponents = filteredComponents
          .where((c) =>
              c.displayName.toLowerCase().contains(query) ||
              c.description.toLowerCase().contains(query))
          .toList();
    }

    final categories = [
      'All',
      ...ComponentRegistry.all
          .where((c) => c.videoUrl != null && c.videoUrl!.isNotEmpty)
          .map((c) => c.category)
          .toSet()
          .toList()
        ..sort()
    ];

    // Featured video is the last one added (or we could pick a specific one)
    final featuredComponent =
        filteredComponents.isNotEmpty ? filteredComponents.last : null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Animation
          KruiAnimatedGradientBackground(
            colors: [
              dynamicTheme.surface,
              dynamicTheme.primary.withValues(alpha: 0.1),
              dynamicTheme.surface,
              Colors.purpleAccent.withValues(alpha: 0.05),
            ],
          ),

          CustomScrollView(
            slivers: [
              // Hero Section
              SliverToBoxAdapter(
                child: _buildHeroSection(
                    context, featuredComponent, isMobile, dynamicTheme),
              ),

              // Filter Bar
              SliverPersistentHeader(
                pinned: true,
                delegate: _FilterBarDelegate(
                  child: _buildFilterBar(
                      context, categories, isMobile, dynamicTheme),
                ),
              ),

              // Video Grid
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 48,
                  vertical: 32,
                ),
                sliver: filteredComponents.isEmpty
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: _buildEmptyState(dynamicTheme),
                      )
                    : SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile
                              ? 1
                              : (MediaQuery.of(context).size.width > 1600
                                  ? 3
                                  : 2),
                          crossAxisSpacing: 32,
                          mainAxisSpacing: 32,
                          mainAxisExtent: isMobile ? 460 : 540,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final component =
                                filteredComponents.reversed.toList()[index];
                            return _VideoCard(
                              component: component,
                              isMobile: isMobile,
                              dynamicTheme: dynamicTheme,
                            );
                          },
                          childCount: filteredComponents.length,
                        ),
                      ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, ComponentInfo? featured,
      bool isMobile, DynamicTheme dynamicTheme) {
    if (featured == null) {
      return Padding(
        padding:
            EdgeInsets.fromLTRB(isMobile ? 24 : 48, 64, isMobile ? 24 : 48, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Video Showcase',
              style: (isMobile
                      ? AppTheme.h1.copyWith(fontSize: 32)
                      : AppTheme.h1.copyWith(fontSize: 56))
                  .copyWith(color: dynamicTheme.textPrimary),
            ),
            const SizedBox(height: 16),
            Text(
              'Master kr_ui with our high-quality video tutorials and shorts.',
              style: AppTheme.bodyLarge.copyWith(
                color: dynamicTheme.textSecondary,
                fontSize: 20,
              ),
            ),
          ],
        ),
      );
    }

    final videoId = _parseYoutubeId(featured.videoUrl!);
    final thumbnailUrl = videoId != null
        ? 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg'
        : null;

    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.fromLTRB(isMobile ? 24 : 48, 64, isMobile ? 24 : 48, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(FontAwesomeIcons.youtube,
                    color: Colors.red, size: 24),
              ),
              const SizedBox(width: 16),
              Text(
                'LATEST TUTORIAL',
                style: AppTheme.label.copyWith(
                  color: dynamicTheme.primary,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final useVertical = isMobile || constraints.maxWidth < 900;

              final content = [
                // Featured Video Preview
                Expanded(
                  flex: useVertical ? 0 : 3,
                  child: KruiGradientBorder(
                    style: KruiGradientBorderStyle(
                      colors: [
                        dynamicTheme.primary,
                        Colors.purpleAccent,
                        dynamicTheme.primary
                      ],
                      borderWidth: 3,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    variant: KruiGradientBorderVariant.rotating,
                    child: KruiGlassyCard(
                      borderRadius: BorderRadius.circular(21),
                      padding: EdgeInsets.zero,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: InkWell(
                          onTap: () => launchUrl(Uri.parse(featured.videoUrl!)),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (thumbnailUrl != null)
                                Image.network(
                                  thumbnailUrl,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Container(color: Colors.black26),
                                ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.6),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.3)),
                                ),
                                child: const Icon(FontAwesomeIcons.play,
                                    color: Colors.white, size: 40),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                if (!useVertical) const SizedBox(width: 48),
                if (useVertical) const SizedBox(height: 32),

                // Featured Info
                Expanded(
                  flex: useVertical ? 0 : 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: dynamicTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color:
                                  dynamicTheme.primary.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          featured.category,
                          style: AppTheme.caption.copyWith(
                            color: dynamicTheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        featured.displayName,
                        style: (isMobile
                                ? AppTheme.h1
                                : AppTheme.h1.copyWith(fontSize: 48))
                            .copyWith(
                                color: dynamicTheme.textPrimary, height: 1.1),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        featured.description,
                        style: AppTheme.bodyLarge.copyWith(
                          color: dynamicTheme.textSecondary,
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          KruiGlassyButton(
                            onPressed: () =>
                                launchUrl(Uri.parse(featured.videoUrl!)),
                            color: Colors.red,
                            child: const Row(
                              children: [
                                Icon(FontAwesomeIcons.youtube, size: 18),
                                SizedBox(width: 12),
                                Text('Watch Now'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          KruiGlassyButton(
                            onPressed: () =>
                                context.go('/components/${featured.id}'),
                            child: const Text('Documentation'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ];

              return useVertical
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: content)
                  : Row(children: content);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context, List<String> categories,
      bool isMobile, DynamicTheme dynamicTheme) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 48),
          decoration: BoxDecoration(
            color: dynamicTheme.surface.withValues(alpha: 0.8),
            border: Border(
              bottom: BorderSide(color: dynamicTheme.borderLight, width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((cat) {
                      final isSelected = cat == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: KruiGlassyButton(
                          onPressed: () =>
                              setState(() => _selectedCategory = cat),
                          color: isSelected
                              ? dynamicTheme.primary
                              : dynamicTheme.surfaceCard,
                          blur: isSelected ? 12 : 8,
                          opacity: isSelected ? 0.3 : 0.1,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : dynamicTheme.textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 24),
                SizedBox(
                  width: 300,
                  height: 44,
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search videos...',
                      prefixIcon:
                          Icon(Icons.search, color: dynamicTheme.textTertiary),
                      filled: true,
                      fillColor:
                          dynamicTheme.surfaceCard.withValues(alpha: 0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: dynamicTheme.borderLight),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: dynamicTheme.borderLight),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: dynamicTheme.primary),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    style: TextStyle(color: dynamicTheme.textPrimary),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(DynamicTheme dynamicTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_library_outlined,
              size: 80,
              color: dynamicTheme.textTertiary.withValues(alpha: 0.3)),
          const SizedBox(height: 24),
          Text(
            'No videos found',
            style: AppTheme.h2.copyWith(color: dynamicTheme.textSecondary),
          ),
          const SizedBox(height: 12),
          Text(
            'Try adjusting your search or filters',
            style:
                AppTheme.bodyLarge.copyWith(color: dynamicTheme.textTertiary),
          ),
          const SizedBox(height: 32),
          KruiGlassyButton(
            onPressed: () => setState(() {
              _selectedCategory = 'All';
              _searchQuery = '';
            }),
            child: const Text('Reset Filters'),
          ),
        ],
      ),
    );
  }

  String? _parseYoutubeId(String url) {
    if (url.contains('youtu.be/')) {
      return url.split('youtu.be/').last.split('?').first;
    } else if (url.contains('youtube.com/shorts/')) {
      return url.split('youtube.com/shorts/').last.split('?').first;
    } else if (url.contains('youtube.com/watch')) {
      final uri = Uri.parse(url);
      return uri.queryParameters['v'];
    }
    return null;
  }
}

class _VideoCard extends StatefulWidget {
  final ComponentInfo component;
  final bool isMobile;
  final DynamicTheme dynamicTheme;

  const _VideoCard({
    required this.component,
    required this.isMobile,
    required this.dynamicTheme,
  });

  @override
  State<_VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<_VideoCard> {
  bool _isHovered = false;

  String? _parseYoutubeId(String url) {
    if (url.contains('youtu.be/')) {
      return url.split('youtu.be/').last.split('?').first;
    } else if (url.contains('youtube.com/shorts/')) {
      return url.split('youtube.com/shorts/').last.split('?').first;
    } else if (url.contains('youtube.com/watch')) {
      final uri = Uri.parse(url);
      return uri.queryParameters['v'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final videoId = _parseYoutubeId(widget.component.videoUrl!);
    final thumbnailUrl = videoId != null
        ? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg'
        : null;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.translationValues(0.0, _isHovered ? -8.0 : 0.0, 0.0),
        child: KruiGradientBorder(
          style: KruiGradientBorderStyle(
            colors: _isHovered
                ? [
                    widget.dynamicTheme.primary,
                    Colors.purpleAccent,
                    widget.dynamicTheme.primary
                  ]
                : [
                    widget.dynamicTheme.borderLight,
                    widget.dynamicTheme.borderLight
                  ],
            borderWidth: _isHovered ? 2 : 1,
            borderRadius: BorderRadius.circular(20),
          ),
          variant: _isHovered
              ? KruiGradientBorderVariant.shimmer
              : KruiGradientBorderVariant.staticGradient,
          child: KruiGlassyCard(
            borderRadius: BorderRadius.circular(18),
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video Preview
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: InkWell(
                    onTap: () =>
                        launchUrl(Uri.parse(widget.component.videoUrl!)),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (thumbnailUrl != null)
                          Image.network(
                            thumbnailUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(color: Colors.black12),
                          ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.4),
                              ],
                            ),
                          ),
                        ),
                        AnimatedScale(
                          scale: _isHovered ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3)),
                            ),
                            child: const Icon(FontAwesomeIcons.play,
                                color: Colors.white, size: 24),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: (_isHovered ? Colors.red : Colors.black)
                                  .withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              widget.component.videoUrl!.contains('shorts')
                                  ? 'SHORTS'
                                  : 'TUTORIAL',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(widget.component.icon,
                                size: 18, color: widget.dynamicTheme.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.component.displayName,
                                style: AppTheme.h3.copyWith(
                                  color: widget.dynamicTheme.textPrimary,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.component.description,
                          style: AppTheme.bodyMedium.copyWith(
                            color: widget.dynamicTheme.textSecondary,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: KruiGlassyButton(
                                onPressed: () => context
                                    .go('/components/${widget.component.id}'),
                                child: const Text('Doc'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: KruiGlassyButton(
                                onPressed: () => launchUrl(
                                    Uri.parse(widget.component.videoUrl!)),
                                color: Colors.red,
                                opacity: 0.15,
                                child: const Text('Watch'),
                              ),
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
      ),
    );
  }
}

class _FilterBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _FilterBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
