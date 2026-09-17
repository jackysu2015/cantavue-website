"""Subset existing licensed app fonts for website text; requires fonttools."""
import hashlib
import json
import shutil
from pathlib import Path
from fontTools import subset
from fontTools.ttLib import TTFont

WEBSITE = Path(__file__).resolve().parents[1]
ROOT = WEBSITE.parent
FONTS = {
    'CantaMultilingual': 'NotoSans-Regular.ttf',
    'CantaArabic': 'NotoSansArabic-Variable.ttf',
    'CantaHebrew': 'NotoSansHebrew-Variable.ttf',
    'CantaDevanagari': 'NotoSansDevanagari-Variable.ttf',
    'CantaThai': 'NotoSansThai-Variable.ttf',
    'CantaCJK': 'NotoSansCJKsc-Regular.otf',
}

def main():
    resources = list((WEBSITE / 'lib/l10n').glob('site_*.arb'))
    text = ''.join(v for path in resources for k, v in json.loads(path.read_text()).items() if not k.startswith('@'))
    text += ''.join(v[1] for v in json.loads((WEBSITE / 'tool/locales.json').read_text()).values())
    text += '简体中文繁體中文English←↗·'
    coverage = set()
    records = []
    css = []
    for family, name in FONTS.items():
        source = ROOT / 'assets/fonts' / name
        font = TTFont(source)
        options = subset.Options()
        options.layout_features = ['*']
        subsetter = subset.Subsetter(options=options)
        subsetter.populate(text=text)
        subsetter.subset(font)
        coverage.update(font.getBestCmap())
        target = WEBSITE / 'assets/fonts' / name
        font.save(target)
        records.append({'family': family, 'file': str(target.relative_to(WEBSITE)), 'bytes': target.stat().st_size, 'sha256': hashlib.sha256(target.read_bytes()).hexdigest(), 'sourceSha256': hashlib.sha256(source.read_bytes()).hexdigest()})
        css.append(f"@font-face{{font-family:{family};src:url('/assets/assets/fonts/{name}');font-display:swap}}")
    for path in (WEBSITE / 'assets/fonts').glob('NotoSans[ST]C-*.ttf'):
        coverage.update(TTFont(path).getBestCmap())
    missing = set(map(ord, text)) - coverage - {10, 13, 0x200e, 0x200f, 0x200b, 0x200c, 0x200d, 0x202a, 0x202b, 0x202c, 0x2066, 0x2067, 0x2069}
    if missing:
        raise RuntimeError(f'Missing glyphs: {sorted(missing)}')
    shutil.copyfile(ROOT / 'assets/fonts/LICENSE.txt', WEBSITE / 'assets/fonts/OFL-Multilingual.txt')
    css.append(':root{font-family:CantaSansSC,' + ','.join(FONTS) + ',system-ui,sans-serif}')
    css.append('nav a[lang]{font-family:CantaSansSC,' + ','.join(FONTS) + ',system-ui,sans-serif}')
    for locale, family in [('ar','CantaArabic'),('he','CantaHebrew'),('hi','CantaDevanagari'),('th','CantaThai'),('ja','CantaCJK'),('ko','CantaCJK')]:
        css.append(f':lang({locale}){{font-family:{family},CantaMultilingual,system-ui,sans-serif}}')
    (WEBSITE / 'web/multilingual-fonts.css').write_text('\n'.join(css)+'\n')
    (WEBSITE / 'docs/MULTILINGUAL_FONTS.json').write_text(json.dumps({'license':'SIL OFL 1.1', 'tool':'fonttools, development only', 'fonts':records, 'missingGlyphs':[]},indent=2)+'\n')
    print(f'{len(resources)} catalogs, no missing glyphs; {sum(r["bytes"] for r in records):,} bytes')

if __name__ == '__main__':
    main()
