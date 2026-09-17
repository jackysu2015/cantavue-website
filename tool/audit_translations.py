"""Audit source reuse and catalog integrity; run from the application checkout."""
import hashlib
import json
import re
import unicodedata
from pathlib import Path

SITE=Path(__file__).resolve().parents[1]
APP=SITE.parent
source=json.loads((SITE/'lib/l10n/site_en.arb').read_text())
app_source=json.loads((APP/'lib/l10n/app_en.arb').read_text())
inverse={v:k for k,v in app_source.items() if isinstance(v,str) and not k.startswith('@')}
records=[]
issues=[]
for locale in json.loads((SITE/'tool/locales.json').read_text()):
    path=SITE/f'lib/l10n/site_{locale}.arb'
    catalog=json.loads(path.read_text())
    assert set(catalog)==set(source),locale
    app=json.loads((APP/f'lib/l10n/app_{locale}.arb').read_text())
    reuse={k:inverse[v] for k,v in source.items() if not k.startswith('@') and v in inverse}
    for key, app_key in reuse.items():
        assert catalog[key]==app[app_key],(locale,key,'reuse changed')
    def links(text):
        return {v.rstrip('.,;:') for v in re.findall(r'https?://[^\s]+|[A-Za-z0-9][A-Za-z0-9.+_-]*@[A-Za-z0-9.-]+',text)}
    for key,text in catalog.items():
        if key.startswith('@'):continue
        assert isinstance(text,str) and text.strip(),(locale,key)
        assert links(source[key])==links(text),(locale,key,'link changed')
        if locale not in ['uk','ru'] and any('CYRILLIC' in unicodedata.name(ch,'') for ch in text): issues.append([locale,key,'Unexpected Cyrillic'])
        if locale not in ['ja','ko'] and any('CJK UNIFIED' in unicodedata.name(ch,'') for ch in text): issues.append([locale,key,'Unexpected Han'])
    records.append({'locale':locale,'messages':len(catalog)-1,'reusedAppKeys':reuse,'sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
report={'sourceSha256':hashlib.sha256((SITE/'lib/l10n/site_en.arb').read_bytes()).hexdigest(),'reuse':'Exact English source match only; website copy reviewed separately','independentNativeSpeakerReview':False,'catalogs':records,'scriptWarnings':issues}
(SITE/'docs/TRANSLATION_SOURCES.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
print(json.dumps({'catalogs':len(records),'scriptWarnings':issues},ensure_ascii=False,indent=2))
