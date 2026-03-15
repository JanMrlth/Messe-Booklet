#!/usr/bin/env python3
"""
Scrape Mariawald Messbuch Easter Vigil pages using LT/DT div classes
to extract paired Latin/German text blocks into structured JSON.
"""

import html as html_module
import urllib.request
import re
import json
import time
import sys

BASE = "https://www.mariawalder-messbuch.de/as62/fastenzeit/karsa/"

PAGES = [
    ("node3",  "Feuerweihe"),
    ("node4",  "Weihe der Osterkerze"),
    ("node5",  "Einzug mit der Osterkerze"),
    ("node6",  "Exsultet"),
    ("node7",  "Prophetie I – Gen 1,1-31; 2,1-2"),
    ("node8",  "Prophetie II – Ex 14,24-31; 15,1"),
    ("node9",  "Prophetie III – Jes 4,2-6"),
    ("node10", "Prophetie IV – Dtn 31,22-30"),
    ("node11", "Allerheiligenlitanei I"),
    ("node12", "Taufwasserweihe"),
    ("node13", "Taufe und Prozession zum Taufbrunnen"),
    ("node14", "Allerheiligenlitanei II und Taufversprechen"),
    ("node15", "Hochamt – Kyrie und Gloria"),
    ("node16", "Oratio – Collecta"),
    ("node17", "Epistel – Kol 3,1-4"),
    ("node18", "Alleluia – Ps 117"),
    ("node19", "Evangelium – Mt 28,1-7"),
    ("node20", "Secreta"),
    ("node21", "Praefatio Paschalis"),
    ("node22", "Communicantes"),
    ("node23", "Hanc igitur"),
    ("node24", "Communio – Ps 117"),
    ("node25", "Laudes"),
    ("node26", "Postcommunio"),
]


def strip_html(html_fragment):
    """Remove HTML tags, decode entities, and normalize whitespace."""
    text = re.sub(r'<br\s*/?>', '\n', html_fragment)
    text = re.sub(r'<[^>]+>', '', text)
    text = text.replace('\xa0', ' ')
    text = html_module.unescape(text)
    lines = []
    for line in text.split('\n'):
        line = ' '.join(line.split())
        if line:
            lines.append(line)
    return '\n'.join(lines)


def extract_rubrics(html, lt_dt_blocks):
    """Extract rubric text (outside LT/DT divs) from the main content area."""
    # Get content area (after navigation, before footer)
    content = html
    # Remove header/footer
    for marker in ['Abtei Mariawald', 'zum Anfang der Seite']:
        idx = content.find(marker)
        if idx > 0:
            content = content[:idx]
    # Remove LT/DT blocks to find rubric text
    for block in lt_dt_blocks:
        content = content.replace(block, '')
    # Find remaining text in <p>, <font>, <i> tags that contain rubrics
    rubric_texts = []
    # Simple approach: find italic red text (rubrics are typically in red italic)
    rubrics = re.findall(r'<font[^>]*color[^>]*#ac0000[^>]*>(.*?)</font>', content, re.DOTALL)
    for r in rubrics:
        clean = strip_html(r).strip()
        if clean and len(clean) > 5:
            rubric_texts.append(clean)
    return rubric_texts


def fetch_and_parse(node_id):
    """Fetch a page and extract paired LT/DT blocks."""
    url = BASE + node_id + ".html"
    req = urllib.request.Request(url, headers={'User-Agent': 'MarlothAutomation/1.0 (liturgical-booklet)'})
    with urllib.request.urlopen(req) as resp:
        html = resp.read().decode('utf-8', errors='replace')

    # Extract paired LT/DT blocks in order
    lt_blocks = re.findall(r'<div class="LT">(.*?)</div>', html, re.DOTALL)
    dt_blocks = re.findall(r'<div class="DT">(.*?)</div>', html, re.DOTALL)

    pairs = []
    for i in range(max(len(lt_blocks), len(dt_blocks))):
        lat = strip_html(lt_blocks[i]) if i < len(lt_blocks) else ""
        deu = strip_html(dt_blocks[i]) if i < len(dt_blocks) else ""
        pairs.append({"latin": lat, "german": deu})

    # Also extract rubric text that appears between LT/DT blocks
    # Find text between </div> and next <div class="LT"|"DT">
    rubrics = []
    # Extract text from non-LT/DT sections of content
    content_start = html.find('<table bgcolor')
    content_end = html.find('Abtei Mariawald')
    if content_start > 0 and content_end > 0:
        content = html[content_start:content_end]
        # Find rubric paragraphs (italic text, red text, plain descriptions)
        rubric_matches = re.findall(
            r'<p[^>]*>\s*<font[^>]*>\s*<i>(.*?)</i>\s*</font>\s*</p>',
            content, re.DOTALL
        )
        for rm in rubric_matches:
            clean = strip_html(rm).strip()
            if clean and len(clean) > 10:
                rubrics.append(clean)

    return pairs, rubrics


def main():
    result = {}
    for node_id, title in PAGES:
        print(f"Fetching {node_id}: {title}...", file=sys.stderr)
        pairs, rubrics = fetch_and_parse(node_id)
        section = {
            "title": title,
            "pairs": []
        }
        for i, p in enumerate(pairs):
            entry = {"latin": p["latin"], "german": p["german"]}
            section["pairs"].append(entry)
        if rubrics:
            section["rubrics"] = rubrics
        result[node_id] = section
        time.sleep(0.3)

    outpath = "data/mariawald_karsamstag.json"
    with open(outpath, 'w', encoding='utf-8') as f:
        json.dump(result, f, ensure_ascii=False, indent=2)
    print(f"\nSaved to {outpath}", file=sys.stderr)


if __name__ == "__main__":
    main()
