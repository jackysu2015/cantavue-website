"""Verify all language catalogs and generated HTML links without a browser."""
import json
import subprocess
import sys
from pathlib import Path
from html.parser import HTMLParser
from urllib.parse import urlsplit

ROOT = Path(__file__).resolve().parents[1]
LOCALES = ['zh-Hans', 'zh-Hant', 'en', *json.loads((ROOT/'tool/locales.json').read_text())]
PUBLIC=ROOT/('dist' if '--dist' in sys.argv else 'web')
SOURCE = json.loads((ROOT/'lib/l10n/site_en.arb').read_text())

class Document(HTMLParser):
    def __init__(self, text):
        super().__init__(); self.links=[]; self.assets=[]; self.html={}; self.canonical=None; self.alternates=[]; self.feed(text)
    def handle_starttag(self, tag, attrs):
        a=dict(attrs)
        if tag=='html': self.html=a
        if tag in ['img','script'] and a.get('src'): self.assets.append(a['src'])
        if tag=='link' and a.get('rel') in ['stylesheet','icon','manifest']: self.assets.append(a['href'])
        if tag=='a': self.links.append(a.get('href',''))
        if tag=='link' and a.get('rel')=='canonical': self.canonical=a['href']
        if tag=='link' and a.get('rel')=='alternate': self.alternates.append(a['hreflang'])

def main():
    count=0
    for locale in LOCALES:
        catalog=json.loads((ROOT/f'lib/l10n/site_{locale.replace("-","_")}.arb').read_text())
        assert catalog.keys()==SOURCE.keys(), locale
        assert catalog['@@locale']==locale.replace('-','_'),locale
        assert all(isinstance(v,str) and v for v in catalog.values()),locale
        for page in ['home','privacy','terms','support']:
            name=('index' if locale=='zh-Hans' else locale) if page=='home' else page+('' if locale=='zh-Hans' else '-'+locale)
            text=(PUBLIC/f'{name}.html').read_text(); doc=Document(text)
            assert doc.html=={'lang':locale,'dir':'rtl' if locale in ['ar','he'] else 'ltr'},name
            assert len(doc.alternates)==len(LOCALES) and set(doc.alternates)==set(LOCALES), name
            expected='https://www.cantavue.com/'+('' if name=='index' else name)
            assert doc.canonical==expected,(name,doc.canonical)
            for link in doc.links:
                url=urlsplit(link)
                if url.scheme or url.netloc or not url.path: continue
                path=url.path.lstrip('/') or 'index.html'
                assert (PUBLIC/path).exists(), (name,link)
            for key in (['heroTitle','heroBody','faq4a'] if page=='home' else [page+'Intro',page+'1Body']):
                import html
                assert html.escape(catalog[key],quote=True).replace('&#x27;', '&#39;').replace('\n','<br>') in text or html.escape(catalog[key].split('\n\n')[0],quote=True).replace('&#x27;', '&#39;') in text,(name,key)
            if '--dist' in sys.argv:
                for asset in doc.assets:
                    path=urlsplit(asset).path.lstrip('/')
                    assert (PUBLIC/path).is_file(), (name,asset)
            import re
            for script in re.findall(r'<script>(.*?)</script>',text,re.S):
                subprocess.run(['node','--check'],input=script,text=True,check=True,capture_output=True)
            count+=1
    import xml.etree.ElementTree as ET
    tree=ET.parse(PUBLIC/'sitemap.xml'); assert len(tree.getroot())==132
    print(f'{len(LOCALES)} languages, {count} documents: catalogs, direction, links, canonical, hreflang and sitemap verified')

if __name__=='__main__': main()
