# Messe-Booklet

Automatisierte Erstellung von A5-Booklets für die Heilige Messe in der außerordentlichen Form des Römischen Ritus (Missale Romanum 1962). Lateinisch-deutsche Texte nebeneinander, gesetzt mit [Typst](https://typst.app/).

## Überblick

Dieses Projekt erzeugt druckfertige A5-Hefte (Klammerheftung aus gefalteten A4-Blättern) mit den vollständigen Messtexten in Latein und Deutsch. Die Texte stammen aus dem [Mariawalder Messbuch](https://www.mariawalder-messbuch.de/as62/) und werden per Scraper extrahiert, strukturiert aufbereitet und über Typst-Templates zu PDFs kompiliert.

### Features

- **Bilingualer Satz** — Latein (kursiv) und Deutsch parallel in zwei Spalten
- **Farbcodierte Seitenstreifen** — Jeder liturgische Abschnitt erhält einen eigenen Farbcode mit unterschiedlichem Strichmuster (auch in S/W unterscheidbar)
- **Liturgische Symbole inline** — ✛ Kreuzzeichen, ⌒ Verneigung, Kniebeuge-/Steh-Figuren direkt im Fließtext
- **Vollständige Datenbank** — 435 Messen des gesamten Kirchenjahres als strukturiertes JSON (6.401 lat./dt. Textpaare)
- **Reproduzierbar** — Von Scraping über Datenaufbereitung bis PDF alles skriptgesteuert

## Projektstruktur

```
Messe-Booklet/
├── templates/           # Typst-Quelldateien (eine pro Sonntag/Fest)
│   ├── 2026-03-22.typ   # Dominica Passionis (Passionssonntag)
│   └── 2026-04-04.typ   # Vigilia Paschalis (Osternacht)
├── data/                # Gescrapte und aufbereitete liturgische Texte
│   ├── messbuch_full.json          # Gesamtes Messbuch (435 Messen, 6.6 MB)
│   ├── messbuch_index.json         # Index aller Messen mit URLs
│   ├── mariawald_karsamstag.json   # Osternacht detailliert (24 Abschnitte)
│   ├── 2026-03-22.yaml            # Passionssonntag-Daten
│   └── alte-messe-de.md            # Liturgisches Wissen von alte-messe.de (FSSP)
├── scripts/             # Scraping- und Aufbereitungsskripte
│   ├── scrape_full_messbuch.py     # Gesamtes Messbuch scrapen (435 Messen)
│   ├── convert_mariawald.py        # Einzelmesse scrapen → JSON
│   └── fill_template.py            # JSON-Daten in Typst-Template einsetzen
├── output/              # Kompilierte PDFs (gitignored)
├── docs/                # Dokumentation
│   └── OSTERNACHT.md    # Liturgische Struktur der Osternacht
└── .gitignore
```

## Voraussetzungen

- **Typst ≥ 0.12.0** — Satzsystem ([Installation](https://github.com/typst/typst/releases))
- **Python 3.10+** — Für die Scraping-Skripte (nur Standardbibliothek: `urllib`, `json`, `html`, `re`)
- **Schrift: Ubuntu Sans** — Muss auf dem System installiert sein

## Verwendung

### PDF kompilieren

```bash
# Einzelnes Booklet
typst compile templates/2026-04-04.typ output/2026-04-04.pdf

# Alle Templates
for f in templates/*.typ; do
  typst compile "$f" "output/$(basename "${f%.typ}").pdf"
done
```

### Neues Booklet erstellen

1. **Messe in der Datenbank finden:**
   ```bash
   python3 -c "
   import json
   with open('data/messbuch_full.json') as f:
       d = json.load(f)
   for key, mass in d.items():
       print(f\"{key}: {mass['title']}\")
   " | grep -i "pfingsten"
   ```

2. **Daten extrahieren und Template füllen:**
   - Ein bestehendes Template als Vorlage kopieren
   - Die JSON-Schlüssel der gewünschten Messe referenzieren
   - `scripts/fill_template.py` als Referenz für die Automatisierung verwenden

3. **Kompilieren:** `typst compile templates/DATUM.typ output/DATUM.pdf`

### Daten neu scrapen

```bash
# Nur der Index (schnell, ~30 Sekunden)
python3 scripts/scrape_full_messbuch.py --index-only

# Vollständiger Scrape aller 437 Messen (~20 Minuten)
python3 scripts/scrape_full_messbuch.py

# Fortsetzen nach Abbruch
python3 scripts/scrape_full_messbuch.py --resume
```

## Datenformat

### messbuch_full.json

Jeder Eintrag ist eine Messe, indiziert nach relativem URL-Pfad:

```json
{
  "advzeit/advso1/index.html": {
    "title": "Missa 'Ad te levavi'",
    "category": "tempore",
    "url": "https://www.mariawalder-messbuch.de/as62/advzeit/advso1/index.html",
    "node_count": 13,
    "sections": [
      {
        "title": "Introitus",
        "node_file": "node3.html",
        "node_title": "Introitus",
        "lt_count": 1,
        "dt_count": 1,
        "pairs": [
          {
            "latin": "Ad te levávi ánimam meam…",
            "german": "Zu dir erhebe ich meine Seele…"
          }
        ]
      }
    ]
  }
}
```

### Kategorien

| Kategorie | Anzahl | Beschreibung |
|-----------|--------|--------------|
| `tempore` | 139 | Proprium de Tempore (Kirchenjahreskreis) |
| `sanctis` | 285 | Proprium de Sanctis (Heiligenfeste) |
| `commune_bmv` | 7 | Commune B. Mariæ Virginis |
| `commune_sanctorum` | 1 | Commune Sanctorum |
| `ordo` | 1 | Ordo Missæ (Messordnung) |
| `asperges` | 1 | Asperges / Vidi aquam |
| `danksagung` | 1 | Danksagung nach der Messe |
| **Gesamt** | **435** | **5.919 Abschnitte, 6.401 Textpaare** |

### HTML-Extraktion

Die Quelle ([mariawalder-messbuch.de](https://www.mariawalder-messbuch.de/as62/)) verwendet ein konsistentes Schema:

- `<div class="LT">` — Lateinischer Text
- `<div class="DT">` — Deutscher Text
- LT/DT-Blöcke treten immer paarweise auf

Der Scraper extrahiert diese Paare, dekodiert HTML-Entities (`&aelig;` → `æ`, `&oelig;` → `œ` etc.) und bereinigt Whitespace.

## Template-Aufbau (Typst)

### Hilfsfunktionen

| Funktion | Zweck |
|----------|-------|
| `#bilingue(lat, deu)` | Zweispaltiger lat./dt. Block |
| `#abschnitt(strich)[…]` | Abschnitt mit farbigem Seitenstreifen |
| `#rubrik[…]` | Regieanweisung (6.5pt, schwarz, kursiv) |
| `#section-title("…", farbe: …)` | Abschnittsüberschrift mit Unterstrich |
| `#teil-label("…", farbe)` | Farbiger Abschnittskopf (weiß auf Farbe) |
| `#referenz[…]` | Bibelstellenangabe |

### Liturgische Inline-Symbole

| Symbol | Typst-Code | Bedeutung |
|--------|------------|-----------|
| ✛ | `#kreuz` | Kreuzzeichen |
| ✛✛✛ | `#dreikreuz` | Dreifaches Kreuz (Stirn, Mund, Brust) |
| ⌒ | `#verneigung` | Verneigung des Hauptes |
| ![FA](https://fontawesome.com/icons/person-praying) | `#kniebeuge` | Knien / Kniebeuge (Font Awesome `f683`) |
| ![FA](https://fontawesome.com/icons/person) | `#stehen` | Stehen (Font Awesome `f183`) |

Diese Symbole werden inline im Gebetstext verwendet, z.B.:
```typst
#bilingue(
  [#verneigung Adorámus te. Glorificámus te.],
  [#verneigung Wir beten Dich an. Wir verherrlichen Dich.],
)
```

### Farbschema (Osternacht)

| Farbe | Code | Teil | Strichmuster |
|-------|------|------|--------------|
| Gold | `#D4A017` | I Lucernarium + VII Laudes | `·:·:·` (eng getrippt) |
| Dunkelblau | `#1B4F72` | II Prophetien | `── ──` (lang gestrichelt) |
| Grau | `#707070` | III Litanei | `━━━` (durchgezogen) |
| Blaugrün | `#1A8476` | IV Taufwasserweihe | `─ ─` (kurz gestrichelt) |
| Silbergrau | `#606060` | V Taufversprechen | `─·─` (gleichmäßig) |
| Burgunder | `#922B21` | VI Ostermesse | `·· ··` (gepunktet) |

## Fertige Booklets

### Dominica Passionis — 22. März 2026
- **Datei:** `templates/2026-03-22.typ`
- **Seiten:** ~20 (A5)
- **Inhalt:** Vollständige Messe mit Stufengebet, Introitus, Gloria, Credo, Schlussevangelium

### Vigilia Paschalis — 4. April 2026
- **Datei:** `templates/2026-04-04.typ`
- **Seiten:** 24 (A5, Klammerheftung)
- **Inhalt:** Alle 7 Teile der Osternacht:
  - I · Lucernarium (Feuerweihe, Osterkerze, Prozession, Exsultet)
  - II · Prophetien (4 Lesungen mit Cantica und Orationen)
  - III · Allerheiligenlitanei — Erster Teil
  - IV · Taufwasserweihe (Präfation, Eintauchen, Sicut cervus)
  - V · Erneuerung der Taufversprechen (Abschwörung, Besprengung, Vidi aquam)
  - VI · Ostermesse (Litanei II, Gloria!, Epistel, Alleluia, Evangelium, Canon, Kommunion)
  - VII · Laudes (Ps 150, Benedictus, Postcommunio)

## Druck

Die PDFs sind für **A5-Klammerheftung** ausgelegt:

1. PDF im A4-Booklet-Modus drucken (beidseitig, kurze Seite)
2. Alle Blätter zusammen in der Mitte falten
3. Mit Langarmhefter in der Falz heften

Die Seitenzahl ist immer ein Vielfaches von 4 (bei der Osternacht: 24 Seiten = 6 Blatt A4 = 3 Doppelblätter).

## Datenquellen

- **[mariawalder-messbuch.de](https://www.mariawalder-messbuch.de/as62/)** — Online-Messbuch für die außerordentliche Form des Römischen Ritus (Missale Romanum 1962, Ordo 1955/1962). Betrieben von der ehemaligen Trappistenabtei Mariawald. Quelle für alle liturgischen Texte.
- **[alte-messe.de](http://alte-messe.de/)** — Apostolat der Priesterbruderschaft St. Petrus (FSSP). Erklärung aller Riten der heiligen Messe nach P. Martin Ramm FSSP, „Zum Altare Gottes will ich treten". Zusammengefasst in `data/alte-messe-de.md`.

## Lizenz

Die Skripte und Templates stehen unter MIT. Die liturgischen Texte unterliegen dem Urheberrecht der jeweiligen Übersetzer/Herausgeber.
