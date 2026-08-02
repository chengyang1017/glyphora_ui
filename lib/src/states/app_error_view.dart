import 'package:flutter/material.dart';
import 'package:nestless_flutter/nestless_flutter.dart';

import '../buttons/app_button.dart';
import '../theme/app_spacing.dart';

class AppErrorView extends StatelessWidget {
  final String title;
  final String? message;
  final String retryText;
  final VoidCallback? onRetry;

  const AppErrorView({
    super.key,
    this.title = '加载失败',
    this.message,
    this.retryText = '重试',
    this.onRetry,
  });

  Widget _buildIcon(BuildContext context) {
    return Icon(
      Icons.error_outline,
      size: 48,
      color: Theme.of(context).colorScheme.error,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _buildTextSection(BuildContext context) {
    return NColumn(
      gap: AppSpacing.sm,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTitle(context),

        if (message != null)
          Text(
            message!,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  Widget? _buildRetryButton() {
    if (onRetry == null) return null;

    return AppButton(
      onPressed: onRetry,
      child: Text(retryText),
    );
  }

  @override
  Widget build(BuildContext context) {
    final retryButton = _buildRetryButton();

    return NColumn(
      constraints: const BoxConstraints(
        maxWidth: 420,
      ),
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      gap: AppSpacing.md,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildIcon(context),
        _buildTextSection(context),

        if (retryButton != null)
          retryButton,
      ],
    ).nCenter();
  }
}

// import 'package:flutter/material.dart';

// import '../buttons/app_button.dart';
// import '../theme/app_spacing.dart';

// class AppErrorView extends StatelessWidget {
//   final String title;
//   final String? message;
//   final String retryText;
//   final VoidCallback? onRetry;

//   const AppErrorView({
//     super.key,
//     this.title = '加载失败',
//     this.message,
//     this.retryText = '重试',
//     this.onRetry,
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
//                 Icons.error_outline,
//                 size: 48,
//                 color: Theme.of(context).colorScheme.error,
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
//               if (onRetry != null) ...[
//                 const SizedBox(height: AppSpacing.md),
//                 AppButton(
//                   onPressed: onRetry,
//                   child: Text(retryText),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
