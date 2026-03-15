#!/usr/bin/env python3
"""
Scrape the Mariawalder Messbuch Easter Vigil pages and extract
bilingual (Latin/German) liturgical texts into structured YAML.

Source: https://www.mariawalder-messbuch.de/as62/fastenzeit/karsa/
Pages: node3.html through node26.html
"""

import urllib.request
import html
import re
import json
import sys
import time
from html.parser import HTMLParser


BASE = "https://www.mariawalder-messbuch.de/as62/fastenzeit/karsa/"

# Map node numbers to section names
PAGES = {
    "node3":  "Feuerweihe",
    "node4":  "Weihe der Osterkerze",
    "node5":  "Einzug mit der Osterkerze",
    "node6":  "Exsultet - Oesterlicher Preisgesang",
    "node7":  "Prophetie I - Gen 1,1-31; 2,1-2",
    "node8":  "Prophetie II - Ex 14,24-31; 15,1",
    "node9":  "Prophetie III - Jes 4,2-6",
    "node10": "Prophetie IV - Dtn 31,22-30",
    "node11": "Allerheiligenlitanei I",
    "node12": "Taufwasserweihe",
    "node13": "Taufe und Prozession zum Taufbrunnen",
    "node14": "Allerheiligenlitanei II und Taufversprechen",
    "node15": "Hochamt der Osternacht - Kyrie Gloria",
    "node16": "Oratio - Collecta",
    "node17": "Epistel - Kol 3,1-4",
    "node18": "Alleluia - Ps 117",
    "node19": "Evangelium - Mt 28,1-7",
    "node20": "Secreta",
    "node21": "Praefatio Paschalis",
    "node22": "Communicantes",
    "node23": "Hanc igitur",
    "node24": "Communio - Ps 117",
    "node25": "Laudes",
    "node26": "Postcommunio",
}


class TextExtractor(HTMLParser):
    """Extract visible text from HTML, preserving structure."""
    
    def __init__(self):
        super().__init__()
        self.result = []
        self.skip = False
        self.skip_tags = {'script', 'style', 'head'}
        self.tag_stack = []
        
    def handle_starttag(self, tag, attrs):
        self.tag_stack.append(tag)
        if tag in self.skip_tags:
            self.skip = True
        if tag == 'br':
            self.result.append('\n')
        if tag == 'p':
            self.result.append('\n\n')
        if tag in ('tr',):
            self.result.append('\n')
        if tag == 'td':
            attrs_dict = dict(attrs)
            # Add column separator
            self.result.append('\t')
            
    def handle_endtag(self, tag):
        if self.tag_stack and self.tag_stack[-1] == tag:
            self.tag_stack.pop()
        if tag in self.skip_tags:
            self.skip = False
        if tag in ('h1', 'h2', 'h3', 'h4', 'h5', 'h6'):
            self.result.append('\n')
        if tag == 'div':
            self.result.append('\n')
            
    def handle_data(self, data):
        if not self.skip:
            self.result.append(data)
            
    def handle_entityref(self, name):
        if not self.skip:
            c = html.unescape(f'&{name};')
            self.result.append(c)
            
    def handle_charref(self, name):
        if not self.skip:
            c = html.unescape(f'&#{name};')
            self.result.append(c)
            
    def get_text(self):
        return ''.join(self.result)


def fetch_page(url):
    """Fetch a page and return decoded HTML."""
    req = urllib.request.Request(url, headers={
        'User-Agent': 'Mozilla/5.0 (Messe-Booklet-Project/1.0; educational/liturgical)'
    })
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = resp.read()
        # Try different encodings
        for enc in ['utf-8', 'iso-8859-1', 'windows-1252', 'latin-1']:
            try:
                return data.decode(enc)
                break
            except UnicodeDecodeError:
                continue
        return data.decode('utf-8', errors='replace')


def extract_text(html_content):
    """Extract visible text from HTML."""
    parser = TextExtractor()
    parser.feed(html_content)
    return parser.get_text()


def extract_bilingual_blocks(text):
    """
    Try to identify Latin and German text blocks.
    The Mariawald Messbuch uses tables with Latin on left, German on right.
    """
    lines = text.split('\n')
    blocks = []
    current_block = {"latin": [], "german": [], "rubric": []}
    
    for line in lines:
        stripped = line.strip()
        if not stripped:
            continue
            
        # Check if line has tab separator (from table columns)
        if '\t' in line:
            parts = line.split('\t')
            # Filter out empty parts
            parts = [p.strip() for p in parts if p.strip()]
            if len(parts) >= 2:
                current_block["latin"].append(parts[0])
                current_block["german"].append(parts[1])
            elif len(parts) == 1:
                current_block["rubric"].append(parts[0])
        else:
            current_block["rubric"].append(stripped)
    
    return current_block


def clean_text(text):
    """Clean up extracted text."""
    # Normalize whitespace
    text = re.sub(r'[ \t]+', ' ', text)
    # Remove excessive newlines
    text = re.sub(r'\n{3,}', '\n\n', text)
    # Strip navigation junk
    for junk in ['Nächste Seite:', 'Zurück:', 'Abtei Mariawald', 'zum Anfang der Seite',
                 'Introibo Ad Altare Dei', 'Messbuch1', 'Messbuch2', 'Abteikirche',
                 'next', 'previous']:
        text = text.replace(junk, '')
    return text.strip()


def main():
    all_sections = {}
    
    for node, title in PAGES.items():
        url = f"{BASE}{node}.html"
        print(f"Fetching {node}: {title}...", file=sys.stderr)
        
        try:
            html_content = fetch_page(url)
            text = extract_text(html_content)
            text = clean_text(text)
            
            all_sections[node] = {
                "title": title,
                "url": url,
                "raw_text": text,
            }
            
            # Be polite - small delay between requests
            time.sleep(0.5)
            
        except Exception as e:
            print(f"  ERROR: {e}", file=sys.stderr)
            all_sections[node] = {
                "title": title,
                "url": url,
                "error": str(e),
            }
    
    # Output as JSON
    print(json.dumps(all_sections, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
