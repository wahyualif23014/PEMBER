import 'package:flutter/material.dart';
import 'package:absolute_cinema/themes/colors.dart';

class SkeletonHomeLoader extends StatelessWidget {
  const SkeletonHomeLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Container(height: 40, color: AppColors.skeletonDark),
                const SizedBox(height: 10),
                Container(height: 30, color: AppColors.skeletonLight),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: Container(
            height: 180,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: AppColors.skeletonDark,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ...List.generate(
          2,
          (index) => SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 120,
                    color: AppColors.skeletonLight,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(
                      3,
                      (i) => Expanded(
                        child: Container(
                          height: 150,
                          margin: const EdgeInsets.only(right: 8),
                          color: AppColors.skeletonDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
