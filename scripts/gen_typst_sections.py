#!/usr/bin/env python3
"""
Generate Typst code blocks from structured Mariawald JSON data.
Outputs the bilingue() blocks for each section to be pasted into the template.
"""

import json
import re


def load():
    with open('data/mariawald_karsamstag.json') as f:
        return json.load(f)


def escape_typst(text):
    """Escape Typst special characters in liturgical text."""
    # Replace characters that have special meaning in Typst content blocks
    text = text.replace('#', r'\#')
    text = text.replace('$', r'\$')
    text = text.replace('@', r'\@')
    # Newlines -> Typst line breaks
    text = text.replace('\n', ' \\\n')
    return text


def bilingue_block(latin, german, breakable=True):
    """Generate a #bilingue() Typst block."""
    lat = escape_typst(latin)
    deu = escape_typst(german)
    if breakable:
        return f'  #bilingue(\n    [{lat}],\n    [{deu}],\n  )'
    else:
        return f'  #block(breakable: false)[\n    #bilingue(\n      [{lat}],\n      [{deu}],\n    )\n  ]'


def section_separator():
    return '#v(2pt)'


def main():
    d = load()

    out = []

    # ═══ TEIL II — PROPHETIEN ═══
    out.append('// ═══ GENERATED: Teil II — Prophetien ═══\n')

    # Prophetie I — Gen 1,1-31; 2,1-2
    out.append('// --- Prophetie I: Genesis ---')
    p = d['node7']['pairs']
    out.append(bilingue_block(p[0]['latin'], p[0]['german']))
    out.append(section_separator())
    out.append(f'  #rubrik[Orémus. — Flectámus génua. — Leváte. #kniebeuge #stehen]')
    out.append(bilingue_block(p[2]['latin'], p[2]['german'], breakable=False))

    out.append('\n// --- Prophetie II: Exodus ---')
    p = d['node8']['pairs']
    out.append(bilingue_block(p[0]['latin'], p[0]['german']))
    out.append(section_separator())
    out.append('  #section-title("Canticum — Cantémus Dómino", farbe: prophetien-farbe)')
    out.append('  #referenz[Ex 15,1–2]')
    out.append(bilingue_block(p[1]['latin'], p[1]['german']))
    out.append(section_separator())
    out.append(f'  #rubrik[Orémus. — Flectámus génua. — Leváte. #kniebeuge #stehen]')
    out.append(bilingue_block(p[3]['latin'], p[3]['german'], breakable=False))

    out.append('\n// --- Prophetie III: Jesaja ---')
    p = d['node9']['pairs']
    out.append(bilingue_block(p[0]['latin'], p[0]['german']))
    out.append(section_separator())
    out.append('  #section-title("Canticum — Vínea facta est", farbe: prophetien-farbe)')
    out.append('  #referenz[Jes 5,1–2]')
    out.append(bilingue_block(p[1]['latin'], p[1]['german']))
    out.append(section_separator())
    out.append(f'  #rubrik[Orémus. — Flectámus génua. — Leváte. #kniebeuge #stehen]')
    out.append(bilingue_block(p[3]['latin'], p[3]['german'], breakable=False))

    out.append('\n// --- Prophetie IV: Deuteronomium ---')
    p = d['node10']['pairs']
    out.append(bilingue_block(p[0]['latin'], p[0]['german']))
    out.append(section_separator())
    out.append('  #section-title("Canticum — Atténde, cælum", farbe: prophetien-farbe)')
    out.append('  #referenz[Dtn 32,1–4]')
    out.append(bilingue_block(p[1]['latin'], p[1]['german']))
    out.append(section_separator())
    out.append(f'  #rubrik[Orémus. — Flectámus génua. — Leváte. #kniebeuge #stehen]')
    out.append(bilingue_block(p[3]['latin'], p[3]['german'], breakable=False))

    # ═══ TEIL III — LITANEI I ═══
    out.append('\n\n// ═══ GENERATED: Teil III — Litanei I ═══\n')
    pairs = d['node11']['pairs']
    for i, p in enumerate(pairs):
        breakable = len(p['latin']) > 100
        out.append(bilingue_block(p['latin'], p['german'], breakable=breakable))
        if i < len(pairs) - 1:
            out.append('  #v(1pt)')

    # ═══ TEIL IV — TAUFWASSERWEIHE ═══
    out.append('\n\n// ═══ GENERATED: Teil IV — Taufwasserweihe ═══\n')
    out.append('// --- Taufwasserweihe (node12) ---')
    pairs = d['node12']['pairs']
    for i, p in enumerate(pairs):
        if len(p['latin']) < 100:
            out.append(bilingue_block(p['latin'], p['german'], breakable=False))
        else:
            out.append(bilingue_block(p['latin'], p['german']))
        if i < len(pairs) - 1:
            out.append('  #v(1pt)')

    out.append('\n// --- Sicut cervus (node13) ---')
    pairs = d['node13']['pairs']
    for i, p in enumerate(pairs):
        out.append(bilingue_block(p['latin'], p['german'], breakable=len(p['latin']) < 100))
        if i < len(pairs) - 1:
            out.append('  #v(1pt)')

    # ═══ TEIL V — TAUFVERSPRECHEN ═══
    out.append('\n\n// ═══ GENERATED: Teil V — Taufversprechen ═══\n')
    pairs = d['node14']['pairs']
    for i, p in enumerate(pairs):
        out.append(bilingue_block(p['latin'], p['german'], breakable=False))
        if i < len(pairs) - 1:
            out.append('  #v(1pt)')

    # ═══ TEIL VI — OSTERMESSE ═══
    out.append('\n\n// ═══ GENERATED: Teil VI — Ostermesse ═══\n')

    out.append('// --- Kyrie (node15 pairs 0-2) ---')
    for i in range(3):
        p = d['node15']['pairs'][i]
        out.append(bilingue_block(p['latin'], p['german'], breakable=False))
        out.append('  #v(1pt)')

    out.append('\n// --- Gloria (node15 pair 3) ---')
    p = d['node15']['pairs'][3]
    out.append(bilingue_block(p['latin'], p['german']))

    out.append('\n// --- Collecta (node16) ---')
    p = d['node16']['pairs'][0]
    out.append(bilingue_block(p['latin'], p['german'], breakable=False))

    out.append('\n// --- Epistel (node17) ---')
    p = d['node17']['pairs'][0]
    out.append(bilingue_block(p['latin'], p['german']))

    out.append('\n// --- Alleluia (node18) ---')
    for i, p in enumerate(d['node18']['pairs']):
        out.append(bilingue_block(p['latin'], p['german'], breakable=False))
        if i < len(d['node18']['pairs']) - 1:
            out.append('  #v(1pt)')

    out.append('\n// --- Evangelium (node19) ---')
    p = d['node19']['pairs'][0]
    out.append(bilingue_block(p['latin'], p['german']))

    out.append('\n// --- Secreta (node20) ---')
    p = d['node20']['pairs'][0]
    out.append(bilingue_block(p['latin'], p['german'], breakable=False))

    out.append('\n// --- Praefatio (node21) ---')
    for i, p in enumerate(d['node21']['pairs']):
        out.append(bilingue_block(p['latin'], p['german']))
        if i < len(d['node21']['pairs']) - 1:
            out.append('  #v(1pt)')

    out.append('\n// --- Communicantes (node22) ---')
    p = d['node22']['pairs'][0]
    out.append(bilingue_block(p['latin'], p['german']))

    out.append('\n// --- Hanc igitur (node23) ---')
    p = d['node23']['pairs'][0]
    out.append(bilingue_block(p['latin'], p['german'], breakable=False))

    out.append('\n// --- Communio (node24) ---')
    p = d['node24']['pairs'][0]
    out.append(bilingue_block(p['latin'], p['german']))

    # ═══ TEIL VII — LAUDES ═══
    out.append('\n\n// ═══ GENERATED: Teil VII — Laudes ═══\n')

    out.append('// --- Ps 150 (node25 pairs 0-1) ---')
    for i in range(2):
        p = d['node25']['pairs'][i]
        out.append(bilingue_block(p['latin'], p['german']))
        out.append('  #v(1pt)')

    out.append('\n// --- Benedictus (node25 pairs 2-4) ---')
    for i in range(2, len(d['node25']['pairs'])):
        p = d['node25']['pairs'][i]
        out.append(bilingue_block(p['latin'], p['german']))
        if i < len(d['node25']['pairs']) - 1:
            out.append('  #v(1pt)')

    out.append('\n// --- Postcommunio (node26) ---')
    for i, p in enumerate(d['node26']['pairs']):
        out.append(bilingue_block(p['latin'], p['german'], breakable=len(p['latin']) < 100))
        if i < len(d['node26']['pairs']) - 1:
            out.append('  #v(1pt)')

    # Write output
    with open('data/generated_typst_sections.typ', 'w', encoding='utf-8') as f:
        f.write('\n'.join(out))
    print(f'Wrote {len(out)} lines to data/generated_typst_sections.typ')


if __name__ == '__main__':
    main()
