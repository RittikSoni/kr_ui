import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final ComponentInfo kruiSkeletonShimmerInfo = ComponentInfo(
  id: 'skeleton-shimmer',
  name: 'KruiSkeletonShimmer',
  displayName: 'Skeleton Shimmer',
  description:
      'Advanced skeleton loader with gradient wave shimmer and pre-built shape components for loading states.',
  category: 'Feedback',
  icon: Icons.animation,
  properties: const [
    PropertyInfo(
      name: 'child',
      type: 'Widget',
      defaultValue: 'required',
      description: 'Child widget containing skeleton shapes.',
    ),
    PropertyInfo(
      name: 'baseColor',
      type: 'Color',
      defaultValue: 'Color(0xFFE0E0E0)',
      description: 'Base color of skeleton.',
    ),
    PropertyInfo(
      name: 'highlightColor',
      type: 'Color',
      defaultValue: 'Color(0xFFF5F5F5)',
      description: 'Highlight color of shimmer wave.',
    ),
    PropertyInfo(
      name: 'duration',
      type: 'Duration',
      defaultValue: '1500ms',
      description: 'Animation duration for one complete wave.',
    ),
    PropertyInfo(
      name: 'direction',
      type: 'ShimmerDirection',
      defaultValue: 'leftToRight',
      description: 'Wave direction (LTR, RTL, TTB, BTT).',
    ),
    PropertyInfo(
      name: 'enabled',
      type: 'bool',
      defaultValue: 'true',
      description: 'Enable shimmer animation.',
    ),
  ],
  basicExample: '''KruiSkeletonShimmer(
  child: Column(
    children: [
      SkeletonLine(width: 200),
      SizedBox(height: 12),
      SkeletonLine(width: 150),
      SizedBox(height: 16),
      SkeletonCircle(size: 48),
    ],
  ),
)''',
  advancedExample: '''KruiSkeletonShimmer(
  baseColor: Color(0xFF2A2A2A),
  highlightColor: Color(0xFF3A3A3A),
  direction: ShimmerDirection.leftToRight,
  duration: Duration(milliseconds: 1200),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          SkeletonCircle(size: 60),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(width: 120, height: 16),
              SizedBox(height: 8),
              SkeletonLine(width: 80, height: 12),
            ],
          ),
        ],
      ),
      SizedBox(height: 20),
      SkeletonLine(height: 20),
      SizedBox(height: 12),
      SkeletonLine(width: 250),
      SizedBox(height: 12),
      SkeletonLine(width: 180),
    ],
  ),
)''',
  presets: [
    PresetInfo(
      name: 'Profile Loading',
      description: 'User profile skeleton',
      code: '''KruiSkeletonShimmer(
  child: Column(
    children: [
      SkeletonCircle(size: 80),
      SkeletonLine(width: 150),
    ],
  ),
);''',
      builder: () {
        return Container(
          padding: const EdgeInsets.all(24),
          color: Colors.white,
          child: KruiSkeletonShimmer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SkeletonCircle(size: 80),
                const SizedBox(height: 16),
                SkeletonLine(width: 150, height: 20),
                const SizedBox(height: 8),
                SkeletonLine(width: 100, height: 14),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SkeletonLine(width: 60, height: 16),
                        const SizedBox(height: 4),
                        SkeletonLine(width: 40, height: 12),
                      ],
                    ),
                    const SizedBox(width: 32),
                    Column(
                      children: [
                        SkeletonLine(width: 60, height: 16),
                        const SizedBox(height: 4),
                        SkeletonLine(width: 40, height: 12),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
    PresetInfo(
      name: 'Card Grid',
      description: 'Loading cards in grid',
      code: '''KruiSkeletonShimmer(
  child: Wrap(
    children: [
      SkeletonCard(width: 150, height: 180),
    ],
  ),
);''',
      builder: () {
        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade100,
          child: KruiSkeletonShimmer(
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                const SkeletonCard(width: 150, height: 180),
                const SkeletonCard(width: 150, height: 180),
              ],
            ),
          ),
        );
      },
    ),
    PresetInfo(
      name: 'List Items',
      description: 'Loading list with avatars',
      code: '''KruiSkeletonShimmer(
  child: Column(
    children: [
      Row(
        children: [
          SkeletonCircle(size: 48),
          SkeletonLine(width: 140),
        ],
      ),
    ],
  ),
);''',
      builder: () {
        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: KruiSkeletonShimmer(
            child: Column(
              children: List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      const SkeletonCircle(size: 48),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLine(width: 140, height: 16),
                            const SizedBox(height: 8),
                            SkeletonLine(width: 100, height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  ],
  demoBuilder: () {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: KruiSkeletonShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SkeletonCircle(size: 64),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(width: 160, height: 18),
                      const SizedBox(height: 8),
                      SkeletonLine(width: 120, height: 14),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const SkeletonLine(height: 16),
            const SizedBox(height: 12),
            SkeletonLine(width: 280, height: 16),
            const SizedBox(height: 12),
            SkeletonLine(width: 200, height: 16),
          ],
        ),
      ),
    );
  },
);
