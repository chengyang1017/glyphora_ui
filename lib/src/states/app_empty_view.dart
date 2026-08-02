import 'package:flutter/material.dart';
import 'package:nestless_flutter/nestless_flutter.dart';

import '../buttons/app_button.dart';
import '../theme/app_spacing.dart';

class AppEmptyView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionText;
  final VoidCallback? onAction;

  const AppEmptyView({
    super.key,
    this.icon = Icons.inbox_outlined,
    required this.title,
    this.message,
    this.actionText,
    this.onAction,
  });

  Widget _buildIcon(BuildContext context) {
    return Icon(
      icon,
      size: 48,
      color: Theme.of(context).colorScheme.outline,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium,
    ).nPadOnly(
      top: AppSpacing.md,
    );
  }

  Widget? _buildMessage() {
    if (message == null) return null;

    return Text(
      message!,
      textAlign: TextAlign.center,
    ).nPadOnly(
      top: AppSpacing.sm,
    );
  }

  Widget? _buildAction() {
    if (actionText == null || onAction == null) {
      return null;
    }

    return AppButton(
      onPressed: onAction,
      child: Text(actionText!),
    ).nPadOnly(
      top: AppSpacing.md,
    );
  }

  List<Widget> _buildChildren(
    BuildContext context,
  ) {
    return [
      _buildIcon(context),
      _buildTitle(context),

      if (_buildMessage() case final message?)
        message,

      if (_buildAction() case final action?)
        action,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return NColumn(
      mainAxisSize: MainAxisSize.min,
      children: _buildChildren(context),
    )
        .nPadAll(AppSpacing.lg)
        .nConstrained(
          const BoxConstraints(
            maxWidth: 420,
          ),
        )
        .nCenter();
  }
}

// import 'package:flutter/material.dart';

// import '../buttons/app_button.dart';
// import '../theme/app_spacing.dart';

// class AppEmptyView extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String? message;
//   final String? actionText;
//   final VoidCallback? onAction;

//   const AppEmptyView({
//     super.key,
//     this.icon = Icons.inbox_outlined,
//     required this.title,
//     this.message,
//     this.actionText,
//     this.onAction,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(
//           maxWidth: 420,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(AppSpacing.lg),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 icon,
//                 size: 48,
//                 color: Theme.of(context).colorScheme.outline,
//               ),
//               const SizedBox(height: AppSpacing.md),
//               Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//               if (message != null) ...[
//                 const SizedBox(height: AppSpacing.sm),
//                 Text(
//                   message!,
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//               if (actionText != null && onAction != null) ...[
//                 const SizedBox(height: AppSpacing.md),
//                 AppButton(
//                   onPressed: onAction,
//                   child: Text(actionText!),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
