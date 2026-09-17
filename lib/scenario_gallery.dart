import 'site_typography.dart';
import 'package:flutter/material.dart';

import 'l10n/generated/site_localizations.dart';

/// Three concrete music settings, without implying classroom or sync services.
class ScenarioGallery extends StatelessWidget {
  const ScenarioGallery({required this.wide, super.key});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final s = SiteLocalizations.of(context);
    final lesson = _Story(
      asset: 'assets/scenes/violin_lesson.webp',
      alt: s.sceneLessonAlt,
      tag: s.sceneLessonTag,
      title: s.sceneLessonTitle,
      body: s.sceneLessonBody,
    );
    final ensemble = _Story(
      asset: 'assets/scenes/ensemble_stage.webp',
      alt: s.sceneEnsembleAlt,
      tag: s.sceneEnsembleTag,
      title: s.sceneEnsembleTitle,
      body: s.sceneEnsembleBody,
    );
    final pedalText = Padding(
      padding: EdgeInsets.all(wide ? 36 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Label(s.scenePedalTag, dark: true),
          const SizedBox(height: 20),
          Semantics(
            header: true,
            child: Text(
              s.scenePedalTitle,
              style: TextStyle(
                fontSize: wide ? 32 : 28,
                height: 1.35,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            s.scenePedalBody,
            style: const TextStyle(
              fontSize: 16,
              height: 1.85,
              color: Color(0xFFD6D1EA),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            s.scenePedalNote,
            style: const TextStyle(
              fontSize: 14,
              height: 1.7,
              color: Color(0xFFB8B3D0),
            ),
          ),
        ],
      ),
    );
    final pedalImage = _SceneImage(
      asset: 'assets/scenes/pedal_page_turn.webp',
      alt: s.scenePedalAlt,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (wide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: lesson),
              const SizedBox(width: 28),
              Expanded(child: ensemble),
            ],
          )
        else ...[
          lesson,
          const SizedBox(height: 36),
          ensemble,
        ],
        const SizedBox(height: 40),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: ColoredBox(
            color: const Color(0xFF211B40),
            child: wide
                ? Row(
                    children: [
                      Expanded(flex: 6, child: pedalImage),
                      Expanded(flex: 5, child: pedalText),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [pedalImage, pedalText],
                  ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          s.sceneImageNote,
          style: const TextStyle(
            fontSize: 13,
            height: 1.7,
            color: Color(0xFF667084),
          ),
        ),
      ],
    );
  }
}

class _Story extends StatelessWidget {
  const _Story({
    required this.asset,
    required this.alt,
    required this.tag,
    required this.title,
    required this.body,
  });
  final String asset, alt, tag, title, body;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _SceneImage(asset: asset, alt: alt),
      ),
      const SizedBox(height: 24),
      _Label(tag),
      const SizedBox(height: 10),
      Semantics(
        header: true,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 25,
            height: 1.45,
            fontWeight: FontWeight.w600,
            color: Color(0xFF10203A),
          ),
        ),
      ),
      const SizedBox(height: 12),
      Text(
        body,
        style: const TextStyle(
          fontSize: 16,
          height: 1.85,
          color: Color(0xFF556075),
        ),
      ),
    ],
  );
}

class _SceneImage extends StatelessWidget {
  const _SceneImage({required this.asset, required this.alt});
  final String asset, alt;
  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 3 / 2,
    child: Image.asset(
      asset,
      fit: BoxFit.contain,
      semanticLabel: alt,
      width: double.infinity,
    ),
  );
}

class _Label extends StatelessWidget {
  const _Label(this.text, {this.dark = false});
  final String text;
  final bool dark;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      color: dark
          ? const Color(0xFFB9AFFF)
          : Theme.of(context).colorScheme.primary,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.6,
      letterSpacing: siteTracking(context, .8),
    ),
  );
}
