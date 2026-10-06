import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/app_theme.dart';
import '../utils/launcher.dart';

/// Inserts [gap] between children (works in Row and Column).
List<Widget> gapped(List<Widget> children, double gap, {bool horizontal = false}) {
  final out = <Widget>[];
  for (var i = 0; i < children.length; i++) {
    if (i > 0) {
      out.add(horizontal ? SizedBox(width: gap) : SizedBox(height: gap));
    }
    out.add(children[i]);
  }
  return out;
}

/// Tan box with an icon + label. Pass [image] later to show a real photo.
class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({
    super.key,
    required this.label,
    this.height,
    this.width,
    this.radius = 20,
    this.iconSize = 22,
    this.icon = Icons.image_outlined,
    this.image,
  });

  final String label;
  final double? height;
  final double? width;
  final double radius;
  final double iconSize;
  final IconData icon;
  final ImageProvider? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.tan,
        borderRadius: BorderRadius.circular(radius),
        image: image == null
            ? null
            : DecorationImage(image: image!, fit: BoxFit.cover),
      ),
      child: image != null
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: iconSize, color: AppColors.muted),
                if (label.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppText.inter(
                        size: 10,
                        weight: FontWeight.w600,
                        color: AppColors.muted),
                  ),
                ],
              ],
            ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.fontSize = 20,
    this.padding = EdgeInsets.zero,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double fontSize;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppText.inter(
                  size: fontSize, weight: FontWeight.w700, height: 1.22),
            ),
          ),
          if (actionLabel != null)
            InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(actionLabel!,
                        style: AppText.inter(
                            size: 13,
                            weight: FontWeight.w600,
                            color: AppColors.primary)),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward,
                        size: 14, color: AppColors.primary),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PillChip extends StatelessWidget {
  const PillChip(
    this.label, {
    super.key,
    this.background = AppColors.tan,
    this.foreground = AppColors.primary,
    this.icon,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  });

  final String label;
  final Color background;
  final Color foreground;
  final IconData? icon;
  final double fontSize;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: foreground),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: AppText.inter(
                  size: fontSize,
                  weight: FontWeight.w600,
                  color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}

class WorkshopChip extends StatelessWidget {
  const WorkshopChip(this.status, {super.key, this.short = false});
  final WorkshopStatus status;
  final bool short;

  @override
  Widget build(BuildContext context) => PillChip(
        short ? status.shortLabel : status.label,
        background: status.background,
        foreground: status.foreground,
        fontSize: 10,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      );
}

enum AppButtonVariant { primary, outline, whatsapp }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.trailingIcon,
    this.expand = true,
    this.minHeight = 48,
    this.fontSize = 13,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool expand;
  final double minHeight;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final BorderSide side;
    final List<BoxShadow> shadow;
    switch (variant) {
      case AppButtonVariant.primary:
        bg = AppColors.primary;
        fg = AppColors.background;
        side = BorderSide.none;
        shadow = AppShadows.primaryButton;
      case AppButtonVariant.outline:
        bg = AppColors.white;
        fg = AppColors.ink;
        side = const BorderSide(color: AppColors.border);
        shadow = const [];
      case AppButtonVariant.whatsapp:
        bg = AppColors.whatsapp;
        fg = AppColors.white;
        side = BorderSide.none;
        shadow = AppShadows.whatsappButton;
    }
    final radius = BorderRadius.circular(12);
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: radius, boxShadow: shadow),
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(borderRadius: radius, side: side),
        child: InkWell(
          onTap: onPressed,
          borderRadius: radius,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16, color: fg),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.inter(
                          size: fontSize,
                          weight: FontWeight.w600,
                          color: fg),
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: 8),
                    Icon(trailingIcon, size: 16, color: fg),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// White rounded square icon button (bell, share, back, heart, filter...).
class SquareIconButton extends StatelessWidget {
  const SquareIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = 44,
    this.background = AppColors.white,
    this.color = AppColors.ink,
    this.bordered = true,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final Color background;
  final Color color;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: bordered
              ? const BorderSide(color: AppColors.border)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: radius,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      ),
    );
  }
}

class WhatsAppIconButton extends StatelessWidget {
  const WhatsAppIconButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);
    return Tooltip(
      message: 'Hubungi via WhatsApp',
      child: Material(
        color: AppColors.whatsapp,
        borderRadius: radius,
        child: InkWell(
          onTap: onPressed,
          borderRadius: radius,
          child: const SizedBox(
            width: 48,
            height: 48,
            child: Icon(Icons.chat_bubble_outline_rounded,
                size: 18, color: AppColors.white),
          ),
        ),
      ),
    );
  }
}

/// Header row used by the secondary screens (title + subtitle + trailing).
class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = false,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final bool showBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: Color(0xB3D7C1A8))),
      ),
      child: Row(
        children: [
          if (showBack) ...[
            SquareIconButton(
              icon: Icons.arrow_back,
              tooltip: 'Kembali',
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppText.inter(size: 18, weight: FontWeight.w700)),
                if (subtitle != null)
                  Text(subtitle!, style: AppText.body12),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({super.key});
  @override
  Widget build(BuildContext context) => SquareIconButton(
        icon: Icons.share_outlined,
        tooltip: 'Bagikan',
        onPressed: () => showToast(context, 'Fitur bagikan belum tersedia.'),
      );
}

/// Dark brown call-to-action card ("Ingin Berkunjung atau Belajar Langsung?").
class WorkshopCta extends StatelessWidget {
  const WorkshopCta({
    super.key,
    this.description =
        'Hubungi pengrajin untuk info kunjungan, workshop, dan pemesanan khusus.',
  });
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ingin Berkunjung atau Belajar Langsung?',
                style: AppText.inter(
                    size: 20,
                    weight: FontWeight.w700,
                    height: 1.22,
                    color: AppColors.background)),
            const SizedBox(height: 10),
            Text(description,
                style: AppText.inter(size: 13, color: AppColors.tan)),
            const SizedBox(height: 14),
            AppButton(
              label: 'Hubungi via WhatsApp',
              icon: Icons.chat_bubble_outline_rounded,
              variant: AppButtonVariant.whatsapp,
              fontSize: 14,
              onPressed: () => openWhatsApp(context),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tinted icon tile + title + description card (USP / Misi cards).
class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color iconBackground;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tan,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: AppColors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.cardTitle),
                const SizedBox(height: 4),
                Text(description, style: AppText.body12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Selectable pill used for category / era filters.
class FilterPill extends StatelessWidget {
  const FilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(999);
    return Material(
      color: selected ? AppColors.primary : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: selected ? BorderSide.none : const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Text(
            label,
            style: AppText.inter(
              size: 13,
              weight: FontWeight.w600,
              color: selected ? AppColors.background : AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}

/// Simple page indicator row "‹ 1 2 3 ›" (visual only).
class Pagination extends StatefulWidget {
  const Pagination({super.key, this.pages = 3});
  final int pages;

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  int _page = 1;

  Widget _cell(String text, {bool active = false, VoidCallback? onTap}) {
    return Material(
      color: active ? AppColors.primary : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: active ? BorderSide.none : const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: Text(
              text,
              style: AppText.inter(
                size: 13,
                weight: FontWeight.w600,
                color: active ? AppColors.background : AppColors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: gapped([
        _cell('‹', onTap: () => setState(() => _page = (_page - 1).clamp(1, widget.pages))),
        for (var i = 1; i <= widget.pages; i++)
          _cell('$i', active: i == _page, onTap: () => setState(() => _page = i)),
        _cell('›', onTap: () => setState(() => _page = (_page + 1).clamp(1, widget.pages))),
      ], 8, horizontal: true),
    );
  }
}
