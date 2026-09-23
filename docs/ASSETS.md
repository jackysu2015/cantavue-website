# CantaVue website visual asset provenance

## Current App Store promotional hero

- Date: 2026-09-23
- Runtime assets: `assets/screenshots/{locale}/appstore_01-library.png` through `assets/screenshots/{locale}/appstore_10-templates.png`, where `{locale}` is one of the 34 website locale directories: `ar`, `ca`, `cs`, `da`, `de`, `el`, `en`, `es`, `fi`, `fr`, `he`, `hi`, `hr`, `hu`, `id`, `it`, `ja`, `ko`, `ms`, `nb`, `nl`, `pl`, `pt`, `ro`, `ru`, `sk`, `sv`, `th`, `tr`, `uk`, `vi`, `zh`, `zh_Hans`, `zh_Hant`.
- Source: iPad 13-inch App Store promotional PNGs from `design/marketing/app-store-features-multilingual-2026-09-18/png/ipad_13/`. Locale mappings use the App Store directories `ar-SA`, `de-DE`, `en-US`, `es-ES`, `fr-FR`, `nl-NL`, `no`, `pt-BR`, `zh-Hans` and `zh-Hant` where Apple codes differ from website route codes. Those finished images were rendered from actual CantaVue Flutter screenshots with CSS crop and framing, then saved to App Store Connect 1.0 draft as part of the verified ten-theme pack.
- Runtime processing: final App Store promotional PNGs resized to 675 × 900 PNG files for stable website delivery. No private user scores, recordings, accounts, credentials, or diagnostics are included.
- Purpose: first-viewport product marketing carousel that matches the App Store download story and shows the ten official themes: library, scan/import, annotation, symbols/shapes, page organization, setlists, metronome, practice, teaching and templates/backup.
- Runtime selection: the Flutter carousel reads the current page locale and loads the matching directory, falling back to English only if an unsupported locale is introduced later.

## Archived concept hero

- Final asset: `hero-source.png`
- Date: 2026-09-06
- Dimensions: 1536 × 1024 pixels, PNG, 3:2.
- Origin: original AI-generated concept photography using the native built-in OpenAI image generation tool, with one targeted correction to remove an extra annotation. No external reference images or user score assets were used.
- Former purpose: atmospheric website marketing hero. This is a concept image, not an actual app screenshot or proof of implemented features. The generated score is illustrative generic notation and has not been validated as playable music. It is retained as history and is no longer the first-viewport hero visual.
- Visual QA: black unbranded tablet on piano stand, right-center composition, dark ink scene, lavender rim light, warm side light, ivory score, two purple circle annotations, no people or logos or app controls. One final deliverable, no alternatives.

## Generation prompt

```text
Use case: photorealistic-natural
Asset type: original premium editorial hero photograph concept for the CantaVue / 谱翎 sheet-music app marketing website.
Primary request: one polished, believable close-up lifestyle image of an unbranded black tablet resting securely on a dark piano music stand in an elegant quiet studio at dusk.
Subject: tablet in portrait orientation at a slight diagonal; its screen shows crisp generic classical piano music notation on an ivory sheet, with exactly two tasteful iris-purple handwritten annotation marks. Use generic invented music notation, no composition title, no composer or other words. Physically plausible tablet, screen, stand and piano.
Composition/framing: wide 3:2 photograph. Tablet occupies right-center of frame, clear complete edges. Left side is calm deep atmospheric negative space. Black and white piano keys are softly blurred across the lower foreground. Close-up view, restrained shallow depth of field.
Lighting/mood: soft lavender rim lighting and warm natural side light; intimate, quiet, precise, high-end editorial photography.
Color palette: deep ink/navy scene around #111127 with soft iris-purple accent around #5552DB; ivory score.
Materials/textures: subtle reflections on black tablet glass and lacquered dark piano; photographic natural detail.
Constraints: image only, no people, no brands, no UI chrome, no headlines, no text, no logos, no watermark, no decorative floating graphics. Read as atmospheric concept photography, not an actual app screenshot. Produce exactly one image.
```

## Targeted correction prompt

```text
Use case: precise-object-edit. Edit the provided hero photograph by removing only the small pale-purple arch annotation between the first pair of music staves near the upper third of the tablet screen. Preserve the two purple circle annotations near the lowest pair of staves, so exactly two purple handwritten annotations remain on the entire score. Preserve every other element, all music notation, tablet, stand, keys, lighting, framing, colors and 3:2 dimensions. No new marks, text, logos, UI or objects. This is one correction to the same final hero asset, not a new variant.
```


Brand: existing selected CantaVue A1 image, copied without creative edits from the parent project assets/images/cantavue/3.0x/brand_a1.png.
