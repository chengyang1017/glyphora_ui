import 'package:flutter/material.dart';
import 'package:nestless_flutter/nestless_flutter.dart';

import '../theme/app_spacing.dart';

class AppPage extends StatelessWidget {
  final String? title;
  final Widget body;
  final List<Widget> actions;
  final Widget? leading;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final EdgeInsetsGeometry padding;
  final bool safeArea;
  final bool scrollable;
  final double? maxContentWidth;

  const AppPage({
    super.key,
    required this.body,
    this.title,
    this.actions = const [],
    this.leading,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.padding =
        const EdgeInsets.all(AppSpacing.md),
    this.safeArea = true,
    this.scrollable = false,
    this.maxContentWidth,
  });

  bool get _hasAppBar {
    return title != null ||
        leading != null ||
        actions.isNotEmpty;
  }

  PreferredSizeWidget? _buildAppBar() {
    if (!_hasAppBar) return null;

    return AppBar(
      title: title == null
          ? null
          : Text(title!),
      leading: leading,
      actions: actions,
    );
  }

  Widget _buildBody() {
    return body
        .nBox(
          padding: padding,
        )
        .nMaxWidth(
          maxContentWidth,
        )
        .nScrollYIf(
          scrollable,
        )
        .nSafeAreaIf(
          safeArea,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton:
          floatingActionButton,
      bottomNavigationBar:
          bottomNavigationBar,
    );
  }
}

// import 'package:flutter/material.dart';

// import '../theme/app_spacing.dart';

// class AppPage extends StatelessWidget {
//   final String? title;
//   final Widget body;
//   final List<Widget> actions;
//   final Widget? leading;
//   final Widget? floatingActionButton;
//   final Widget? bottomNavigationBar;
//   final EdgeInsetsGeometry padding;
//   final bool safeArea;
//   final bool scrollable;
//   final double? maxContentWidth;

//   const AppPage({
//     super.key,
//     required this.body,
//     this.title,
//     this.actions = const [],
//     this.leading,
//     this.floatingActionButton,
//     this.bottomNavigationBar,
//     this.padding = const EdgeInsets.all(AppSpacing.md),
//     this.safeArea = true,
//     this.scrollable = false,
//     this.maxContentWidth,
//   });

//   @override
//   Widget build(BuildContext context) {
//     Widget content = Padding(
//       padding: padding,
//       child: body,
//     );

//     if (maxContentWidth != null) {
//       content = Align(
//         alignment: Alignment.topCenter,
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             maxWidth: maxContentWidth!,
//           ),
//           child: content,
//         ),
//       );
//     }

//     if (scrollable) {
//       content = SingleChildScrollView(
//         child: content,
//       );
//     }

//     if (safeArea) {
//       content = SafeArea(
//         child: content,
//       );
//     }

//     return Scaffold(
//       appBar: title == null && leading == null && actions.isEmpty
//           ? null
//           : AppBar(
//               title: title == null ? null : Text(title!),
//               leading: leading,
//               actions: actions,
//             ),
//       body: content,
//       floatingActionButton: floatingActionButton,
//       bottomNavigationBar: bottomNavigationBar,
//     );
//   }
// }
