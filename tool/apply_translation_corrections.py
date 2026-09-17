"""Apply reviewed website wording after catalog generation."""
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
corrections=json.loads((ROOT/'tool/translation_corrections.json').read_text())
for locale, updates in corrections.items():
    path=ROOT/f'lib/l10n/site_{locale}.arb'
    catalog=json.loads(path.read_text())
    assert updates.keys() <= catalog.keys()
    catalog.update(updates)
    path.write_text(json.dumps(catalog,ensure_ascii=False,indent=2)+'\n')
print(f'Applied {sum(map(len,corrections.values()))} corrections')
