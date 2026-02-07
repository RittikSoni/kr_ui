import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A highly customizable carousel slider with enterprise-grade features.
///
/// Supports dual styling modes (glass/simple), multiple transition effects,
/// auto-play, infinite loop, gesture controls, keyboard navigation, and more.
///
/// Example:
/// ```dart
/// KruiCarousel(
///   items: [
///     Container(color: Colors.red, child: Center(child: Text('Slide 1'))),
///     Container(color: Colors.blue, child: Center(child: Text('Slide 2'))),
///     Container(color: Colors.green, child: Center(child: Text('Slide 3'))),
///   ],
///   autoPlay: true,
///   showIndicators: true,
/// )
/// ```
class KruiCarousel extends StatefulWidget {
  /// List of widgets to display in the carousel
  final List<Widget> items;

  /// Carousel height (overridden by aspectRatio if provided)
  final double height;

  /// Aspect ratio (width / height). If provided, overrides height
  final double? aspectRatio;

  /// Styling mode: glass (glassmorphic) or simple (modern minimal)
  final CarouselStyleMode styleMode;

  /// Enable auto-play
  final bool autoPlay;

  /// Duration between auto-play transitions
  final Duration autoPlayDuration;

  /// Reverse auto-play direction
  final bool autoPlayReverse;

  /// Pause auto-play on hover
  final bool pauseOnHover;

  /// Pause auto-play on manual interaction
  final bool pauseOnInteraction;

  /// Enable infinite loop
  final bool infinite;

  /// Transition animation type
  final CarouselTransitionType transitionType;

  /// Transition animation duration
  final Duration transitionDuration;

  /// Transition animation curve
  final Curve transitionCurve;

  /// Custom enter animation curve (overrides transitionCurve for enter)
  final Curve? enterCurve;

  /// Custom exit animation curve (overrides transitionCurve for exit)
  final Curve? exitCurve;

  /// Indicator style
  final CarouselIndicatorType indicatorType;

  /// Show pagination indicators
  final bool showIndicators;

  /// Indicator position
  final IndicatorPosition indicatorPosition;

  /// Show navigation arrows
  final bool showArrows;

  /// Show arrows only on hover
  final bool arrowsOnHover;

  /// Arrow position
  final ArrowPosition arrowPosition;

  /// Enable touch/swipe gestures
  final bool enableGestures;

  /// Swipe sensitivity threshold (in pixels)
  final double gestureThreshold;

  /// Enable keyboard navigation
  final bool enableKeyboard;

  /// Item width fraction (0.0 to 1.0, allows peek effect)
  final double viewportFraction;

  /// Clip behavior
  final Clip clipBehavior;

  /// External controller for programmatic control
  final CarouselController? controller;

  /// Callback when page changes
  final void Function(int index)? onPageChanged;

  /// Container background color
  final Color? backgroundColor;

  /// Container border radius
  final double borderRadius;

  /// Glass mode blur intensity (only for glass mode)
  final double blurIntensity;

  /// Glass mode opacity (only for glass mode)
  final double glassOpacity;

  /// Padding around carousel content
  final EdgeInsets padding;

  const KruiCarousel({
    super.key,
    required this.items,
    this.height = 300,
    this.aspectRatio,
    this.styleMode = CarouselStyleMode.glass,
    this.autoPlay = false,
    this.autoPlayDuration = const Duration(seconds: 3),
    this.autoPlayReverse = false,
    this.pauseOnHover = true,
    this.pauseOnInteraction = true,
    this.infinite = true,
    this.transitionType = CarouselTransitionType.slide,
    this.transitionDuration = const Duration(milliseconds: 500),
    this.transitionCurve = Curves.easeInOutCubic,
    this.enterCurve,
    this.exitCurve,
    this.indicatorType = CarouselIndicatorType.dots,
    this.showIndicators = true,
    this.indicatorPosition = IndicatorPosition.bottom,
    this.showArrows = true,
    this.arrowsOnHover = false,
    this.arrowPosition = ArrowPosition.inside,
    this.enableGestures = true,
    this.gestureThreshold = 50.0,
    this.enableKeyboard = true,
    this.viewportFraction = 1.0,
    this.clipBehavior = Clip.hardEdge,
    this.controller,
    this.onPageChanged,
    this.backgroundColor,
    this.borderRadius = 16,
    this.blurIntensity = 10.0,
    this.glassOpacity = 0.15,
    this.padding = EdgeInsets.zero,
  })  : assert(items.length > 0, 'Items list cannot be empty'),
        assert(viewportFraction > 0 && viewportFraction <= 1.0,
            'viewportFraction must be between 0.0 and 1.0');

  @override
  State<KruiCarousel> createState() => _KruiCarouselState();
}

class _KruiCarouselState extends State<KruiCarousel>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late CarouselController _controller;
  int _currentPage = 0;
  Timer? _autoPlayTimer;
  bool _isHovering = false;
  bool _userInteracted = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Initialize page controller
    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
      initialPage: widget.infinite ? _calculateInfiniteInitialPage() : 0,
    );

    // Initialize controller
    _controller = widget.controller ?? CarouselController();
    _controller._attach(this);

    // Start auto-play if enabled
    if (widget.autoPlay && widget.items.length > 1) {
      _startAutoPlay();
    }
  }

  @override
  void didUpdateWidget(KruiCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update page controller if viewport fraction changed
    if (oldWidget.viewportFraction != widget.viewportFraction) {
      _pageController.dispose();
      _pageController = PageController(
        viewportFraction: widget.viewportFraction,
        initialPage: _currentPage,
      );
    }

    // Update auto-play
    if (widget.autoPlay && widget.items.length > 1) {
      if (!oldWidget.autoPlay ||
          oldWidget.autoPlayDuration != widget.autoPlayDuration) {
        _startAutoPlay();
      }
    } else {
      _stopAutoPlay();
    }
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _pageController.dispose();
    _focusNode.dispose();
    _controller._detach();
    super.dispose();
  }

  int _calculateInfiniteInitialPage() {
    // For infinite scrolling, start at a high offset to allow backward scrolling
    return widget.items.length * 1000;
  }

  void _startAutoPlay() {
    _stopAutoPlay();
    if (widget.items.length <= 1) return;

    _autoPlayTimer = Timer.periodic(widget.autoPlayDuration, (_) {
      if (!_isHovering || !widget.pauseOnHover) {
        if (!_userInteracted || !widget.pauseOnInteraction) {
          _animateToNextPage(widget.autoPlayReverse);
        }
      }
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  void _animateToNextPage(bool reverse) {
    if (!_pageController.hasClients) return;

    final currentPage = _pageController.page?.round() ?? 0;
    final nextPage = reverse ? currentPage - 1 : currentPage + 1;

    // Handle boundaries for non-infinite mode
    if (!widget.infinite) {
      if (nextPage < 0 || nextPage >= widget.items.length) {
        return;
      }
    }

    _pageController.animateToPage(
      nextPage,
      duration: widget.transitionDuration,
      curve: widget.enterCurve ?? widget.transitionCurve,
    );
  }

  void _onPageChanged(int page) {
    final realPage = page % widget.items.length;
    setState(() {
      _currentPage = realPage;
    });
    widget.onPageChanged?.call(realPage);
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _animateToNextPage(true);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _animateToNextPage(false);
      }
    }
  }

  Widget _buildCarouselItem(BuildContext context, int index) {
    final realIndex = index % widget.items.length;
    final item = widget.items[realIndex];

    // Wrap in RepaintBoundary for performance
    return RepaintBoundary(
      child: item,
    );
  }

  Widget _buildPageView() {
    // Handle edge case: single item
    if (widget.items.length == 1) {
      return RepaintBoundary(
        child: Padding(
          padding: widget.padding,
          child: widget.items[0],
        ),
      );
    }

    return PageView.builder(
      controller: _pageController,
      physics: widget.enableGestures
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      onPageChanged: _onPageChanged,
      itemCount: widget.infinite ? null : widget.items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: widget.padding,
          child: _buildTransitionWrapper(context, index),
        );
      },
    );
  }

  Widget _buildTransitionWrapper(BuildContext context, int index) {
    // For basic slide transition, use default PageView behavior
    if (widget.transitionType == CarouselTransitionType.slide) {
      return _buildCarouselItem(context, index);
    }

    // For other transitions, use AnimatedBuilder to apply custom effects
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 1.0;
        if (_pageController.hasClients && _pageController.page != null) {
          value = _pageController.page! - index;
          value = (1 - (value.abs().clamp(0.0, 1.0))).clamp(0.0, 1.0);
        }

        return _applyTransition(context, child!, value, index);
      },
      child: _buildCarouselItem(context, index),
    );
  }

  Widget _applyTransition(
      BuildContext context, Widget child, double value, int index) {
    switch (widget.transitionType) {
      case CarouselTransitionType.fade:
        return Opacity(
          opacity: value,
          child: child,
        );

      case CarouselTransitionType.scale:
        final scale = 0.8 + (value * 0.2);
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );

      case CarouselTransitionType.cube:
        final rotationY = (1 - value) * 1.5708; // 90 degrees in radians
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateY(rotationY),
          alignment: Alignment.center,
          child: child,
        );

      case CarouselTransitionType.flip:
        final rotation = (1 - value) * 3.14159; // 180 degrees
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateX(rotation),
          alignment: Alignment.center,
          child: child,
        );

      case CarouselTransitionType.zoom:
        final scale = value;
        return Transform.scale(
          scale: scale,
          child: child,
        );

      case CarouselTransitionType.parallax:
        final offset = (1 - value) * 200;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );

      case CarouselTransitionType.slide:
        return child;
    }
  }

  Widget _buildIndicators() {
    if (!widget.showIndicators || widget.items.length <= 1) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: widget.indicatorPosition == IndicatorPosition.bottom ? 16 : null,
      top: widget.indicatorPosition == IndicatorPosition.top ? 16 : null,
      left: 0,
      right: 0,
      child: _buildIndicatorContent(),
    );
  }

  Widget _buildIndicatorContent() {
    switch (widget.indicatorType) {
      case CarouselIndicatorType.dots:
        return _buildDotIndicators();
      case CarouselIndicatorType.bars:
        return _buildBarIndicators();
      case CarouselIndicatorType.numbers:
        return _buildNumberIndicator();
      case CarouselIndicatorType.thumbnails:
        return _buildThumbnailIndicators();
      case CarouselIndicatorType.none:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDotIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.items.length, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color:
                isActive ? Colors.white : Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildBarIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.items.length, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: isActive ? 32 : 24,
          height: 4,
          decoration: BoxDecoration(
            color:
                isActive ? Colors.white : Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  Widget _buildNumberIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '${_currentPage + 1} / ${widget.items.length}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildThumbnailIndicators() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final isActive = index == _currentPage;
          return GestureDetector(
            onTap: () {
              _controller.animateToPage(index);
              setState(() {
                _userInteracted = true;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isActive ? Colors.white : Colors.transparent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: widget.items[index],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildArrows() {
    if (!widget.showArrows || widget.items.length <= 1) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildArrowButton(true),
          _buildArrowButton(false),
        ],
      ),
    );
  }

  Widget _buildArrowButton(bool isLeft) {
    final arrow = Material(
      color: widget.styleMode == CarouselStyleMode.glass
          ? Colors.black.withValues(alpha: 0.3)
          : Colors.black.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        onTap: () {
          _animateToNextPage(isLeft);
          setState(() {
            _userInteracted = true;
          });
        },
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(
            isLeft ? Icons.arrow_back_ios_new : Icons.arrow_forward_ios,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );

    if (widget.arrowsOnHover) {
      return AnimatedOpacity(
        opacity: _isHovering ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.arrowPosition == ArrowPosition.outside ? 0 : 16,
          ),
          child: arrow,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.arrowPosition == ArrowPosition.outside ? 0 : 16,
      ),
      child: arrow,
    );
  }

  Widget _buildContainer(Widget child) {
    if (widget.styleMode == CarouselStyleMode.glass) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.blurIntensity,
            sigmaY: widget.blurIntensity,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor ??
                  Colors.black.withValues(alpha: widget.glassOpacity),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      );
    } else {
      // Simple mode - no blur, clean design
      return Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.grey.shade900,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: child,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget carousel = ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      clipBehavior: widget.clipBehavior,
      child: Stack(
        children: [
          _buildPageView(),
          _buildIndicators(),
          _buildArrows(),
        ],
      ),
    );

    // Apply container styling
    carousel = _buildContainer(carousel);

    // Add hover detection
    carousel = MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: carousel,
    );

    // Add keyboard support
    if (widget.enableKeyboard) {
      carousel = KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: _handleKeyEvent,
        child: GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          child: carousel,
        ),
      );
    }

    // Apply aspect ratio or height
    if (widget.aspectRatio != null) {
      carousel = AspectRatio(
        aspectRatio: widget.aspectRatio!,
        child: carousel,
      );
    } else {
      carousel = SizedBox(
        height: widget.height,
        child: carousel,
      );
    }

    return carousel;
  }
}

/// Controller for programmatic carousel control
class CarouselController {
  _KruiCarouselState? _state;

  void _attach(_KruiCarouselState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  /// Get current page index
  int get currentPage => _state?._currentPage ?? 0;

  /// Animate to specific page
  void animateToPage(int page, {Duration? duration, Curve? curve}) {
    if (_state == null || !_state!._pageController.hasClients) return;

    final targetPage = _state!.widget.infinite
        ? (_state!._pageController.page?.round() ?? 0) +
            (page - _state!._currentPage)
        : page;

    _state!._pageController.animateToPage(
      targetPage,
      duration: duration ?? _state!.widget.transitionDuration,
      curve: curve ?? _state!.widget.transitionCurve,
    );
  }

  /// Jump to specific page without animation
  void jumpToPage(int page) {
    if (_state == null || !_state!._pageController.hasClients) return;

    final targetPage = _state!.widget.infinite
        ? (_state!._pageController.page?.round() ?? 0) +
            (page - _state!._currentPage)
        : page;

    _state!._pageController.jumpToPage(targetPage);
  }

  /// Go to next page
  void nextPage({Duration? duration, Curve? curve}) {
    if (_state == null) return;
    _state!._animateToNextPage(false);
  }

  /// Go to previous page
  void previousPage({Duration? duration, Curve? curve}) {
    if (_state == null) return;
    _state!._animateToNextPage(true);
  }

  /// Start auto-play
  void startAutoPlay() {
    _state?._startAutoPlay();
  }

  /// Stop auto-play
  void stopAutoPlay() {
    _state?._stopAutoPlay();
  }
}

/// Carousel styling mode
enum CarouselStyleMode {
  /// Glassmorphic style with blur and transparency
  glass,

  /// Simple modern style optimized for performance
  simple,
}

/// Carousel transition animation type
enum CarouselTransitionType {
  /// Standard slide transition
  slide,

  /// Fade in/out transition
  fade,

  /// Scale transition
  scale,

  /// 3D cube rotation transition
  cube,

  /// Flip transition
  flip,

  /// Zoom transition
  zoom,

  /// Parallax scroll transition
  parallax,
}

/// Carousel indicator type
enum CarouselIndicatorType {
  /// Dot indicators
  dots,

  /// Bar indicators
  bars,

  /// Thumbnail preview indicators
  thumbnails,

  /// Numeric indicator (1/5)
  numbers,

  /// No indicators
  none,
}

/// Indicator position on screen
enum IndicatorPosition {
  /// Bottom of carousel
  bottom,

  /// Top of carousel
  top,
}

/// Arrow button position
enum ArrowPosition {
  /// Inside carousel boundaries
  inside,

  /// Outside carousel boundaries
  outside,

  /// Overlay on carousel content
  overlay,
}
