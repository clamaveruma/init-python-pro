#!/usr/bin/env python3
"""Comprueba enlaces relativos y anclas de docs/*.html."""
import re, sys
from pathlib import Path
from html.parser import HTMLParser

docs = Path(__file__).resolve().parent.parent / "docs"

class P(HTMLParser):
    def __init__(s):
        super().__init__(); s.ids=set(); s.links=[]
    def handle_starttag(s, tag, attrs):
        a=dict(attrs)
        if "id" in a: s.ids.add(a["id"])
        for k in ("href","src"):
            if k in a: s.links.append(a[k])

pages={}
for f in docs.glob("*.html"):
    p=P(); p.feed(f.read_text(encoding="utf-8")); pages[f.name]=p
bad=0
for name,p in pages.items():
    for l in p.links:
        if re.match(r"(https?:|mailto:|data:)",l): continue
        path,_,frag=l.partition("#")
        tgt=path or name
        if tgt.endswith(".html"):
            if tgt not in pages: print(f"{name}: falta {tgt}"); bad+=1; continue
            if frag and frag not in pages[tgt].ids: print(f"{name}: falta ancla {l}"); bad+=1
        elif path and not (docs/path).exists(): print(f"{name}: falta {path}"); bad+=1
print("enlaces OK" if not bad else f"{bad} problemas"); sys.exit(1 if bad else 0)
