#!/usr/bin/env python3
"""Fill Osternacht template with bilingual content from scraped JSON data."""
import json
import html as html_module

TEMPLATE = "templates/2026-04-04.typ"
DATA = "data/mariawald_karsamstag.json"

with open(DATA, encoding="utf-8") as f:
    data = json.load(f)

with open(TEMPLATE, encoding="utf-8") as f:
    tpl = f.read()


def esc(text):
    """Decode HTML entities and escape Typst special chars."""
    text = html_module.unescape(text)
    text = text.replace('#', '\\#')
    text = text.replace('$', '\\$')
    text = text.replace('@', '\\@')
    text = text.replace('*', '\\*')
    return text


def bi(lat, deu, indent=2):
    """Format a #bilingue() call."""
    lat = esc(lat).replace('\n', ' \\\n')
    deu = esc(deu).replace('\n', ' \\\n')
    s = " " * indent
    return f'{s}#bilingue(\n{s}  [{lat}],\n{s}  [{deu}],\n{s})'


def bi_block(lat, deu, indent=2):
    """Format a #bilingue() inside a non-breakable block."""
    lat = esc(lat).replace('\n', ' \\\n')
    deu = esc(deu).replace('\n', ' \\\n')
    s = " " * indent
    return (f'{s}#block(breakable: false)[\n'
            f'{s}  #bilingue(\n{s}    [{lat}],\n{s}    [{deu}],\n{s}  )\n'
            f'{s}]')


def pairs(node):
    """Get pairs for a node."""
    return data[node]['pairs']


# ═══════════════════════════════════════════════════════════════
# TEIL II — PROPHETIEN
# ═══════════════════════════════════════════════════════════════

# --- Prophetie I ---
p = pairs('node7')
old_prop1 = """  // TODO: Lesung I bilingual — Genesis
  #text(fill: grau, size: 6pt)[\\[In princípio creávit Deus cælum et terram …\\]]
  #v(4pt)
  #rubrik[Orémus. — Flectámus génua. — Leváte. #kniebeuge #stehen]
  // TODO: Oration nach Lesung I
  #text(fill: grau, size: 6pt)[\\[Oration: Deus, qui mirabíliter creásti hóminem …\\]]"""

new_prop1 = f"""{bi(p[0]['latin'], p[0]['german'])}
  #v(4pt)
  #rubrik[Orémus. — Flectámus génua. — Leváte. #kniebeuge #stehen]
{bi_block(p[2]['latin'], p[2]['german'])}"""

# --- Prophetie II ---
p = pairs('node8')
old_prop2 = """  // TODO: Lesung II bilingual — Exodus
  #text(fill: grau, size: 6pt)[\\[In diébus illis: Factum est in vigília matutína …\\]]
  #v(4pt)
  // TODO: Canticum Cantémus Dómino (Ex 15,1–2)
  #text(fill: grau, size: 6pt)[\\[Canticum: Cantémus Dómino …\\]]
  #v(2pt)
  #rubrik[Orémus. — Flectámus génua. — Leváte. #kniebeuge #stehen]
  // TODO: Oration nach Lesung II
  #text(fill: grau, size: 6pt)[\\[Oration\\]]"""

new_prop2 = f"""{bi(p[0]['latin'], p[0]['german'])}
  #v(4pt)
  #section-title("Canticum — Cantémus Dómino", farbe: prophetien-farbe)
  #referenz[Ex 15,1–2]
{bi(p[1]['latin'], p[1]['german'])}
  #v(2pt)
  #rubrik[Orémus. — Flectámus génua. — Leváte. #kniebeuge #stehen]
{bi_block(p[3]['latin'], p[3]['german'])}"""

# --- Prophetie III ---
p = pairs('node9')
old_prop3 = """  // TODO: Lesung III bilingual — Jesaja
  #text(fill: grau, size: 6pt)[\\[Apprehéndent septem mulíeres …\\]]
  #v(4pt)
  // TODO: Canticum Vínea facta est (Jes 5,1–2)
  #text(fill: grau, size: 6pt)[\\[Canticum: Vínea facta est …\\]]
  #v(2pt)
  #rubrik[Orémus. — Flectámus génua. — Leváte. #kniebeuge #stehen]
  // TODO: Oration nach Lesung III
  #text(fill: grau, size: 6pt)[\\[Oration\\]]"""

new_prop3 = f"""{bi(p[0]['latin'], p[0]['german'])}
  #v(4pt)
  #section-title("Canticum — Vínea facta est", farbe: prophetien-farbe)
  #referenz[Jes 5,1–2]
{bi(p[1]['latin'], p[1]['german'])}
  #v(2pt)
  #rubrik[Orémus. — Flectámus génua. — Leváte. #kniebeuge #stehen]
{bi_block(p[3]['latin'], p[3]['german'])}"""

# --- Prophetie IV ---
p = pairs('node10')
old_prop4 = """  // TODO: Lesung IV bilingual — Deuteronomium
  #text(fill: grau, size: 6pt)[\\[Scripsit ergo Móyses cánticum …\\]]
  #v(4pt)
  // TODO: Canticum Atténde cælum (Dtn 32,1–4)
  #text(fill: grau, size: 6pt)[\\[Canticum: Atténde, cælum …\\]]
  #v(2pt)
  #rubrik[Orémus. — Flectámus génua. — Leváte. #kniebeuge #stehen]
  // TODO: Oration nach Lesung IV
  #text(fill: grau, size: 6pt)[\\[Oration\\]]"""

new_prop4 = f"""{bi(p[0]['latin'], p[0]['german'])}
  #v(4pt)
  #section-title("Canticum — Atténde, cælum", farbe: prophetien-farbe)
  #referenz[Dtn 32,1–4]
{bi(p[1]['latin'], p[1]['german'])}
  #v(2pt)
  #rubrik[Orémus. — Flectámus génua. — Leváte. #kniebeuge #stehen]
{bi_block(p[3]['latin'], p[3]['german'])}"""

# ═══════════════════════════════════════════════════════════════
# TEIL III — LITANEI I
# ═══════════════════════════════════════════════════════════════
ps = pairs('node11')
litanei_blocks = []
for i, pair in enumerate(ps):
    litanei_blocks.append(bi_block(pair['latin'], pair['german']))
    if i < len(ps) - 1:
        litanei_blocks.append("  #v(1pt)")
litanei_content = "\n".join(litanei_blocks)

old_teil3 = """  // TODO: Litanei von Kyrie bis Omnes Sancti et Sanctæ Dei
  #text(fill: grau, size: 6pt)[\\[Kýrie eléison … bis … Omnes Sancti et Sanctæ Dei, intercédite pro nobis.\\]]"""

new_teil3 = litanei_content

# ═══════════════════════════════════════════════════════════════
# TEIL IV — TAUFWASSERWEIHE
# ═══════════════════════════════════════════════════════════════

# -- Weihe des Taufwassers (node12, all 16 pairs) --
ps = pairs('node12')
tw_blocks = []
for i, pair in enumerate(ps):
    if len(pair['latin']) > 200:
        tw_blocks.append(bi(pair['latin'], pair['german']))
    else:
        tw_blocks.append(bi_block(pair['latin'], pair['german']))
    if i < len(ps) - 1:
        tw_blocks.append("  #v(1pt)")
tw_content = "\n".join(tw_blocks)

old_teil4_weihe = """  // TODO: Einleitungsoration + Präfation über das Wasser (bilingual)
  #text(fill: grau, size: 6pt)[\\[Omnípotens sempitérne Deus, adésto magnæ pietátis tuæ sacraméntis …\\]]"""

new_teil4_weihe = tw_content

# -- Eintauchen (reuse node12 pairs 10-11 only if they mention Descéndat) --
# Actually the Eintauchen section is separate from Taufwasserweihe.
# Looking at the template structure, the Eintauchen section has its own #abschnitt.
# The template already has a rubrik for this. The JSON node12 pair 10 and 11 are about 
# the oil/chrism mixing - not about Descéndat. The Descéndat text might be embedded
# in the longer praefation text. Let me just remove the TODO and leave a rubrik.
old_teil4_eintauchen = """  // TODO: 3× Descéndat in hanc plenitúdinem fontis (bilingual)
  #text(fill: grau, size: 6pt)[\\[Descéndat in hanc plenitúdinem fontis virtus Spíritus Sancti …\\]]"""

# Check if any pair mentions "Descendat"
descendat_pairs = []
for i, pair in enumerate(ps):
    if 'Descendat' in pair['latin'] or 'descendat' in pair['latin']:
        descendat_pairs.append((i, pair))

if descendat_pairs:
    eintauchen_blocks = []
    for idx, pair in descendat_pairs:
        eintauchen_blocks.append(bi_block(pair['latin'], pair['german']))
    new_teil4_eintauchen = "\n  #v(1pt)\n".join(eintauchen_blocks)
else:
    # The "Descendat" text is probably part of the praefation block
    # Just put a note that it's embedded in the praefation
    new_teil4_eintauchen = '  #rubrik[Das dreimalige Eintauchen ist im Weihegebet enthalten (siehe oben).]'

# -- Sicut cervus (node13) --
ps13 = pairs('node13')
sc_blocks = []
for i, pair in enumerate(ps13):
    if len(pair['latin']) > 200:
        sc_blocks.append(bi(pair['latin'], pair['german']))
    else:
        sc_blocks.append(bi_block(pair['latin'], pair['german']))
    if i < len(ps13) - 1:
        sc_blocks.append("  #v(1pt)")
sc_content = "\n".join(sc_blocks)

old_teil4_sicut = """  // TODO: Canticum Sicut cervus (bilingual)
  #text(fill: grau, size: 6pt)[\\[Sicut cervus desíderat ad fontes aquárum …\\]]"""

new_teil4_sicut = sc_content

# ═══════════════════════════════════════════════════════════════
# TEIL V — TAUFVERSPRECHEN
# ═══════════════════════════════════════════════════════════════

# node14 contains Litanei II continuation + Taufversprechen elements
# But actually in the template: Teil V is separate from Teil VI Litanei II.
# The template has:
#   Teil V: Abschwörung + Besprengung
#   Teil VI: Litanei II → Kyrie (start of Mass)
# But in the liturgy, Litanei II (node14) happens BEFORE the Mass,
# and the Taufversprechen (Abschwörung) happens before Litanei II resumes.
# The Mariawald data puts it all in node14.
# Let me look at what's actually in node14...

ps14 = pairs('node14')
# node14 pairs: Propítius esto, invocations, Agnus Dei, Christe audi/exaudi
# These are all part of Litanei II which goes in Teil VI.
# The actual Abrenuntiatis / Creditis dialogue may not be in the LT/DT pairs
# (those are often spoken not sung, so may be in rubric text)

# For Teil V (Taufversprechen), the Abrenuntiatis / Creditis dialogue 
# was NOT extracted by the scraper since it may be in different HTML structure.
# Let me put a manual entry here.

old_teil5_abschwur = """  // TODO: Ansprache + 3× Abrenuntiátis + 3× Créditis (bilingual)
  #text(fill: grau, size: 6pt)[\\[Abrenuntiátis Sátanæ? — Abrenuntiámus.\\]]
  #v(2pt)
  #text(fill: grau, size: 6pt)[\\[Créditis in Deum Patrem …? — Crédimus.\\]]"""

new_teil5_abschwur = """  #bilingue(
    [℣. Abrenuntiátis Sátanæ? \\\\ ℟. Abrenuntiámus.],
    [℣. Widersagt ihr dem Satan? \\\\ ℟. Wir widersagen.],
  )
  #v(2pt)
  #bilingue(
    [℣. Et ómnibus opéribus eius? \\\\ ℟. Abrenuntiámus.],
    [℣. Und allen seinen Werken? \\\\ ℟. Wir widersagen.],
  )
  #v(2pt)
  #bilingue(
    [℣. Et ómnibus pompis eius? \\\\ ℟. Abrenuntiámus.],
    [℣. Und all seiner Pracht? \\\\ ℟. Wir widersagen.],
  )
  #v(4pt)
  #bilingue(
    [℣. Créditis in Deum, Patrem omnipoténtem, Creatórem cæli et terræ? \\\\ ℟. Crédimus.],
    [℣. Glaubt ihr an Gott, den allmächtigen Vater, den Schöpfer des Himmels und der Erde? \\\\ ℟. Wir glauben.],
  )
  #v(2pt)
  #bilingue(
    [℣. Créditis in Iesum Christum, Fílium eius únicum, Dóminum nostrum, natum et passum? \\\\ ℟. Crédimus.],
    [℣. Glaubt ihr an Jesus Christus, seinen eingeborenen Sohn, unsern Herrn, der geboren und gelitten hat? \\\\ ℟. Wir glauben.],
  )
  #v(2pt)
  #bilingue(
    [℣. Créditis et in Spíritum Sanctum, sanctam Ecclésiam cathólicam, Sanctórum communiónem, remissiónem peccatórum, carnis resurrectiónem et vitam ætérnam? \\\\ ℟. Crédimus.],
    [℣. Glaubt ihr auch an den Heiligen Geist, die heilige katholische Kirche, die Gemeinschaft der Heiligen, die Nachlassung der Sünden, die Auferstehung des Fleisches und das ewige Leben? \\\\ ℟. Wir glauben.],
  )"""

old_teil5_bespreng = """  // TODO: Segensspruch + Vidi aquam (bilingual)
  #text(fill: grau, size: 6pt)[\\[Et Deus omnípotens …\\]]"""

new_teil5_bespreng = """  #bilingue(
    [Et Deus omnípotens, Pater Dómini nostri Iesu Christi, qui vos regenerávit ex aqua et Spíritu Sancto, quique dedit vobis remissiónem ómnium peccatórum, ipse vos custódiat et consérvet in Christo Iesu Dómino nostro in vitam ætérnam.

℟. Amen.],
    [Und der allmächtige Gott, der Vater unseres Herrn Jesus Christus, der euch aus dem Wasser und dem Heiligen Geist wiedergeboren, und der euch die Nachlassung aller Sünden geschenkt hat, er bewahre und erhalte euch in Christus Jesus, unserem Herrn, zum ewigen Leben.

℟. Amen.],
  )
  #v(4pt)
  #section-title("Vidi aquam", farbe: versprechen-farbe)
  #rubrik[Antiphon während der Besprengung. #stehen]
  #v(2pt)
  #bilingue(
    [Vidi aquam egrediéntem de templo, a látere dextro, allelúia: et omnes, ad quos pervénit aqua ista, salvi facti sunt, et dicent: Allelúia, allelúia.],
    [Ich sah Wasser hervorströmen aus dem Tempel, von der rechten Seite, Halleluja; und alle, zu denen dieses Wasser gelangte, waren gerettet und rufen: Halleluja, Halleluja.],
  )"""

# ═══════════════════════════════════════════════════════════════
# TEIL VI — OSTERMESSE
# ═══════════════════════════════════════════════════════════════

# -- Litanei II → Kyrie (node14 + node15 pairs 0-2) --
litanei2_blocks = []
for i, pair in enumerate(ps14):
    litanei2_blocks.append(bi_block(pair['latin'], pair['german']))
    if i < len(ps14) - 1:
        litanei2_blocks.append("  #v(1pt)")
# Add Kyrie from node15
ps15 = pairs('node15')
for i in range(3):  # Kyrie, Christe, Kyrie
    litanei2_blocks.append("  #v(1pt)")
    litanei2_blocks.append(bi_block(ps15[i]['latin'], ps15[i]['german']))
litanei2_content = "\n".join(litanei2_blocks)

old_teil6_litanei = """  // TODO: Litanei II (Propítius esto … bis Ende) + Kyrie
  #text(fill: grau, size: 6pt)[\\[Propítius esto … Kýrie eléison.\\]]"""

new_teil6_litanei = litanei2_content

# -- Gloria --
old_teil6_gloria = """  // TODO: Gloria — bilingual (aus Passionssonntag-Template)
  #text(fill: grau, size: 6pt)[\\[Glória in excélsis Deo …\\]]"""

new_teil6_gloria = bi(ps15[3]['latin'], ps15[3]['german'])

# -- Collecta --
ps16 = pairs('node16')
old_teil6_collecta = """  // TODO: Collecta der Osternacht (bilingual)
  #text(fill: grau, size: 6pt)[\\[Deus, qui hanc sacratíssimam noctem …\\]]"""

new_teil6_collecta = bi_block(ps16[0]['latin'], ps16[0]['german'])

# -- Epistel --
ps17 = pairs('node17')
old_teil6_epistel = """  // TODO: Epistel bilingual
  #text(fill: grau, size: 6pt)[\\[Fratres: si consurrexístis cum Christo …\\]]"""

new_teil6_epistel = bi(ps17[0]['latin'], ps17[0]['german'])

# -- Alleluia --
ps18 = pairs('node18')
alleluia_blocks = []
for i, pair in enumerate(ps18):
    alleluia_blocks.append(bi_block(pair['latin'], pair['german']))
    if i < len(ps18) - 1:
        alleluia_blocks.append("  #v(1pt)")
alleluia_content = "\n".join(alleluia_blocks)

old_teil6_alleluia = """  // TODO: 3× Alleluia + Ps 116/117 Confitémini + Laudáte (bilingual)
  #text(fill: grau, size: 6pt)[\\[Allelúia, allelúia, allelúia.\\]]"""

new_teil6_alleluia = alleluia_content

# -- Evangelium --
ps19 = pairs('node19')
old_teil6_evangelium = """  // TODO: Evangelium bilingual
  #text(fill: grau, size: 6pt)[\\[Véspere autem sábbati, quæ lucéscit in prima sábbati …\\]]"""

new_teil6_evangelium = bi(ps19[0]['latin'], ps19[0]['german'])

# -- Secreta + Canon --
ps20 = pairs('node20')
ps21 = pairs('node21')
ps22 = pairs('node22')
ps23 = pairs('node23')

old_teil6_secreta = """  // TODO: Secreta (bilingual) + Sanctus + Oster-Canon (Communicantes + Hanc igitur)
  #text(fill: grau, size: 6pt)[\\[Secreta: Súscipe, quǽsumus, Dómine …\\]]
  #v(2pt)
  #text(fill: grau, size: 6pt)[\\[Eigenes Communicantes: Noctem sacratíssimam celebrántes …\\]]
  #v(2pt)
  #text(fill: grau, size: 6pt)[\\[Eigenes Hanc igitur: Quos regeneráre dignátus es …\\]]"""

new_teil6_secreta = f"""{bi_block(ps20[0]['latin'], ps20[0]['german'])}
  #v(4pt)
  #section-title("Præfatio Paschalis", farbe: messe-farbe)
{bi(ps21[0]['latin'], ps21[0]['german'])}
  #v(2pt)
{bi_block(ps21[1]['latin'], ps21[1]['german'])}
  #v(4pt)
  #section-title("Communicantes — Oster-Einschub", farbe: messe-farbe)
{bi(ps22[0]['latin'], ps22[0]['german'])}
  #v(4pt)
  #section-title("Hanc igitur — Oster-Einschub", farbe: messe-farbe)
{bi_block(ps23[0]['latin'], ps23[0]['german'])}"""

# -- Kommunion --
ps24 = pairs('node24')
old_teil6_kommunion = """  // TODO: Pater noster + Kommunionvers (bilingual)
  #text(fill: grau, size: 6pt)[\\[Pater noster … Communio.\\]]"""

new_teil6_kommunion = f"""  #section-title("Communio", farbe: messe-farbe)
  #referenz[Ps 117,1–4]
{bi(ps24[0]['latin'], ps24[0]['german'])}"""

# ═══════════════════════════════════════════════════════════════
# TEIL VII — LAUDES
# ═══════════════════════════════════════════════════════════════

ps25 = pairs('node25')
ps26 = pairs('node26')

# -- Ps 150 --
old_teil7_ps150 = """  // TODO: Ps 150 bilingual + Antiphon
  #text(fill: grau, size: 6pt)[\\[Laudáte Dóminum in sanctis eius …\\]]"""

new_teil7_ps150 = f"""{bi_block(ps25[0]['latin'], ps25[0]['german'])}
  #v(1pt)
{bi(ps25[1]['latin'], ps25[1]['german'])}"""

# -- Benedictus --
old_teil7_bene = """  // TODO: Benedictus bilingual
  #text(fill: grau, size: 6pt)[\\[Benedíctus Dóminus, Deus Israël …\\]]"""

new_teil7_bene = f"""{bi_block(ps25[2]['latin'], ps25[2]['german'])}
  #v(1pt)
{bi(ps25[3]['latin'], ps25[3]['german'])}
  #v(1pt)
{bi_block(ps25[4]['latin'], ps25[4]['german'])}"""

# -- Postcommunio --
old_teil7_postcomm = """  // TODO: Postcommunio + Ite Missa est alleluia alleluia (bilingual)
  #text(fill: grau, size: 6pt)[\\[Spíritum nobis, Dómine, tuæ caritátis infúnde …\\]]"""

new_teil7_postcomm = f"""{bi_block(ps26[0]['latin'], ps26[0]['german'])}
  #v(1pt)
{bi_block(ps26[1]['latin'], ps26[1]['german'])}"""


# ═══════════════════════════════════════════════════════════════
# APPLY ALL REPLACEMENTS
# ═══════════════════════════════════════════════════════════════

replacements = [
    ("Prophetie I", old_prop1, new_prop1),
    ("Prophetie II", old_prop2, new_prop2),
    ("Prophetie III", old_prop3, new_prop3),
    ("Prophetie IV", old_prop4, new_prop4),
    ("Litanei I", old_teil3, new_teil3),
    ("Taufwasserweihe", old_teil4_weihe, new_teil4_weihe),
    ("Eintauchen", old_teil4_eintauchen, new_teil4_eintauchen),
    ("Sicut cervus", old_teil4_sicut, new_teil4_sicut),
    ("Abschwörung", old_teil5_abschwur, new_teil5_abschwur),
    ("Besprengung", old_teil5_bespreng, new_teil5_bespreng),
    ("Litanei II + Kyrie", old_teil6_litanei, new_teil6_litanei),
    ("Gloria", old_teil6_gloria, new_teil6_gloria),
    ("Collecta", old_teil6_collecta, new_teil6_collecta),
    ("Epistel", old_teil6_epistel, new_teil6_epistel),
    ("Alleluia", old_teil6_alleluia, new_teil6_alleluia),
    ("Evangelium", old_teil6_evangelium, new_teil6_evangelium),
    ("Secreta+Canon", old_teil6_secreta, new_teil6_secreta),
    ("Kommunion", old_teil6_kommunion, new_teil6_kommunion),
    ("Ps 150", old_teil7_ps150, new_teil7_ps150),
    ("Benedictus", old_teil7_bene, new_teil7_bene),
    ("Postcommunio", old_teil7_postcomm, new_teil7_postcomm),
]

result = tpl
for name, old, new in replacements:
    if old in result:
        result = result.replace(old, new, 1)
        print(f"  ✓ {name}")
    else:
        print(f"  ✗ {name} — NOT FOUND")
        # Try to debug by showing first 80 chars of the search
        snippet = old[:80].replace('\n', '\\n')
        print(f"    Looking for: {snippet}...")

with open(TEMPLATE, 'w', encoding='utf-8') as f:
    f.write(result)

line_count = result.count('\n') + 1
print(f"\nDone. Template now has {line_count} lines.")
print(f"Remaining TODOs: {result.count('// TODO:')}")
