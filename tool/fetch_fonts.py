"""Refresh local Noto subsets after copy changes; uses only Python stdlib."""
import json, re, urllib.parse, urllib.request
from pathlib import Path

characters = set(chr(i) for i in range(32, 127))
characters.update('简体中文繁體中文English取消關閉关闭返回展开展開收起更多選擇选择確定确定語言语言')
for path in Path('lib/l10n').glob('*.arb'):
    for key, value in json.loads(path.read_text()).items():
        if not key.startswith('@'):
            characters.update(value)
text = ''.join(sorted(characters - {'\n', '\r'}))
Path('assets/fonts').mkdir(parents=True, exist_ok=True)
manifest = []
for region in ['SC', 'TC']:
    family = f'Noto Sans {region}'
    css_url = 'https://fonts.googleapis.com/css2?' + urllib.parse.urlencode({'family': family + ':wght@400;600;700', 'text': text})
    css = urllib.request.urlopen(css_url).read().decode()
    matches = re.findall(r'font-weight: (\d+);\s*src: url\(([^)]+)\)', css)
    if len(matches) != 3: raise RuntimeError('Unexpected Google Fonts response')
    for weight, url in matches:
        path = Path(f'assets/fonts/NotoSans{region}-{weight}.ttf')
        path.write_bytes(urllib.request.urlopen(url).read())
        manifest.append({'file':str(path),'weight':weight,'family':family,'source':url,'bytes':path.stat().st_size})
        print(path, path.stat().st_size)
    license_url = f'https://raw.githubusercontent.com/google/fonts/main/ofl/notosans{region.lower()}/OFL.txt'
    Path(f'assets/fonts/OFL-NotoSans{region}.txt').write_bytes(urllib.request.urlopen(license_url).read())
Path('docs/FONTS.json').write_text(json.dumps({'characters':text,'fonts':manifest},ensure_ascii=False,indent=2)+'\n')
