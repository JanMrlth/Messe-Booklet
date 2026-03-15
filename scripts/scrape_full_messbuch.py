#!/usr/bin/env python3
"""
Comprehensive scraper for the entire Mariawalder Messbuch (Schott 1962).
Extracts all bilingual Latin/German text pairs from LT/DT CSS class divs.

Structure:
  - Phase 1: Discover all mass index URLs from category pages
  - Phase 2: For each mass index, discover child node URLs
  - Phase 3: For each node, extract LT/DT text pairs
  - Output: Single JSON file with all structured data

Usage:
  python3 scrape_full_messbuch.py              # Full scrape
  python3 scrape_full_messbuch.py --resume     # Resume from last checkpoint
  python3 scrape_full_messbuch.py --index-only # Only discover URLs, don't scrape content
"""

import urllib.request
import re
import json
import time
import sys
import os
import html as html_module
from pathlib import Path

BASE = "https://www.mariawalder-messbuch.de/as62/"
DATA_DIR = Path("data")
CHECKPOINT_FILE = DATA_DIR / "messbuch_checkpoint.json"
OUTPUT_FILE = DATA_DIR / "messbuch_full.json"
INDEX_FILE = DATA_DIR / "messbuch_index.json"

DELAY = 0.3  # seconds between requests
USER_AGENT = "MarlothAutomation/1.0 (liturgical-booklet-scraper)"


def fetch(url, retries=2):
    """Fetch a URL with retries."""
    for attempt in range(retries + 1):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
            with urllib.request.urlopen(req, timeout=30) as resp:
                return resp.read().decode("utf-8", errors="replace")
        except Exception as e:
            if attempt < retries:
                time.sleep(1)
            else:
                print(f"  FAILED: {url} -> {e}", file=sys.stderr)
                return None
    return None


def strip_html(fragment):
    """Remove HTML tags, decode entities, normalize whitespace."""
    text = re.sub(r"<br\s*/?>", "\n", fragment)
    text = re.sub(r"<[^>]+>", "", text)
    # Decode HTML entities
    text = html_module.unescape(text)
    text = text.replace("\xa0", " ")
    # Normalize whitespace per line
    lines = []
    for line in text.split("\n"):
        line = " ".join(line.split())
        if line:
            lines.append(line)
    return "\n".join(lines)


# ── Phase 1: Discover all mass index URLs ──


def discover_tempore_masses():
    """Parse proptempore.html for all mass index URLs."""
    print("Discovering Proprium de Tempore...", file=sys.stderr)
    html = fetch(BASE + "proptempore.html")
    if not html:
        return []
    links = re.findall(r'href="([^"]*index\.html)"', html)
    # Also extract the display text for each link
    entries = []
    for match in re.finditer(
        r'href="([^"]*index\.html)"[^>]*>(.*?)</a>', html, re.DOTALL
    ):
        href, text = match.groups()
        title = strip_html(text).strip()
        if href.startswith("http"):
            continue
        full_url = BASE + href
        entries.append(
            {"url": full_url, "path": href, "title": title, "category": "tempore"}
        )
    # Deduplicate by URL
    seen = set()
    unique = []
    for e in entries:
        if e["url"] not in seen:
            seen.add(e["url"])
            unique.append(e)
    print(f"  Found {len(unique)} masses", file=sys.stderr)
    return unique


def discover_sanctis_masses():
    """Parse propsct*.html month pages for all saints' mass URLs."""
    print("Discovering Proprium de Sanctis...", file=sys.stderr)
    html = fetch(BASE + "propsct.html")
    if not html:
        return []
    month_pages = sorted(set(re.findall(r'href="(propsct\w+\.html)"', html)))
    entries = []
    for mp in month_pages:
        time.sleep(DELAY)
        month_html = fetch(BASE + mp)
        if not month_html:
            continue
        month_name = mp.replace("propsct", "").replace(".html", "")
        for match in re.finditer(
            r'href="([^"]*index\.html)"[^>]*>(.*?)</a>', month_html, re.DOTALL
        ):
            href, text = match.groups()
            title = strip_html(text).strip()
            if href.startswith("http"):
                continue
            # Resolve relative path
            full_url = BASE + href
            entries.append(
                {
                    "url": full_url,
                    "path": href,
                    "title": title,
                    "category": "sanctis",
                    "month": month_name,
                }
            )
    seen = set()
    unique = []
    for e in entries:
        if e["url"] not in seen:
            seen.add(e["url"])
            unique.append(e)
    print(f"  Found {len(unique)} saints' masses", file=sys.stderr)
    return unique


def discover_commune_masses():
    """Parse commune pages for mass URLs."""
    print("Discovering Commune...", file=sys.stderr)
    entries = []
    for page, cat in [
        ("commonbmv.html", "commune_bmv"),
        ("communesct.html", "commune_sanctorum"),
    ]:
        html = fetch(BASE + page)
        if not html:
            continue
        for match in re.finditer(
            r'href="([^"]*index\.html)"[^>]*>(.*?)</a>', html, re.DOTALL
        ):
            href, text = match.groups()
            title = strip_html(text).strip()
            if href.startswith("http"):
                continue
            full_url = BASE + href
            entries.append(
                {"url": full_url, "path": href, "title": title, "category": cat}
            )
        time.sleep(DELAY)
    seen = set()
    unique = []
    for e in entries:
        if e["url"] not in seen:
            seen.add(e["url"])
            unique.append(e)
    print(f"  Found {len(unique)} commune masses", file=sys.stderr)
    return unique


def discover_special_pages():
    """Get special pages: Ordo Missae, Asperges, etc."""
    print("Discovering special pages...", file=sys.stderr)
    entries = []
    special = [
        ("ordo/ordo.html", "Ordo Missae", "ordo"),
        ("asperges/asperges.html", "Asperges", "asperges"),
        ("danksagung/danksagung.html", "Danksagung", "danksagung"),
    ]
    for path, title, cat in special:
        full_url = BASE + path
        entries.append(
            {
                "url": full_url,
                "path": path,
                "title": title,
                "category": cat,
                "is_single_page": True,
            }
        )
    print(f"  Found {len(entries)} special pages", file=sys.stderr)
    return entries


# ── Phase 2: Discover child nodes for each mass ──


def discover_child_nodes(mass_url):
    """Fetch a mass index page and find all child node URLs."""
    html = fetch(mass_url)
    if not html:
        return [], None
    # Extract mass title from <TITLE> or <H1>
    title_match = re.search(r"<TITLE>(.*?)</TITLE>", html, re.DOTALL)
    mass_title = strip_html(title_match.group(1)).strip() if title_match else ""
    # Find child node links
    nodes = []
    # Look for Unterabschnitte section
    for match in re.finditer(
        r'HREF="(node\d+\.html)"[^>]*>(.*?)</[Aa]>', html, re.DOTALL
    ):
        href, text = match.groups()
        node_title = strip_html(text).strip()
        # Build full URL
        base_url = mass_url.rsplit("/", 1)[0] + "/"
        node_url = base_url + href
        nodes.append({"url": node_url, "file": href, "title": node_title})
    # Deduplicate (some nodes are linked multiple times)
    seen = set()
    unique = []
    for n in nodes:
        if n["url"] not in seen:
            seen.add(n["url"])
            unique.append(n)
    return unique, mass_title


# ── Phase 3: Extract LT/DT content from a node page ──


def extract_lt_dt(node_url):
    """Fetch a node page and extract paired LT/DT text blocks."""
    html = fetch(node_url)
    if not html:
        return None
    lt_blocks = re.findall(r'<div class="LT">(.*?)</div>', html, re.DOTALL)
    dt_blocks = re.findall(r'<div class="DT">(.*?)</div>', html, re.DOTALL)
    pairs = []
    for i in range(max(len(lt_blocks), len(dt_blocks))):
        lat = strip_html(lt_blocks[i]) if i < len(lt_blocks) else ""
        deu = strip_html(dt_blocks[i]) if i < len(dt_blocks) else ""
        if lat or deu:
            pairs.append({"latin": lat, "german": deu})
    # Extract title from page
    title_match = re.search(r"<TITLE>(.*?)</TITLE>", html, re.DOTALL)
    page_title = strip_html(title_match.group(1)).strip() if title_match else ""
    return {"title": page_title, "pairs": pairs, "lt_count": len(lt_blocks), "dt_count": len(dt_blocks)}


# ── Main orchestration ──


def save_checkpoint(data):
    """Save progress checkpoint."""
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    with open(CHECKPOINT_FILE, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False)


def load_checkpoint():
    """Load checkpoint if exists."""
    if CHECKPOINT_FILE.exists():
        with open(CHECKPOINT_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    return None


def main():
    resume = "--resume" in sys.argv
    index_only = "--index-only" in sys.argv

    DATA_DIR.mkdir(parents=True, exist_ok=True)

    # ── Phase 1: Build index ──
    if resume and INDEX_FILE.exists():
        print("Loading cached index...", file=sys.stderr)
        with open(INDEX_FILE, "r", encoding="utf-8") as f:
            all_masses = json.load(f)
    else:
        print("═══ Phase 1: Discovering all mass pages ═══", file=sys.stderr)
        all_masses = []
        all_masses.extend(discover_tempore_masses())
        time.sleep(DELAY)
        all_masses.extend(discover_sanctis_masses())
        time.sleep(DELAY)
        all_masses.extend(discover_commune_masses())
        time.sleep(DELAY)
        all_masses.extend(discover_special_pages())
        # Save index
        with open(INDEX_FILE, "w", encoding="utf-8") as f:
            json.dump(all_masses, f, ensure_ascii=False, indent=2)
        print(
            f"\nIndex saved: {len(all_masses)} masses -> {INDEX_FILE}",
            file=sys.stderr,
        )

    if index_only:
        print(f"Index complete: {len(all_masses)} masses", file=sys.stderr)
        return

    # ── Phase 2+3: Scrape each mass ──
    print(
        f"\n═══ Phase 2+3: Scraping {len(all_masses)} masses ═══", file=sys.stderr
    )

    # Load checkpoint for resume
    result = {}
    start_idx = 0
    if resume:
        checkpoint = load_checkpoint()
        if checkpoint:
            result = checkpoint.get("data", {})
            start_idx = checkpoint.get("next_idx", 0)
            print(
                f"Resuming from mass {start_idx}/{len(all_masses)} ({len(result)} already scraped)",
                file=sys.stderr,
            )

    for idx, mass in enumerate(all_masses):
        if idx < start_idx:
            continue

        mass_key = mass["path"]
        url = mass["url"]
        is_single = mass.get("is_single_page", False)

        print(
            f"[{idx+1}/{len(all_masses)}] {mass.get('title', mass_key)[:60]}",
            file=sys.stderr,
        )

        if is_single:
            # Single-page content (Ordo, Asperges, etc.)
            time.sleep(DELAY)
            content = extract_lt_dt(url)
            if content:
                result[mass_key] = {
                    "title": mass.get("title", ""),
                    "category": mass.get("category", ""),
                    "url": url,
                    "sections": [content],
                }
        else:
            # Multi-page mass with child nodes
            time.sleep(DELAY)
            nodes, mass_title = discover_child_nodes(url)
            sections = []
            for node in nodes:
                time.sleep(DELAY)
                content = extract_lt_dt(node["url"])
                if content:
                    content["node_file"] = node["file"]
                    content["node_title"] = node["title"]
                    sections.append(content)

            result[mass_key] = {
                "title": mass_title or mass.get("title", ""),
                "category": mass.get("category", ""),
                "url": url,
                "node_count": len(nodes),
                "sections": sections,
            }
            if mass.get("month"):
                result[mass_key]["month"] = mass["month"]

        # Save checkpoint every 10 masses
        if (idx + 1) % 10 == 0:
            save_checkpoint({"data": result, "next_idx": idx + 1})
            total_pairs = sum(
                sum(s.get("lt_count", 0) for s in m.get("sections", []))
                for m in result.values()
            )
            print(
                f"  Checkpoint: {idx+1}/{len(all_masses)} masses, {total_pairs} LT/DT pairs",
                file=sys.stderr,
            )

    # ── Save final output ──
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(result, f, ensure_ascii=False, indent=2)

    # Statistics
    total_masses = len(result)
    total_sections = sum(len(m.get("sections", [])) for m in result.values())
    total_pairs = sum(
        sum(len(s.get("pairs", [])) for s in m.get("sections", []))
        for m in result.values()
    )
    print(f"\n═══ Scraping complete ═══", file=sys.stderr)
    print(f"  Masses: {total_masses}", file=sys.stderr)
    print(f"  Sections: {total_sections}", file=sys.stderr)
    print(f"  LT/DT pairs: {total_pairs}", file=sys.stderr)
    print(f"  Output: {OUTPUT_FILE}", file=sys.stderr)

    # Clean up checkpoint
    if CHECKPOINT_FILE.exists():
        CHECKPOINT_FILE.unlink()


if __name__ == "__main__":
    main()
