import 'package:flutter/material.dart';
import 'package:nestless_flutter/nestless_flutter.dart';

import '../theme/app_spacing.dart';

class AppSection extends StatelessWidget {
  final String? title;
  final Widget child;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final bool useCard;

  const AppSection({
    super.key,
    required this.child,
    this.title,
    this.trailing,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.useCard = true,
  });

  Widget? _buildHeader(BuildContext context) {
    if (title == null && trailing == null) {
      return null;
    }

    return NRow(
      children: [
        if (title != null)
          Text(
            title!,
            style: Theme.of(context).textTheme.titleMedium,
          ).nExpanded(),

        if (trailing != null)
          trailing!,
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final header = _buildHeader(context);

    return NColumn(
      padding: padding,
      gap: AppSpacing.md,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null)
          header,

        child,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = _buildContent(context);

    if (!useCard) {
      return content;
    }

    return Card(
      child: content,
    );
  }
}

// import 'package:flutter/material.dart';

// import '../theme/app_spacing.dart';

// class AppSection extends StatelessWidget {
//   final String? title;
//   final Widget child;
//   final Widget? trailing;
//   final EdgeInsetsGeometry padding;
//   final bool useCard;

//   const AppSection({
//     super.key,
//     required this.child,
//     this.title,
//     this.trailing,
//     this.padding = const EdgeInsets.all(AppSpacing.md),
//     this.useCard = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final content = Padding(
//       padding: padding,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (title != null || trailing != null) ...[
//             Row(
//               children: [
//                 if (title != null)
//                   Expanded(
//                     child: Text(
//                       title!,
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                   ),
//                 if (trailing != null) trailing!,
//               ],
//             ),
//             const SizedBox(height: AppSpacing.md),
//           ],
//           child,
//         ],
//       ),
//     );

//     if (!useCard) {
//       return content;
//     }

//     return Card(
//       child: content,
//     );
//   }
// }
