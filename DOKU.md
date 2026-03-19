# Messe-Booklet (archiviert)

> **Dieses Repository wurde in [die-heilige-messe.de](https://github.com/JanMrlth/die-heilige-messe.de) konsolidiert.**
> Alle Daten, Scraper, Templates und Booklet-Generierung befinden sich jetzt dort.

## Was wurde übernommen

| Datei | Ziel in messe-web |
|---|---|
| `data/messbuch_full.json` | `data/messbuch_full.json` |
| `data/messbuch_index.json` | `data/messbuch_index.json` |
| `data/mariawald_karsamstag.json` | `data/mariawald_karsamstag.json` |
| `data/alte-messe-de.md` | `data/alte-messe-de.md` |
| `docs/OSTERNACHT.md` | `data/OSTERNACHT.md` |
| `scripts/scrape_full_messbuch.py` | `scripts/scrape_full_messbuch.py` |
| `scripts/convert_mariawald.py` | `scripts/convert_mariawald.py` |

## Weiterhin hier (historisch)

- `templates/2026-03-22.typ` — frühe Version Passionssonntag (aktuell in messe-web als `_current.typ`)
- `templates/2026-04-04.typ` — frühe Version Osternacht (aktuell in messe-web als `osternacht.typ`)
- `scripts/fill_template.py` — nicht mehr genutzt
- `data/2026-03-22.yaml` — nicht mehr genutzt

## Datenquellen

- **[mariawalder-messbuch.de](https://www.mariawalder-messbuch.de/as62/)** — Online-Messbuch (Missale Romanum 1962). Quelle für alle liturgischen Texte.
- **[alte-messe.de](http://alte-messe.de/)** — Ritenerklärung nach P. Martin Ramm FSSP.

Skripte und Templates: MIT. Liturgische Texte: Urheberrecht der jeweiligen Übersetzer/Herausgeber.
