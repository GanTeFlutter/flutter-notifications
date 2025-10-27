part of '../home_view.dart';

final class _CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _CustomAppBar({
    required this.tooltip,
    required this.title,
    this.onPressed,
  });

  final String tooltip;
  final String title;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onPressed,
          tooltip: tooltip,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
