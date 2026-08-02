import 'package:flutter/material.dart';
import 'package:nestless_flutter/nestless_flutter.dart';

import 'app_button.dart';

class AsyncButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final Widget child;
  final AppButtonStyle style;
  final bool expand;
  final IconData? icon;
  final Widget? loadingChild;
  final void Function(
    Object error,
    StackTrace stackTrace,
  )? onError;

  const AsyncButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style = AppButtonStyle.filled,
    this.expand = false,
    this.icon,
    this.loadingChild,
    this.onError,
  });

  @override
  State<AsyncButton> createState() {
    return _AsyncButtonState();
  }
}

class _AsyncButtonState extends State<AsyncButton> {
  bool _isLoading = false;

  Widget get _buttonChild {
    if (!_isLoading) {
      return widget.child;
    }

    return widget.loadingChild ??
        const CircularProgressIndicator(
          strokeWidth: 2,
        ).nSize(
          width: 18,
          height: 18,
        );
  }

  Future<void> _handlePressed() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onPressed();
    } catch (error, stackTrace) {
      widget.onError?.call(
        error,
        stackTrace,
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed:
          _isLoading ? null : _handlePressed,
      style: widget.style,
      expand: widget.expand,
      icon:
          _isLoading ? null : widget.icon,
      child: _buttonChild,
    );
  }
}
//--------------------------------------------------------------------------------

// import 'package:flutter/material.dart';

// import 'app_button.dart';

// class AsyncButton extends StatefulWidget {
//   final Future<void> Function() onPressed;
//   final Widget child;
//   final AppButtonStyle style;
//   final bool expand;
//   final IconData? icon;
//   final Widget? loadingChild;
//   final void Function(Object error, StackTrace stackTrace)? onError;

//   const AsyncButton({
//     super.key,
//     required this.onPressed,
//     required this.child,
//     this.style = AppButtonStyle.filled,
//     this.expand = false,
//     this.icon,
//     this.loadingChild,
//     this.onError,
//   });

//   @override
//   State<AsyncButton> createState() => _AsyncButtonState();
// }

// class _AsyncButtonState extends State<AsyncButton> {
//   bool _isLoading = false;

//   Future<void> _handlePressed() async {
//     if (_isLoading) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       await widget.onPressed();
//     } catch (error, stackTrace) {
//       widget.onError?.call(error, stackTrace);
//     } finally {
//       if (!mounted) return;

//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppButton(
//       onPressed: _isLoading ? null : _handlePressed,
//       style: widget.style,
//       expand: widget.expand,
//       icon: _isLoading ? null : widget.icon,
//       child: _isLoading
//           ? widget.loadingChild ?? const _DefaultLoadingChild()
//           : widget.child,
//     );
//   }
// }

// class _DefaultLoadingChild extends StatelessWidget {
//   const _DefaultLoadingChild();

//   @override
//   Widget build(BuildContext context) {
//     return const SizedBox.square(
//       dimension: 18,
//       child: CircularProgressIndicator(
//         strokeWidth: 2,
//       ),
//     );
//   }
// }
