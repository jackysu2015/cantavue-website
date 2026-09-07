"""Bound downloaded fonts to published ARB characters (fonttools 4.60.1, MIT)."""
import json
from pathlib import Path
from fontTools import subset
from fontTools.ttLib import TTFont

manifest_path = Path('docs/FONTS.json')
manifest = json.loads(manifest_path.read_text())
for entry in manifest['fonts']:
    path = Path(entry['file'])
    font = TTFont(path)
    options = subset.Options()
    options.layout_features = ['*']
    subsetter = subset.Subsetter(options=options)
    subsetter.populate(text=manifest['characters'])
    subsetter.subset(font)
    locale = 'zh_Hant' if 'TC' in path.name else 'zh_Hans'
    localized = json.loads(Path(f'lib/l10n/site_{locale}.arb').read_text())
    required = ''.join(value for key, value in localized.items() if not key.startswith('@'))
    missing = set(map(ord, required)) - set(font.getBestCmap()) - {10, 13}
    if missing:
        raise RuntimeError(f'{path}: missing glyphs {sorted(missing)}')
    font.save(path)
    entry['bytes'] = path.stat().st_size
    print(path, entry['bytes'])
manifest['subset_tool'] = 'fonttools 4.60.1 (MIT), development only'
manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2)+'\n')
