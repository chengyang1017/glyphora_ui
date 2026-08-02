import 'package:flutter/material.dart';
import 'package:nestless_flutter/nestless_flutter.dart';

import '../theme/app_spacing.dart';

class AppLoadingView extends StatelessWidget {
  final String? message;

  const AppLoadingView({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return NColumn(
      gap: AppSpacing.md,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),

        if (message != null)
          Text(message!),
      ],
    ).nCenter();
  }
}

// import 'package:flutter/material.dart';

// import '../theme/app_spacing.dart';

// class AppLoadingView extends StatelessWidget {
//   final String? message;

//   const AppLoadingView({
//     super.key,
//     this.message,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const CircularProgressIndicator(),
//           if (message != null) ...[
//             const SizedBox(height: AppSpacing.md),
//             Text(message!),
//           ],
//         ],
//       ),
//     );
//   }
// }
