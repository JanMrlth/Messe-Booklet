// ═══════════════════════════════════════════════════════════════
// Messe-Booklet: Vigilia Paschalis — 4. April 2026
// Format: A5, ~20 Seiten, Klammerheftung, Latein/Deutsch
// Schrift: Ubuntu Sans
// 7 Teile der Osternacht durch farbige Seitenstreifen:
//   Gold:       Lucernarium (Lichtfeier)
//   Dunkelblau: Prophetien (Wortgottesdienst)
//   Grau:       Allerheiligenlitanei I
//   Blaugrün:   Taufwasserweihe
//   Silbergrau: Taufversprechen-Erneuerung
//   Burgunder:  Ostermesse
//   Gold:       Laudes (= Lucernarium, rahmt die Nacht ein)
// ═══════════════════════════════════════════════════════════════

#let strich-state = state("strich", none)

#set page(
  paper: "a5",
  binding: left,
  margin: (top: 16mm, bottom: 14mm, inside: 16mm, outside: 11mm),
  numbering: none,
  foreground: context {
    let s = strich-state.get()
    if s != none {
      let aussen = calc.odd(here().page())
      if aussen {
        place(right + top,
          line(start: (0pt, 0pt), end: (0pt, 180mm), stroke: s))
      } else {
        place(left + top,
          line(start: (0pt, 0pt), end: (0pt, 180mm), stroke: s))
      }
    }
  },
)

#set text(
  font: "Ubuntu Sans",
  size: 7.5pt,
  lang: "de",
  hyphenate: true,
)

#set par(
  justify: true,
  leading: 0.5em,
)

// ══════════════════════════════════════
// Farben — 7 liturgische Teile
// ══════════════════════════════════════

#let licht-farbe = rgb("#D4A017")      // Gold/Bernstein — Lucernarium + Laudes
#let prophetien-farbe = rgb("#1B4F72") // Dunkelblau — Prophetien
#let litanei-farbe = rgb("#707070")    // Grau — Allerheiligenlitanei I
#let taufe-farbe = rgb("#1A8476")      // Blaugrün — Taufwasserweihe
#let versprechen-farbe = rgb("#606060")// Silbergrau — Taufversprechen
#let messe-farbe = rgb("#922B21")      // Burgunder — Ostermesse
// Laudes verwendet licht-farbe (Gold) — rahmt die Nacht ein

#let grau = rgb("#3D3D3D")
#let hellgrau = rgb("#F0F0F0")

// ══════════════════════════════════════
// Liturgische Symbole
// ══════════════════════════════════════

#let dreikreuz = box(
  inset: (x: 1pt),
  baseline: 3pt,
  stack(
    dir: ttb,
    spacing: -1pt,
    text(size: 5pt, fill: grau)[✛],
    text(size: 5pt, fill: grau)[✛],
    text(size: 5pt, fill: grau)[✛],
  ),
)
#let kreuz = text(size: 7pt, fill: grau)[✛]

#let verneigung = box(
  inset: (x: 1.5pt, y: 0pt),
  baseline: 1pt,
  text(size: 7pt, fill: grau)[⌒],
)

#let fa-icon(code) = text(font: "Font Awesome 6 Free Solid", code)

#let kniebeuge = box(
  inset: (x: 1pt, y: 0pt),
  baseline: 1pt,
  text(size: 7pt, fill: grau)[#fa-icon("\u{f683}")],
)

#let stehen = box(
  inset: (x: 1pt, y: 0pt),
  baseline: 1pt,
  text(size: 7pt, fill: grau)[#fa-icon("\u{f183}")],
)

#let lateinkreuz(size: 40pt, farbe: rgb("#5B2C6F")) = {
  let w = size * 0.6
  let h = size
  let t = 2pt
  let qy = h * 0.3
  box(width: w, height: h)[
    #place(left, dx: w / 2 - t / 2,
      rect(width: t, height: h, fill: farbe))
    #place(left, dy: qy,
      rect(width: w, height: t, fill: farbe))
  ]
}

// ══════════════════════════════════════
// Farbige Seitenstreifen — S/W-unterscheidbar
// ══════════════════════════════════════

#let licht-strich = stroke(paint: licht-farbe, thickness: 4pt, dash: (4pt, 1.5pt, 1.5pt, 1.5pt))        // ·:·:· eng getrippt
#let prophetien-strich = stroke(paint: prophetien-farbe, thickness: 4pt, dash: (8pt, 3pt))               // ── ── lang gestrichelt
#let litanei-strich = stroke(paint: litanei-farbe, thickness: 4pt)                                        // ━━━ durchgezogen
#let taufe-strich = stroke(paint: taufe-farbe, thickness: 4pt, dash: (6pt, 2pt))                         // ─ ─ kurz gestrichelt
#let versprechen-strich = stroke(paint: versprechen-farbe, thickness: 4pt, dash: (3pt, 3pt))              // ─·─ gleichmäßig
#let messe-strich = stroke(paint: messe-farbe, thickness: 4pt, dash: (2pt, 2pt))                         // ·· ·· gepunktet
// Laudes verwendet licht-strich

// ══════════════════════════════════════
// Hilfsfunktionen
// ══════════════════════════════════════

#let abschnitt(strich, body) = {
  strich-state.update(strich)
  body
}

#let rubrik(body) = {
  text(size: 6pt, fill: grau, style: "italic")[#body]
}

#let section-title(titel, farbe: grau) = {
  v(4pt)
  block(
    width: 100%,
    inset: (x: 0pt, y: 2pt),
    stroke: (bottom: 0.4pt + farbe),
    sticky: true,
  )[
    #text(size: 8pt, weight: "bold", fill: farbe, tracking: 0.5pt)[#upper(titel)]
  ]
  v(2pt)
}

#let teil-label(name, farbe) = {
  strich-state.update(none)
  v(2pt)
  block(
    width: 100%,
    inset: (x: 4pt, y: 2pt),
    fill: farbe,
    radius: 1pt,
  )[
    #text(size: 5.5pt, fill: white, weight: "bold", tracking: 1pt)[#upper(name)]
  ]
  v(2pt)
}

#let bilingue(la, de) = {
  grid(
    columns: (1fr, 1fr),
    column-gutter: 7pt,
    text(size: 7pt, style: "italic", lang: "la")[#la],
    text(size: 7pt, lang: "de")[#de],
  )
}

#let referenz(body) = {
  text(size: 6pt, fill: grau, weight: "bold")[#body]
}

// ═══════════════════════════════════════════════════════════════
// SEITE 1 — DECKBLATT
// ═══════════════════════════════════════════════════════════════

#page()[
  #v(1fr)

  #align(center)[
    #lateinkreuz(size: 40pt, farbe: licht-farbe)

    #v(10pt)

    #text(size: 6.5pt, fill: grau, tracking: 1.5pt, weight: "bold")[
      #upper[Die Feier der Osternacht]
    ]

    #v(3pt)
    #line(length: 30%, stroke: 0.3pt + licht-farbe)
    #v(8pt)

    #text(size: 15pt, fill: licht-farbe, weight: "bold", tracking: 0.3pt)[
      Vigilia Paschalis
    ]

    #v(3pt)

    #text(size: 9.5pt, fill: grau)[
      Sabbato Sancto — Karsamstag
    ]

    #v(14pt)

    #block(
      width: 70%,
      inset: 8pt,
      radius: 2pt,
      fill: rgb("#FDF2D0").lighten(40%),
    )[
      #align(center)[
        #text(size: 6.5pt, fill: licht-farbe.darken(20%))[
          Ordo Hebdomadae Sanctae instauratus (1955) \
          Feier nach Einbruch der Dunkelheit \
          Liturgische Farbe: #strong[Violett] → #strong[Weiß]
        ]
      ]
    ]

    #v(16pt)

    #text(size: 9pt, weight: "bold")[4. April 2026]

    #v(3pt)

    #text(size: 6.5pt, fill: grau)[
      Außerordentliche Form des Römischen Ritus \
      Missale Romanum 1962
    ]

    #v(16pt)

    // Legende — 7 Teile der Osternacht
    #block(width: 80%)[
      #set text(size: 5.5pt, fill: grau)
      #grid(
        columns: (auto, 1fr),
        column-gutter: 6pt,
        row-gutter: 3pt,
        rect(width: 10pt, height: 6pt, fill: licht-farbe, radius: 1pt),
        [Lucernarium — Lichtfeier],
        rect(width: 10pt, height: 6pt, fill: prophetien-farbe, radius: 1pt),
        [Prophetien — Wortgottesdienst],
        rect(width: 10pt, height: 6pt, fill: litanei-farbe, radius: 1pt),
        [Allerheiligenlitanei],
        rect(width: 10pt, height: 6pt, fill: taufe-farbe, radius: 1pt),
        [Taufwasserweihe],
        rect(width: 10pt, height: 6pt, fill: versprechen-farbe, radius: 1pt),
        [Erneuerung der Taufversprechen],
        rect(width: 10pt, height: 6pt, fill: messe-farbe, radius: 1pt),
        [Missa Sollemnis Vigiliæ Paschalis],
        rect(width: 10pt, height: 6pt, fill: licht-farbe, radius: 1pt),
        [Laudes — Morgengebet der Auferstehung],
      )
    ]

    #v(10pt)

    // Symbollegende
    #block(width: 65%)[
      #set text(size: 5pt, fill: grau)
      #grid(
        columns: (auto, 1fr, auto, 1fr),
        column-gutter: 5pt,
        row-gutter: 2pt,
        kreuz, [Kreuzzeichen],
        dreikreuz, [3 Kreuze (Stirn, Mund, Brust)],
        verneigung, [Verneigung (Haupt)],
        kniebeuge, [Kniebeuge / Knien],
        stehen, [Stehen],
        [],[]
      )
    ]
  ]

  #v(1fr)

  #align(center)[
    #text(size: 5pt, fill: grau)[
      Latein und Deutsch · Ordo Hebdomadae Sanctae instauratus
    ]
  ]
]

// ═══════════════════════════════════════════════════════════════
// SEITE 2 — Innentitel / Meditation
// ═══════════════════════════════════════════════════════════════

#page()[
  #v(1fr)

  #align(center)[
    #block(width: 80%)[
      #set text(size: 8.5pt, style: "italic", fill: grau.lighten(15%), lang: "la")
      #set par(justify: false, leading: 0.7em)
      O vere beáta nox, \
      quæ exspoliávit Ægýptios, \
      ditávit Hebrǽos! \
      Nox, in qua terrénis cæléstia, \
      humánis divína iungúntur!
    ]

    #v(12pt)
    #line(length: 20%, stroke: 0.3pt + licht-farbe)
    #v(12pt)

    #block(width: 80%)[
      #set text(size: 7.5pt, fill: grau.lighten(10%))
      #set par(justify: false, leading: 0.65em)
      O wahrhaft selige Nacht, \
      die Ägypten beraubte, \
      die Hebräer bereicherte! \
      Nacht, in der Himmlisches \
      mit Irdischem, \
      Göttliches mit Menschlichem \
      verbunden wird!
    ]

    #v(16pt)

    #text(size: 5.5pt, fill: grau, tracking: 0.5pt)[
      — aus dem Exsultet —
    ]
  ]

  #v(1fr)
]

// ═══════════════════════════════════════════════════════════════
// SEITE 3 — Hinweise zur Mitfeier
// ═══════════════════════════════════════════════════════════════

#page()[
  #v(8pt)
  #align(center)[
    #text(size: 7pt, weight: "bold", fill: grau, tracking: 0.5pt)[
      #upper[Hinweise zur Mitfeier]
    ]
    #v(1pt)
    #line(length: 40%, stroke: 0.3pt + grau)
  ]
  #v(8pt)

  #set text(size: 6.5pt, fill: grau)
  #set par(leading: 0.55em)

  Die Osternacht ist die „Mutter aller Vigilien" _(Augustinus)_ und der Höhepunkt des Kirchenjahres. Die Feier nach dem _Ordo Hebdomadæ Sanctæ instauratus_ (1955) gliedert sich in sieben Teile, die durch farbige Seitenstreifen kenntlich gemacht sind.

  #v(6pt)

  #block(width: 100%)[
    #set text(size: 6pt)
    #grid(
      columns: (auto, 1fr),
      column-gutter: 6pt,
      row-gutter: 4pt,

      strong[Kerzen], [Zu Beginn erhält jeder eine Kerze. Sie wird bei der Prozession am Lumen Christi entzündet und bei den Taufversprechen (Teil V) erneut angezündet.],

      strong[Antworten], [Die Antworten der Gemeinde sind in diesem Heft abgedruckt. Bei den Litaneien wiederholt die Gemeinde die Anrufungen der Kantoren.],

      strong[Haltungen], [Die Symbole am rechten Rand zeigen die Körperhaltung an:],
    )
  ]

  #v(4pt)

  #align(center)[
    #block(width: 60%)[
      #set text(size: 5.5pt, fill: grau)
      #grid(
        columns: (auto, 1fr, auto, 1fr),
        column-gutter: 5pt,
        row-gutter: 3pt,
        stehen, [Stehen],
        kniebeuge, [Knien],
        kreuz, [Kreuzzeichen],
        verneigung, [Verneigung],
      )
    ]
  ]

  #v(6pt)

  #block(width: 100%)[
    #set text(size: 6pt)
    #grid(
      columns: (auto, 1fr),
      column-gutter: 6pt,
      row-gutter: 4pt,

      strong[Wechsel], [Nach den Prophetien (Teil II) wechselt der Zelebrant von violetten auf weiße Paramente — die Fastenzeit ist zu Ende.],

      strong[Gloria], [Beim Gloria (Teil VI) läuten zum ersten Mal seit dem Gründonnerstag die Glocken, die verhüllten Bilder und Kreuze werden enthüllt.],

      strong[Alleluia], [Der Zelebrant singt dreimal _Allelúia_ in aufsteigendem Ton — zum ersten Mal seit Septuagesima.],

      strong[Communion], [Kein Agnus Dei. Von _Pater noster_ direkt zur Brechung und Kommunion.],
    )
  ]

  #v(1fr)

  #align(center)[
    #text(size: 5pt, fill: grau, style: "italic")[
      Die Texte folgen dem Missale Romanum (1962).
    ]
  ]
]

// Seitennummerierung ab Seite 4
#set page(numbering: "— 1 —")
#counter(page).update(4)

// ═══════════════════════════════════════════════════════════════
// TEIL 1 — LUCERNARIUM (Lichtfeier)
// ═══════════════════════════════════════════════════════════════

#teil-label("I · Lucernarium — Lichtfeier", licht-farbe)

#abschnitt(licht-strich)[
  #section-title("Benedictio ignis — Feuerweihe", farbe: licht-farbe)
  #rubrik[Alle Lichter in der Kirche sind gelöscht. Vor der Kirche wird aus dem Stein neues Feuer geschlagen. Der Zelebrant in violettem Pluviale segnet das Feuer. #stehen]
  #v(2pt)
  #bilingue(
    [℣. Dóminus vobíscum. \
     ℟. Et cum spíritu tuo.],
    [℣. Der Herr sei mit euch. \
     ℟. Und mit deinem Geiste.],
  )
  #v(2pt)
  #bilingue(
    [Orémus.

Deus, qui per Fílium tuum, angulárem scílicet lápidem, claritátis tuæ ignem fidélibus contulísti: prodúctum e sílice, nostris profutúrum úsibus, novum hunc ignem sanctífica: et concéde nobis, ita per hæc festa paschália cœléstibus desidériis inflammári; ut ad perpétuæ claritátis, puris méntibus, valeámus festa pertíngere. Per eúndem Christum Dóminum nostrum.

℟. Amen.],
    [Lasset uns beten.

O Gott, der du durch deinen Sohn, den wahren Eckstein, den Gläubigen das Feuer deiner Klarheit verliehen hast: heilige dieses neue, aus dem Stein geschlagene Feuer, das unserem Gebrauche dienen soll, und gewähre uns, durch diese österlichen Feste so von himmlischem Verlangen entflammt zu werden, daß wir reinen Herzens zum Feste der ewigen Klarheit gelangen mögen. Durch denselben Christum, unsern Herrn.

℟. Amen.],
  )
  #v(2pt)
  #rubrik[Der Zelebrant besprengt das Feuer dreimal mit Weihwasser und beräuchert es.]
]

#v(4pt)

#abschnitt(licht-strich)[
  #section-title("Osterkerze — Bereitung", farbe: licht-farbe)
  #rubrik[Der Zelebrant ritzt ein Kreuz in die Osterkerze. Dabei spricht er: #stehen]
  #v(2pt)
  #block(breakable: false)[
    #bilingue(
      [Christus heri et hódie, #rubrik[\— senkrechter Balken] \
Princípium et Finis, #rubrik[\— Querbalken] \
Alpha #rubrik[\— darüber] \
et Omega; #rubrik[\— darunter] \
Ipsíus sunt témpora #rubrik[\— 2] \
et sǽcula; #rubrik[\— 0] \
Ipsi glória et impérium #rubrik[\— 2] \
per univérsa æternitátis sǽcula. Amen. #rubrik[\— 6]],
      [Christus gestern und heute, \
Anfang und Ende, \
Alpha \
und Omega; \
sein sind die Zeiten \
und die Ewigkeiten; \
ihm sei Ruhm und Herrschaft \
durch alle Ewigkeiten der Ewigkeit. Amen.],
    )
  ]
  #v(3pt)
  #rubrik[Er setzt fünf Weihrauchkörner in Kreuzform in die Kerze ein:]
  #v(2pt)
  #block(breakable: false)[
    #bilingue(
      [Per sua sancta vúlnera gloriósa custódiat et consérvet nos Christus Dóminus. Amen.],
      [Durch seine heiligen glorreichen Wunden behüte und bewahre uns Christus, der Herr. Amen.],
    )
  ]
  #v(3pt)
  #rubrik[Der Zelebrant entzündet die Osterkerze am neuen Feuer und spricht:]
  #v(2pt)
  #bilingue(
    [Lumen Christi glorióse resurgéntis díssipet ténebras cordis et mentis.],
    [Das Licht des glorreich auferstandenen Christus vertreibe die Finsternis des Herzens und des Geistes.],
  )
  #v(3pt)
  #bilingue(
    [℣. Dóminus vobíscum. \
     ℟. Et cum spíritu tuo.],
    [℣. Der Herr sei mit euch. \
     ℟. Und mit deinem Geiste.],
  )
  #v(2pt)
  #bilingue(
    [Orémus.

Véniat, quǽsumus, omnípotens Deus, super hoc incénsum céreum larga tuæ benedictiónis infúsio: et hunc noctúrnum splendórem invisíbilis regenerátor inténde; ut non solum sacrifícium, quod hac nocte litátum est, arcána lúminis tui admixtióne refúlgeat; sed in quocúmque loco ex huius sanctificatiónis mystério áliquid fúerit deportátum, expúlsa diabólicæ fraudis nequítia, virtus tuæ maiestátis assístat. Per Christum Dóminum nostrum.

℟. Amen.],
    [Lasset uns beten.

Komme, so bitten wir, allmächtiger Gott, über dieses entzündete Licht die reiche Ausgießung deines Segens herab; und du, unsichtbarer Erneuerer, blicke auf diesen nächtlichen Glanz: daß nicht nur das Opfer, das in dieser Nacht dargebracht wird, durch die geheimnisvolle Beimischung deines Lichtes erstrahle, sondern an jedem Ort, wohin etwas von diesem geheiligten Segen getragen wird, die Bosheit des teuflischen Truges weiche und die Kraft deiner Majestät beistehe. Durch Christum, unsern Herrn.

℟. Amen.],
  )
]

#v(4pt)

#abschnitt(licht-strich)[
  #section-title("Prozession — Lumen Christi", farbe: licht-farbe)
  #rubrik[Einzug in die dunkle Kirche. Dreimal erhebt der Diakon die Osterkerze und singt „Lumen Christi" in aufsteigendem Ton. Bei jedem Ruf knien alle nieder.]
  #v(3pt)
  #rubrik[1. An der Kirchentür — der Zelebrant entzündet seine Kerze: #kniebeuge]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [℣. Lumen Christi. \
       ℟. Deo grátias.],
      [℣. Licht Christi. \
       ℟. Dank sei Gott.],
    )
  ]
  #v(3pt)
  #rubrik[2. In der Mitte der Kirche — die Kerzen des Klerus werden entzündet: #kniebeuge]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [℣. Lumen Christi. #rubrik[(höher)] \
       ℟. Deo grátias.],
      [℣. Licht Christi. \
       ℟. Dank sei Gott.],
    )
  ]
  #v(3pt)
  #rubrik[3. Vor dem Altar — alle Kerzen des Volkes und der Kirche werden entzündet: #kniebeuge]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [℣. Lumen Christi. #rubrik[(noch höher)] \
       ℟. Deo grátias.],
      [℣. Licht Christi. \
       ℟. Dank sei Gott.],
    )
  ]
]

#v(4pt)

#abschnitt(licht-strich)[
  #section-title("Exsultet — Praeconium Paschale", farbe: licht-farbe)
  #rubrik[Der Diakon beräuchert das Buch und die Osterkerze und singt das große Osterlob. Alle stehen mit brennenden Kerzen. #stehen]
  #v(3pt)
  #rubrik[Der Diakon bittet um den Segen:]
  #bilingue(
    [Iube, domne, benedícere.],
    [Gebiete, Herr, zu segnen.],
  )
  #v(2pt)
  #rubrik[Der Zelebrant:]
  #bilingue(
    [Dóminus sit in corde tuo, et in lábiis tuis, ut digne et competénter annúnties suum paschále præcónium: in nómine Patris, et Fílii, et Spíritus Sancti. — ℟. Amen.],
    [Der Herr sei in deinem Herzen und auf deinen Lippen, damit du würdig und recht sein österliches Lob verkündest: im Namen des Vaters und des Sohnes und des Heiligen Geistes. — ℟. Amen.],
  )
  #v(4pt)

  #bilingue(
    [Exsúltet iam Angélica turba cœlórum: exsúltent divína mystéria: et pro tanti Regis victória tuba ínsonet salutáris. Gáudeat et tellus tantis irradiáta fulgóribus: et ætérni Regis splendóre illustráta, totíus orbis se séntiat amisísse calíginem. Lætétur et mater Ecclésia, tanti lúminis adornáta fulgóribus: et magnis populórum vócibus hæc aula resúltet.],
    [Es juble die engelische Schar des Himmels, es frohlocken die göttlichen Geheimnisse, und ob des Sieges eines so großen Königs ertöne die Posaune des Heiles. Es freue sich auch die Erde, von so mächtigen Strahlen überflutet, und vom Glanze des ewigen Königs erleuchtet, erkenne sie, daß die Finsternis des ganzen Erdkreises gewichen ist. Es freue sich auch die Mutter Kirche, geschmückt vom Glanze eines so großen Lichtes, und von den mächtigen Stimmen der Völker erdröhne dieses Gotteshaus.],
  )
  #v(3pt)
  #bilingue(
    [Quaprópter astántes vos, fratres caríssimi, ad tam miram huius sancti lúminis claritátem, una mecum, quæso, Dei omnipoténtis misericórdiam invocáte. Ut, qui me non meis méritis intra Levitárum númerum dignátus est aggregáre: lúminis sui claritátem infúndens, Cérei huius laudem implére perfíciat. Per Dóminum nostrum Iesum Christum, Fílium suum: qui cum eo vivit et regnat in unitáte Spíritus Sancti Deus: per ómnia sǽcula sæculórum. — ℟. Amen.],
    [Deshalb bitte ich euch, geliebte Brüder, die ihr vor dem so wunderbaren Glanze dieses heiligen Lichtes stehet, mit mir zusammen die Barmherzigkeit des allmächtigen Gottes anzurufen. Daß er, der mich nicht um meiner Verdienste willen in die Zahl der Leviten aufzunehmen gewürdigt hat, mir die Klarheit seines Lichtes eingießend, das Lob dieser Kerze zu vollenden verleihe. Durch unsern Herrn Iesum Christum, seinen Sohn, der mit ihm lebt und herrscht in der Einheit des Heiligen Geistes, Gott von Ewigkeit zu Ewigkeit. — ℟. Amen.],
  )
  #v(3pt)
  #block(breakable: false)[
    #bilingue(
      [℣. Dóminus vobíscum. — ℟. Et cum spíritu tuo. \
       ℣. Sursum corda. — ℟. Habémus ad Dóminum. \
       ℣. Grátias agámus Dómino Deo nostro. — ℟. Dignum et iustum est.],
      [℣. Der Herr sei mit euch. — ℟. Und mit deinem Geiste. \
       ℣. Erhebet die Herzen. — ℟. Wir haben sie beim Herrn. \
       ℣. Lasset uns danken dem Herrn, unserm Gotte. — ℟. Das ist würdig und recht.],
    )
  ]
  #v(3pt)
  #bilingue(
    [Vere dignum et iustum est, invísibilem Deum Patrem omnipoténtem Filiúmque eius unigénitum, Dóminum nostrum Iesum Christum, toto cordis ac mentis afféctu et vocis ministério personáre. Qui pro nobis ætérno Patri Adæ débitum solvit: et véteris piáculi cautiónem pio cruóre detérsit.],
    [Es ist wahrhaft würdig und recht, den unsichtbaren Gott, den allmächtigen Vater, und seinen eingeborenen Sohn, unsern Herrn Iesum Christum, mit vollem Herzen und Gemüt und mit dem Dienste der Stimme zu preisen. Der für uns dem ewigen Vater Adams Schuld beglichen und die Handschrift der alten Sünde mit seinem frommen Blute getilgt hat.],
  )
  #v(2pt)
  #bilingue(
    [Hæc sunt enim festa paschália, in quibus verus ille Agnus occíditur, cuius sánguine postes fidélium consecrántur.],
    [Denn das sind die österlichen Feste, an denen jenes wahre Lamm geschlachtet wird, durch dessen Blut die Türpfosten der Gläubigen geheiligt werden.],
  )
  #v(2pt)
  #bilingue(
    [Hæc nox est, in qua primum patres nostros, fílios Israël edúctos de Ægýpto, Mare Rubrum sicco vestígio transíre fecísti. Hæc ígitur nox est, quæ peccatórum ténebras colúmnæ illuminatióne purgávit.],
    [Dies ist die Nacht, in der du einst unsere Väter, die Kinder Israels, aus Ägypten geführt und trockenen Fußes durch das Rote Meer hast ziehen lassen. Dies also ist die Nacht, welche die Finsternis der Sünden durch die Lichtsäule zerstreut hat.],
  )
  #v(2pt)
  #bilingue(
    [Hæc nox est, quæ hódie per univérsum mundum in Christo credéntes, a vítiis sǽculi et calígine peccatórum segregátos, reddit grátiæ, sóciat sanctitáti. Hæc nox est, in qua, destrúctis vínculis mortis, Christus ab ínferis victor ascéndit.],
    [Dies ist die Nacht, die heute in der ganzen Welt alle, die an Christus glauben, von den Lastern der Welt und der Finsternis der Sünden geschieden, der Gnade zurückgibt und der Heiligkeit zugesellt. Dies ist die Nacht, in der Christus die Bande des Todes zerriß und als Sieger aus der Unterwelt emporstieg.],
  )
  #v(2pt)
  #bilingue(
    [Nihil enim nobis nasci prófuit, nisi rédimi profuísset. O mira circa nos tuæ pietátis dignátio! O inæstimábilis diléctio caritátis: ut servum redímeres, Fílium tradidísti!],
    [Denn nichts hätte es uns genützt, geboren zu werden, wenn er uns nicht erlöst hätte. O wunderbare Herablassung deiner Güte gegen uns! O unschätzbare Erweisung der Liebe: um den Knecht zu erlösen, hast du den Sohn dahingegeben!],
  )
  #v(2pt)
  #bilingue(
    [O certe necessárium Adæ peccátum, quod Christi morte delétum est! O felix culpa, quæ talem ac tantum méruit habére Redemptórem!],
    [O wahrlich notwendige Sünde Adams, die durch Christi Tod getilgt ward! O glückliche Schuld, die einen so großen und herrlichen Erlöser zu haben verdiente!],
  )
  #v(2pt)
  #bilingue(
    [O vere beáta nox, quæ sola méruit scire tempus et horam, in qua Christus ab ínferis resurréxit! Hæc nox est, de qua scriptum est: _Et nox sicut dies illuminábitur: et nox illuminátio mea in delíciis meis._],
    [O wahrhaft selige Nacht, die allein es verdiente, die Zeit und Stunde zu wissen, da Christus von den Toten erstand! Das ist die Nacht, von der geschrieben steht: _Und die Nacht wird hell sein wie der Tag, und die Nacht ist mein Licht in meiner Wonne._],
  )
  #v(2pt)
  #bilingue(
    [Huius ígitur sanctificátio noctis fugat scélera, culpas lavat: et reddit innocéntiam lapsis et mæstis lætítiam. Fugat ódia, concórdiam parat et curvat impéria.],
    [Die Heiligung dieser Nacht also verscheucht die Frevel, wäscht die Sünden ab und gibt den Gefallenen die Unschuld und den Traurigen die Freude zurück. Sie vertreibt den Haß, bereitet die Eintracht und beugt die Gewalten.],
  )
  #v(2pt)
  #bilingue(
    [In huius ígitur noctis grátia, súscipe, sancte Pater, incénsi huius sacrifícium vespertínum: quod tibi in hac Cérei oblatióne solémni, per ministrórum manus de opéribus apum, sacrosáncta reddit Ecclésia. Sed iam colúmnæ huius præcónia nóvimus, quam in honórem Dei rútilans ignis accéndit. Qui licet sit divísus in partes, mutuáti tamen lúminis detriménta non novit. Alitur enim liquántibus ceris, quas in substántiam pretiósæ huius lámpadis apis mater edúxit.],
    [Nimm daher an, heiliger Vater, in der Gnade dieser Nacht das abendliche Opfer dieses Weihrauchs, das dir in der feierlichen Darbringung dieser Kerze durch die Hände deiner Diener aus dem Werke der Bienen die heilige Kirche zurückerstattet. Doch nun laß uns den Lobpreis dieser Lichtsäule hören, die zu Gottes Ehre das leuchtende Feuer entzündet hat. Obschon es sich in Teile verbreitet, erleidet es doch keine Einbuße durch das mitgeteilte Licht. Denn es nährt sich von den schmelzenden Wachsen, die die Mutterbiene zum Stoff dieser kostbaren Leuchte gebildet hat.],
  )
  #v(2pt)
  #bilingue(
    [O vere beáta nox, quæ exspoliávit Ægýptios, ditávit Hebrǽos! Nox, in qua terrénis cæléstia, humánis divína iungúntur.],
    [O wahrhaft selige Nacht, die die Ägypter beraubt und die Hebräer bereichert hat! Nacht, in der Irdisches mit Himmlischem, Menschliches mit Göttlichem verbunden wird.],
  )
  #v(2pt)
  #bilingue(
    [Orámus ergo te, Dómine: ut Céreus iste in honórem tui nóminis consecrátus, ad noctis huius calíginem destruéndam, indefíciens persevéret. Et in odórem suavitátis accéptus, supérnis lumináribus misceátur. Flammas eius lúcifer matutínus invéniat. Ille, inquam, lúcifer, qui nescit occásum. Ille, qui regréssus ab ínferis, humáno géneri serénus illúxit.],
    [Wir bitten dich daher, o Herr: daß dieses zu Ehren deines Namens geweihte Licht zur Vertreibung der Finsternis dieser Nacht unversehrt fortbrenne. Und als lieblicher Wohlgeruch aufgenommen, mische es sich den himmlischen Lichtern bei. Sein Leuchten finde der Morgenstern: jener Morgenstern, sage ich, der keinen Untergang kennt; jener, der, aus der Unterwelt zurückgekehrt, dem Menschengeschlechte heiter aufgeleuchtet hat.],
  )
  #v(2pt)
  #bilingue(
    [Precámur ergo te, Dómine: ut nos fámulos tuos, omnémque clerum, et devotíssimum pópulum: una cum beatíssimo Papa nostro _N._, et Antístite nostro _N._, quiéte témporum concéssa, in his paschálibus gáudiis, assídua protectióne régere, gubernáre et conserváre dignéris. Réspice étiam ad eos, qui nos in potestáte regunt, et, ineffábili pietátis et misericórdiæ tuæ múnere, dírige cogitatiónes eórum ad iustítiam et pacem, ut de terréna operositáte ad cæléstem pátriam pervéniant cum omni pópulo tuo. Per eúndem Dóminum nostrum Iesum Christum, Fílium tuum: qui tecum vivit et regnat in unitáte Spíritus Sancti Deus: per ómnia sǽcula sæculórum.

℟. Amen.],
    [Wir bitten dich daher, o Herr: daß du uns, deine Diener, und den gesamten Klerus und das fromme Volk, zusammen mit unserm heiligsten Papst _N._ und unserm Bischof _N._, in der Ruhe der Zeiten, in diesen österlichen Freuden durch beständigen Schutz zu leiten, zu lenken und zu bewahren dich würdigest. Blicke auch auf jene, die über uns in weltlicher Gewalt herrschen, und lenke durch die unaussprechliche Gabe deiner Güte und Barmherzigkeit ihre Gedanken auf Gerechtigkeit und Frieden, daß sie aus dem irdischen Mühen zum himmlischen Vaterland gelangen mit deinem ganzen Volke. Durch denselben, unsern Herrn Iesum Christum, deinen Sohn, der mit dir lebt und herrscht in der Einheit des Heiligen Geistes, Gott von Ewigkeit zu Ewigkeit.

℟. Amen.],
  )
]

// ═══════════════════════════════════════════════════════════════
// TEIL 2 — PROPHETIEN (Wortgottesdienst)
// ═══════════════════════════════════════════════════════════════

#teil-label("II · Prophetien — Wortgottesdienst", prophetien-farbe)

#abschnitt(prophetien-strich)[
  #section-title("Prophetie I — Schöpfungsbericht", farbe: prophetien-farbe)
  #referenz[Gen 1,1–2,2]
  #v(2pt)
  #bilingue(
    [In principio creavit Deus caelum et terram. Terra autem erat inanis et vacua, et tenebrae erant super faciem abyssi: et Spiritus Dei ferebatur super aquas. Dixitque Deus: Fiat lux. Et facta est lux. Et vidit Deus lucem quod esset bona: et divisit lucem a tenebris. Appellavitque lucem Diem, et tenebras Noctem: factumque est vespere et name, dies unus. \
Dixit quoque Deus: Fiat firmamentum in medio aquarum: et dividat aquas ab aquis. Et fecit Deus firmamentum, divisitque aquas quae erant sub firmamento, ab his quae erant super firmentum. Et factum est ita. Vocavit Deus firmamentum Caelum: et factum est vespere et mane, dies secundus. \
Dixit vero Deus: Congregentur aquae, quae sub caelo sunt, in locum unum: et appareat arida. Et factum est ita. Et vocavit Deus aridam, Terram, congregationisque aquarum appellavit Maria. Et vidit Deus quod esset bonum. Et ait: Germinet terra herbam virentem, et facientem semen, et lignum pomiferum faciens fructum iuxta genus suum, cuius semen in semetipso sit super terram. Et factum est ita. Et protulit terra herbam virentem, et facientem semen iuxta genus suum, lignumque faciens fructum, et habens unumquodque sementem secundum speciem suam. Et vidit Deus quod esset bonum. Et factum est vespere et mane, dies tertius. \
Dixit autem Deus: Fiant luminaria in firmamento caeli, et dividant diem ac noctem, et sint in signa et tempora, et dies et annos: ut luminent terram. Et factum est ita. Fecitque Deus duo luminaria magna: luminaria maius, ut praeesset diei, et luminarie minus, ut praeesset nocti: et stellas. Et posuit eas in firmamento caeli, ut lucerent super terram, et praeessent diei ac nocti, et dividerent lucem ac tenebras. Et vidit Deus quod esset bonum. Et factum est vespere et mane, dies quartus. \
Dixit etiam Deus: Producant aquae reptile animae viventis, et volatile super terram sub firmamento caeli. Creavitque Deus cete grandia, et omnem animam viventem atque motabilem, quam produxerant aquae in species suas, et omne volatile secundum genus suum. Et vidit Deus quod esset bonum. Benedixitque eis, dicens: Crescite, et multiplicamini, et replete aquas maris: avesque multiplicentur super terram. Et factum est vespere et mane, dies quintus. \
Dixit quoque Deus: Producat terra animam viventem in genere suo: iumenta, et reptilia, et bestias terrae secundum species suas. Factumque est ita. Et fecit Deus quod esset bonum, et ait: Faciamus hominem ad imaginem et similitudinem nostram: et praesit piscibus maris, et volatilibus caeli, et bestiis, universaeque terrae, omnique reptili quod movetur in terra. Et creavit Deus hominem ad imaginem suam: ad imaginem Dei creavit illum, masculum et feminam creavit eos. Benedixitque illis Deus, et ait: Crescite et multiplicamini, et replete terram, et subiicite eam, et dominamini piscibus maris, et volatilibus caeli, et universis animantibus, quae moventur super terram. \
Dixitque Deus: Ecce dedi vobis omnem herbam afferentem semen super terram, et universa ligna quae habent in semetipsis sementum generis sui, ut sint vobis in escam: et cunctis animantibus terrae, omnique volucri caeli, et universis, quae moventur in terra, et in quibus est anima vivens, ut habeant ad vescendum. Et factum est ita. \
Viditque Deus cuncta quae fecerat: et erant valde bona. Et factum est vespere et mane, dies sextus. \
Igitur perfecti sunt caeli et terra, et omnis ornatus eorum. Complevitque Deus die septimo opus suum quod fecerat: et requievit die septimo ab universo opere quod patrarat.],
    [Im Anfang schuf Gott Himmel und Erde. Die Erde aber war öde und leer, und Finsternis lag über dem Abgrund, und der GeistGottes schwebte über den Wassern. Und Gott sprach: „Es werde Licht!" Und es ward Licht. Und Gott sah das Licht, daß es gut war, und Er schied das Licht von der Finsternis. Und das Licht nannte Er Tag, die Finsternis aber nannte Er Nacht; und es ward Abend, und es ward Mor­gen: der erste Tag. \
Dann sprach Gott: „Es werde eine Wölbung inmitten der Was­ser, und sie scheide zwischen Wasser und Wasser." Und Gott machte die Wölbung, und Er schied die Wasser unter der Wöl­bung von denen über der Wöl­bung. Und so geschah es. Und die Wölbung nannte Gott Himmel: und es ward Abend, und es ward Morgen: der zweite Tag. \
Dann sprach Gott: „Es fließe das Wasser unter dem Himmel in eines zusammen, und es erscheine das Trockene." Und so geschah es. Und Gott nannte das Trockene Erde; und das gesammelte Wasser nannte Er Meer. Und Gott sah, daß es gut war. Und Er sprach: „Die Erde bringe grünende Pflanzen hervor, die Samen tragen, und Fruchtbäume, die Frucht tragen und ihren Sa­men in sich haben nach ihrer Art." Und so geschah es. Und die Erde brachte grünende Pflanzen hervor, die Samen tragen nach ihrer Art, und Bäume, die Früchte tragen, die ihren Samen in sich haben nach ihrer Art. Und Gott sah, daß es gut war. Und es ward Abend, und es ward Morgen: der dritte Tag. \
Dann sprach Gott: „Es solL Leuchten entstehn an der Wöl bung des Himmels,um zu scheiden den Tag und die Nacht und zu bestimmen die Zeiten und die Tage und Jahre. Sie sollen leuchten an der Wölbung des Himmels und erhellen die Erde." Und so geschah es. Und Gott machte die zwei großen Leuchten, die größere Leuchte, auf daß sie die Herrschaft führe über den Tag, und die kleinere Leuchte, auf daß sie beherrsche die Nacht, und da­zu noch die Sterne. Und Er setzte sie an die Wölbung des Himmels, damit sie leuchten herab auf die Erde und beherrschen den Tag und die Nacht und scheiden das Licht von der Finsternis. Und es ward Abend, und es ward Morgen: der vierte Tag. \
Dann sprach Gott: „Es wimmle das Wasser von lebenden Wesen, und geflügelte Tiere sollen hin­fliegen über die Erde unter der Wölbung des Himmels." Und Gott schuf die großen Wasser­tiere und all die lebenden und sich tummelnden Wesen, von denen die Gewässer wimmeln nach ihrer Art; auch alle geflügel­ten Tiere nach ihrer Art. Und Gott sah, daß es gut war; und Er segnete sie und sprach: „Seid fruchtbar und mehret euch und erfüllet die Wasser des Meeres; und auch die geflügelten Tiere sollen sich mehren auf Erden." Und es ward Abend, und es ward Morgen: der fünfte Tag. \
Dann sprach Gott: „Es bringe die Erde lebende Wesen hervor, ein jedes nach seiner Art: Vieh und kriechendes Getier und Wild des Feldes, ein jedes nach seiner Art." Und so geschah es. Und Gott schuf das Wild des Feldes nach seiner Art und Vieh und alles kriechende Getier der Erde, ein jedes nach seiner Art. Und Gott sah, daß es gut war. Und Er sprach: „Laßt Uns den Menschen machen nach Unserem Bilde und Gleichnis; er gebiete über die Fische des Meeres und über die geflügelten Tiere des Himmels und über die Tiere auf dem Land und über die ganze Erde und über alles kriechende Getier, das sich reget auf Erden." Und Gott schuf den Menschen nach Seinem Bilde; nach dem Bilde Gottes schuf Er ihn, als Mann und Weib schuf Er sie. Und Gott segnete sie und sprach: „Seid fruchtbar und mehret euch und erfüllet die Erde und macht sie euch Untertan; gebietet über die Fische des Meeres und über die geflügelten Tiere des Himmels die sich regen auf Erden." \
Und Gott sprach: „Seht, Ich habe euch zur Nahrung gegeben alle samentragenden Pflanzen auf Erden und alle Bäume, die in sich tragen den Samen nach ihrer Art; Ich habe sie zur Nahrung gegeben auch allen Tieren der Erde und allen geflügelten Tieren des Himmels und allem, was sich reget auf Erden und was in sich hat den Odem des Lebens." Und so geschah es. Und Gott sah alles, was Er gemacht, und es war alle, sehr gut. Und es ward Abend und es ward Morgen: der sechste«. Tag. \
So ward vollendet Himmel und Erde und all ihre Zier. Und Gott vollendete am siebenten Tag Sein Werk, das Er vollbracht und Er ruhte am siebenten Tag von all Seinem Werke, das Er geschaffen.],
  )
  #v(4pt)
  #rubrik[Orémus. — Flectámus génua. — Leváte. #kniebeuge #stehen]
  #block(breakable: false)[
    #bilingue(
      [Deus, qui mirabiliter creasti hominem, et mirabilius redemisti: da nobis, quaesumus, contra oblectamenta peccati, mentis ratione persistere; ut mereamur ad aeterna gaudia pervenire. Per Dominum nostrum Jesum Christum, Filium tuum: Qui tecum vivit et regnat in unitate Spiritus Sancti Deus: per omnia sæcula sæculorum. Amen.],
      [O Gott, wunderbar hast Du den Menschen erschaffen und noch wunderbarer ihn erlöst; wir bitten Dich: laß uns den Lockungen der Sünde widerstehn mit der Kraft des Geistes, damit wir zu den ewigen Freuden gelangen. Durch unsern Herrn Jesus Christus, Deinen Sohn, der mit Dir lebt und herrscht in der Einheit des Heiligen Geistes, Gott von Ewigkeit zu Ewigkeit. Amen.],
    )
  ]
]

#v(4pt)

#abschnitt(prophetien-strich)[
  #section-title("Prophetie II — Durchzug durch das Rote Meer", farbe: prophetien-farbe)
  #referenz[Ex 14,24–15,1]
  #v(2pt)
  #bilingue(
    [In diebus illis: Factum est in vigilia matutina, et ecce respiciens Dominus super castra Aegyptiorum per columnam ignis et nubis, interfecit exercitum eorum: et subvertit rotas curruum, ferebanturque in profundum. Dixerunt ergo Aegyptii: Fugiamus Israelem: Dominus enim pugnat pro eis contra nos. Et ait Dominus ad Moysen: Extende manum tuam super mare, ut revertantur aquae ad Aegyptios super currus et equites eorum. Cumque extendisset Moyses manum contra mare, reversum est primo diluculo ad priorem locum: fugientibusque Aegyptiis occurrerunt aquae, et involvit eos Dominus in mediis fluctibus. Reversaeque sunt aquae, et operuerunt currus et equites cuncti exercitus Pharaonis, qui sequentes ingressi fuerant mare: nec unus quidem superfuit ex eis. Filii autem Israel perrexerunt per medium sicci maris, et aquae eis erant quasi pro muro a dextris et a sinistris: liberavitque Dominus in die illa Israel de manu Aegyptiorum. Et viderunt Aegyptios mortuos super littus maris, et manum magnam. quam exercuerat Dominus contra eos: timuitque populus Dominum, et crediderunt Domino, et Moysi servo eius. Tunc cecinit Moyses, et filii Israel carmen hoc Domino, et dixerunt:],
    [In jenen Tagen schaute der Herr zur Zeit der Morgenwache aus der Säule des Feuers und der Wolke auf das Lager der Ägyp­ter und vernichtete ihr Heer; und von den Wagen ließ Er ab­springen die Räder, und sie fielen zu Boden. Da sprachen die Ägyp­ter: „Lasset uns fliehen vor Is­rael, denn der Herr streitet für sie wider uns." Und es sprach der Herr zu Moses: „Strecke aus dei­ne Hand über das Meer, damit das Wasser über die Ägypter her­einbreche, über ihre Wagen und Reiter." Und Moses streckte seine Hand aus gegen das Meer, und es flutete am frühen Morgen zurück an seinen früheren Ort. Nun wollten die Ägypter fliehen, aber das Wasser kam ihnen entgegen, und der Herr begrub sie mitten im Meere. Und das Wasser flutete zurück und bedeckte die Wagen und Reiter vom ganzen Heere des Pharao, das sie verfolgt hatte und hineingezogen war in das Meer; und nicht einer von ihnen blieb übrig. Die Söhne Israels aber zogen mitten durch das trockene Meeresbett, und das Was­ser stand wie eine Mauer zu ihrer Rechten und Linken. So rettete der Herr an diesem Tage Israel aus der Hand der Ägypter. Und sie sahen tot die Ägypter am Ufer des Meeres, und sie erkann­ten die Hand des Herrn, die sich mächtig erwiesen an ihnen. Und es fürchtete das Volk den Herrn und glaubte an den Herrn und Seinen Diener, den Moses. Und Moses sang mit den Söhnen Is­raels dem Herrn dieses Lied:],
  )
  #v(4pt)
  #section-title("Canticum — Cantémus Dómino", farbe: prophetien-farbe)
  #referenz[Ex 15,1–2]
  #bilingue(
    [Cantemus Domino: gloriose enim honorificatus est: equum et ascensorum proiecit in mare: adiutor, et protector factus est mihi in salutem. V. Hic Deus meus, et honorificabo eum: Deus patris mei, et exaltabo eum. V. Dominus conterens bella: Dominus nomen est illi.],
    [1. Ch Laßt uns singen dem Herrn, denn machtvoll hat Er Sich kund­getan: / Roß und Reiter warf Er ins Meer. 2. Ch Er ist mein Hel­fer geworden zum Heile, / Er ist mein Beschützer. 1 Ch Er ist mein Gott, Ihn will ich preisen;/der Gott meines Vaters, Ihn will ich erheben. 2. Ch Der Herr macht zunichte den Krieg;/Herr ist sein Name.],
  )
  #v(2pt)
  #rubrik[Orémus. — Flectámus génua. — Leváte. #kniebeuge #stehen]
  #block(breakable: false)[
    #bilingue(
      [Deus, cuius antiqua miracula etiam nostris saeculis coruscare sentimus: dum quod uni populo, a persecutione Aegyptiaca liberando, dexterae tuae potentia contulisti, id in salutem gentium per aquam regenerationis operaris: praesta; ut in Abrahae filios, et in Israeliticam dignitatem, totius mundi transeat plenitudo. Per Dominum nostrum, Iesum Christum, Filium tuum, qui tecum vivit et regnat in unitate Spiritus Sancti, Deus, per omnia saecula saeculorum. R. Amen.],
      [O Gott, Deine uralten Wunder sehrn wir noch in unseren Zeiten erstrahlen; was Dein mächtiger Arm an dem einen Volke getan, als Du es vor den ägyptischen Verfolgern gerettet, das wirkest Du zum Heile der Heidenvölker durch das Wasser der Wiedergeburt; gewähre, daß die Menschen der ganzen Welt eingehn dürfen zu der Kindschaft Abrahams und zur Würde Israels, Deines Volkes. Durch unsern Herrn Jesus Christus, Deinen Sohn, der mit Dir lebt und herrscht in der Einheit des Heiligen Geistes, Gott von Ewigkeit zu Ewigkeit. Amen.],
    )
  ]
]

#v(4pt)

#abschnitt(prophetien-strich)[
  #section-title("Prophetie III — Weinberglied", farbe: prophetien-farbe)
  #referenz[Jes 4,2–6]
  #v(2pt)
  #bilingue(
    [In die illa erit germen Domini in magnificentia, et gloria, et fructus terrae sublimis, et exultatio his, qui salvati fuerint de Israel. Et erit: Omnis qui relictus fuerit in Sion, et residuus in Ierusalem, sanctus vocabitur, omnis qui scriptus est in vita in Ierusalem. Si abluerit Dominus sordes filiarum Sion, et sanguinem Ierusalem laverit de medio eius, in spiritu iudicii, et spiritu ardoris. Et creabit Dominus super omnem locum montis Sion, et ubi invocatus est, nubem per diem, et fumum, et splendorem ignis flammantis in nocte: super omnem enim gloriam protectio. Et tabernaculum erit in umbraculum diei ab aestu, et in securitatem, et absconsionem a turbine, et a pluvia.],
    [An jenem Tage wird groß sein und ruhmvoll der Sproß des Herrn, und die Frucht des Lan­des wird herrlich stehn, und Froh­locken wird zuteil jenen aus Israel, die gerettet sind. Und je­der, der dann übrigbleibt in Sion und zurückbleibt in Jerusalem, wird heilig genannt: jeder, der eingeschrieben ward zum Le­ben in Jerusalem. Wenn der Herr dann abgewaschen den Schmutz der Töchter Sions und getilgt die Blutschuld Jerusalems durch den Geist des Gerichtes und den Geist der sengenden Gluten, dann wird der Herr über den ganzen Berg Sion und überall, wo Er angeru­fen wird, eine schattige Wolke schaffen bei Tag und flammen­den Feuerschein in der Nacht. Und über alle Herrlichkeit wird Sein Schutz sich breiten. Und ein Gezelt wird sein als Schatten ge­gen die Hitze bei Tag und als Zuflucht und Deckung gegen Unwetter und Regen.],
  )
  #v(4pt)
  #section-title("Canticum — Vínea facta est", farbe: prophetien-farbe)
  #referenz[Jes 5,1–2]
  #bilingue(
    [Vinea facta est dilecto in cornu, in loco uberi. V Et maceriam circumdedit, et circumfodit: et plantavit vineam Sorec: et aedificavit turrim in medio eius. V Et torcular fodit in ea: vinea enim Domini Sabaoth, domus Israel est.],
    [1. Ch Ein Weinberg war meinem Geliebten zu eigen / oben auf fruchtbarer Höhe. 2. Ch Und Er zog um ihn eine Mauer, / Er grub ihn um und pflanzte Reben von Sorek. 1. Ch In seine Mitte baute Er einen Turm, / und Er grub eine Kelter. 2. Ch Der Weinberg des Herrn der himmlischen Heere, es ist das Haus Israel.],
  )
  #v(2pt)
  #rubrik[Orémus. — Flectámus génua. — Leváte. #kniebeuge #stehen]
  #block(breakable: false)[
    #bilingue(
      [Deus, qui in omnibus Ecclesiae tuae filiis sanctorum prophetarum voce manifestasti, in omni loco dominationis tuae, satorem te bonorum seminum, et electorum palmitum esse cultorem: tribue populis tuis, qui et vinearum apud te nomine censentur, et segetum; ut, spinarum et tribulorum squalore resecato, digna efficiantur fruge fecundi. Per Dominum nostrum Iesum Christun Filium tuum, qui tecum vivit et regnat in unitate Spiritus Sancti Deus, per omnia saecula saeculorum.],
      [O Gott, allen Kindern Deiner Kirche hast Du dieses verkündet durch den Mund Deiner heiligen Propheten: An jedem Ort Deiner Herrschaft bist Du der Sämann, der sät den guten Samen, und bist der Winzer, der pflanzet erlesene Reben. Verleihe Deinen Völkern, die Dir Weinberg und Saatfeld bedeuten, daß sie ausroden die wuchernden Disteln und Dornen und daß sie gute Früchte tragen in Fülle. Durch unsern Herrn Jesus Christus, Deinen Sohn, der mit Dir lebt und herrscht in der Einheit des Heiligen Geistes, Gott von Ewigkeit zu Ewigkeit. Amen.],
    )
  ]
]

#v(4pt)

#abschnitt(prophetien-strich)[
  #section-title("Prophetie IV — Canticum Moysi", farbe: prophetien-farbe)
  #referenz[Dtn 31,22–30]
  #v(2pt)
  #bilingue(
    [In diebus illis: Scripsit ergo Moyses canticum et docuit filios Israel. Praecepitque Dominus Iosue filio Nun et ait: Confortare, et esto robustus: tu enim introduces filios Israel in terram, quam pollicitus sum, et ego ero tecum. Postquam ergo scripsit Moses verba legis huius in volumine, atque conplevit: praecepit Levitis, qui portabant arcam foederis Domini dicens: Tollite librum istum, et ponite eum in latere arcae foederis Domini Dei vestri: ut sit ibi contra te in testimonium. Ego enim scio contentionem tuam, et cervicem tuam durissimam. Adhuc vivente me, et ingrediente vobiscum, semper contentiose egistis contra Dominum: quanto magis cum mortuus fuero? Congregate ad me omnes maiores natu per tribus vestras, atque doctores, et loquar audientibus eis sermones istos, et invocabo contra eos caelum et terram. Novi enim quod post mortem meam inique agetis, et declinabitis cito de via, quam praecepi vobis: et occurrent vobis mala in extremo tempore, quando feceritis malum in conspectu Domini, ut irritetis eum per opera manuum vestrarum. Locutus est ergo Moyses, audiente universo coetu Israel, verba carminis huius, et ad finem usque conplevit:],
    [In jenen Tagen schrieb Moses ei Lied auf und lehrte es die Söhne Israels. Und der Herr gebot Josue dem Sohne des Nun, und Er sprach: „Sei mannhaft und stark, denn du sollst die Söhne Israels einführen in das Land, das ihnen verheißen, und Ich selber werde mit dir sein. Da nun Moses die Worte dieses Gesetzes in eine Buchrolle geschrieben und vollendet hatte, da gebot er den Leviten, die die Bundeslade des Herrn trugen,und sprach: „Nehmet das Buch mit diesem Gesetze und legt es nieder an der Seite der Bundeslade des Herrn, eures Gottes, damit es dort zum Zeugnis diene wider dich. Denn ich kenne deine Widerspenstigkeit und deinen störrischen Nacken, Schon jetzt, da ich noch am Leben bin und bei euch weile, seid ihr allezeit widerspenstig gewesen gegen den Herrn; um wieviel mehr erst, wenn ich gestorben bin! Versammelt alle Ältesten eurer Stämme und eure Lehrer zu mir, daß ich vor ihnen diese Worte verkünde und Himmel und Erde gegen sie anrufe als Zeu­gen. Denn ich weiß: ihr werdet nach meinem Tode schlecht han­deln und schnell vom Wege ab­weichen, den ich euch gewiesen. Es wird euch Unglück treffen in der letzten Zeit, wenn ihr böse handelt vor den Augen des Herrn, indem ihr durch das Werk eurer Hände Ihn erregen werdet zum Zorne." Und Moses trug der ganzen Gemeinde Israels die Worte dieses Liedes vor bis zu Ende:],
  )
  #v(4pt)
  #section-title("Canticum — Atténde, cælum", farbe: prophetien-farbe)
  #referenz[Dtn 32,1–4]
  #bilingue(
    [Attende, caelum, et loquar: et audiat terra verba ex ore meo. V. Exspectetur sicut pluvia eloquium meum: et descendant sicut ros verba mea, sicut imber super gramina. V. Et sicut nix super fenum: quia nomen Domini invocabo. V. Date magnitudinem Deo nostro: Deus, vera opera eius, et omnes viae eius iudicia. V. Deus fidelis, in quo non est iniquitas: iustus et sanctus Dominus.],
    [Ch Horche auf, o Himmel, ich rede! / Erde, vernimm die Worte meines Mundes; 2. Ch Meine Rede nimm auf wie den Regen,/niederfließen sollen meine Worte wie Tau; 1. Ch Gleich­wie Regen auf sprossende Kräu­ter / und wie Schnee auf welken­des Laub; / denn anrufen will ich den Namen des Herrn. 2. Ch Unserem Gott gebet Ehre! / Gottes Werke sind wahr, / gerecht sind all Seine Wege. 1. u. 2. Ch Gott ist getreu, in Ihm ist kein Trug; / heilig ist der Herr und gerecht.],
  )
  #v(2pt)
  #rubrik[Orémus. — Flectámus génua. — Leváte. #kniebeuge #stehen]
  #block(breakable: false)[
    #bilingue(
      [Deus, celsitudo humilium et fortitudo rectorum, qui per sanctum Moysen puerum tuum, ita erudire populum tuum sacri carminis tui decantatione voluisti, ut illa legis iteratio fieret etiam nostra directio: excita in omnem iustificatarum gentium plenitudinem potentiam tuam, et da laetitiam, mitigando terrorem; ut, omnium peccatis tua remissione deletis, quod denuntiatum est in ultionem, transeat in salutem. Per Dominum nostrum, Iesum Christum, Filium tuum, qui tecum vivit et regnat in unitate Spiritus Sancti Deus, per omnia saecula saeculorum.],
      [O Gott, Du erhöhest die Nied­rigen, Du stärkest die Gerech­ten; Du wolltest, daß Moses, Dein heiliger Knecht, durch den Vortrag dieses heiligen Liedes Dein Volk so belehre, daß jenes Wiederholen des Gesetzes auch uns den Weg weise. Entbiete Deine Macht für alle Völker, die gerechtfertigt sind; sänftige die Furcht und gib ihnen Freude; tilge verzeihend all ihre Sünden, und das Strafgericht, mit dem Du ihnen gedroht, wandle in Segen. Durch unsern Herrn Jesus Christus, Deinen Sohn, der mit Dir lebt und herrscht in der Einheit des Heiligen Geistes, Gott von Ewigkeit zu Ewigkeit. Amen.],
    )
  ]
]

// ═══════════════════════════════════════════════════════════════
// TEIL 3 — ALLERHEILIGENLITANEI (Erster Teil)
// ═══════════════════════════════════════════════════════════════

#teil-label("III · Allerheiligenlitanei — Erster Teil", litanei-farbe)

#abschnitt(litanei-strich)[
  #section-title("Litanei — Erster Teil", farbe: litanei-farbe)
  #rubrik[Alle knien. Zwei Kantoren singen, die Gemeinde antwortet. #kniebeuge]
  #v(2pt)
  #block(breakable: false)[
    #bilingue(
      [Kyrie eleison \
Christe eleison \
Kyrie eleison],
      [Herr, erbarme Dich unser \
Christus, erbarme Dich unser \
Herr, erbarme Dich unser],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Christe, audi nos \
Christe, exaudi nos],
      [Christus, höre uns \
Christus, erhöre uns],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Pater de cælis, Deus – miserere nobis \
Fili Redemptor mundi, Deus \
Spiritus Sancte, Deus \
Sancta Trinitas, unus Deus],
      [Gott Vater vom Himmel – erbarme Dich unser \
Gott Sohn, Erlöser der Welt \
Gott Heiliger Geist \
Heilige Dreifaltigkeit, ein einiger Gott],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Sancta Maria – ora pro nobis \
Sancta Dei Genitrix \
Sancta Virgo virginum],
      [Heilige Maria – bitte für uns \
Heilige Gottesgebärerin \
Heilige Jungfrau über allen Jungfrauen],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Sancte Michael \
Sancte Gabriel \
Sancte Raphael \
Omnes sancti Angeli et Archangeli – orate pro nobis \
Omnes sancti beatorum Spirituum ordines],
      [Heiliger Michael \
Heiliger Gabriel \
Heiliger Raphael \
Alle heiligen Engel und Erzengel – bittet für uns \
Alle heiligen Chöre der seligen Geister],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Sancte Joannes Baptista – ora pro nobis \
Sancte Joseph \
Omnes sancti Patriarchæ et Prophetæ – orate pro nobis],
      [Heiliger Johannes der Täufer – bitte für uns \
Heiliger Joseph \
Alle heiligen Patriarchen und Propheten – bittet für uns],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Sancte Petre – ora pro nobis \
Sancte Paule \
Sancte Andrea \
Sancte Joannes \
Omnes sancti Apostoli et Evangelistæ – orate pro nobis \
Omnes sancti Discipuli Domini],
      [Heiliger Petrus – bitte für uns \
Heiliger Paulus \
Heiliger Andreas \
Heiliger Johannes \
Alle heiligen Apostel und Evan­gelisten – bittet für uns \
Alle heiligen Jünger des Herrn],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Sancte Stephane – ora pro nobis \
Sancte Laurenti \
Sancte Vincenti \
Omnes sancti Martyres – orate pro nobis],
      [Heiliger Stephanus – bitte für uns \
Heiliger Laurentius \
Heiliger Vincentius \
Alle heiligen Märtyrer – bittet für uns],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Sancte Silvester – ora pro nobis \
Sancte Gregori \
Sancte Augustine \
Omnes sancti Pontifices et Confessores – orate pro nobis \
Omnes sancti Doctores],
      [Heiliger Silvester – bitte für uns \
Heiliger Gregorius \
Heiliger Augustinus \
Alle heiligen Bischöfe und Be­kenner – bittet für uns \
Alle heiligen Kirchenlehrer],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Sancte Antoni – ora pro nobis \
Sancte Benedicte \
Sancte Dominice \
Sancte Francisce \
Omnes sancti Sacerdotes et Levitæ – orate pro nobis \
Omnes sancti Monachi et Eremitæ],
      [Heiliger Antonius – bitte für uns \
Heiliger Benediktus \
Heiliger Dominikus \
Heiliger Franziskus \
Alle heiligen Priester und Le­viten – bittet für uns \
Alle heiligen Mönche und Ein­siedler],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Sancta Maria Magdalena – ora pro nobis \
Sancta Agnes \
Sancta Cæcilia \
Sancta Agatha \
Sancta Anastasia \
Omnes sanctæ Virgines et Viduæ – orate pro nobis],
      [Heilige Maria Magdalena – bitte für uns \
Heilige Agnes \
Heilige Cäcilia \
Heilige Agatha \
Heilige Anastasia \
Alle heiligen Jungfrauen und Witwen – bittet für uns],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Omnes Sancti et Sanctæ Dei – intercedite pro nobis],
      [Alle Heiligen Gottes – bittet für uns],
    )
  ]
]

// ═══════════════════════════════════════════════════════════════
// TEIL 4 — TAUFWASSERWEIHE
// ═══════════════════════════════════════════════════════════════

#teil-label("IV · Taufwasserweihe", taufe-farbe)

#abschnitt(taufe-strich)[
  #section-title("Weihe des Taufwassers", farbe: taufe-farbe)
  #rubrik[Der Zelebrant betet die Präfation über das Wasser im Präfationston. Er teilt das Wasser kreuzförmig mit der Hand. #stehen]
  #v(2pt)
  #block(breakable: false)[
    #bilingue(
      [Pr. Dominus vobiscum. \
A. Et cum spiritu tuo.],
      [Pr. Der Herr sei mit euch. \
A. Und mit deinem Geiste],
    )
  ]
  #v(1pt)
  #bilingue(
    [Oremus. Omnipotens sempiterne Deus, adesto magnae pietatis tuae mysteriis, adesto sacramentis: et ad recreandos novos populos, quos tibi fons baptismatis parturit, spiritum adoptionis emitte; ut, quod nostrae humilitatis gerendum est ministerio, virtutiss tuae impleatur effectu. Per Dominum nostrum, Iesum Christum, filium tuum, qui tecum vivit et regnat in unitate Spiritus Sancti Deus: Per omnia saecula saeculorum. A Amen.],
    [Lasset uns beten. Allmächtiger, ewiger Gott, sei hilfreich zugegen den Mysterien Deiner göttlichen Huld, sei zugegen dem Vollzug Deiner Sakramente! Sende aus den Geist der Kindschaft: Er möge erschaffen ein neues Volk, Dir geboren aus dem Brunnen der Taufe; und was nun geschehen soll im priesterlichen Dienste, getan in unserer Schwachheit, das lasse Wirklichkeit werden durch Deine Kraft. Durch unsern Herrn Jesus Christus, Deinen Sohn, der mit Dir lebt und herrscht in der Einheit des Heiligen Geistes, Gott von Ewigkeit zu Ewigkeit. Amen.],
  )
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Pr. Dominus vobiscum. \
A. Et cum spiritu tuo. \
Pr. Sursum corda. \
A. Habemus ad Dominum. \
Pr. Gratias agamus Domino Deo nostro. \
A. Dignum et iustum est.],
      [Pr. Der Herr sei mit euch. \
A. Und mit deinem Geiste \
Pr. Erhebet die Herzen \
A. Wir haben sie beim Herrn. \
Pr. Dank laßt uns sagen dem Herrn, unserm Gott. \
A. Würdig ist es und recht.],
    )
  ]
  #v(1pt)
  #bilingue(
    [Vere dignum et iustum est, aequum et salutare, nos tibi semper et ubique gratias agere, Domine, sancte Pater, omnipotens aeterne Deus: qui invisibili potentia, sacramentorum tuorum mirabiliter operaris effectum: et licet nos tantis mysteriis exsequendis simus indigni: tu tamen gratiae tuae dona non deserens, etiam ad nostras preces aures tuae pietatis inclinas. \
Deus, cuius Spiritus super aquas inter ipsa munda primordia ferebatur: ut iam tunc virtutem sanctificationis, aquarum natura conciperet. Deus, qui nocentis mundi crimina per aquas abluens, regenerationis speciem in ipsa diluvii effusione signasti: ut, unius eiusdemque elementi mysterio, et finis esset vitiis, et origo virtutibus. Respice, Domine, in faciem Ecclesiae tuae, et multiplica in ea regenerationes tuas, qui gratiae tuae affluentis impetu laetificas civitatem tuam: fontemque baptismatis aperis toto orbe terrarum gentibus innovandis: ut, tuae maiestatis imperio, sumat Unigeniti tui gratiam de Spiritu Sancto.],
    [In Wahrheit ist es würdig und recht, billig und heilsam, immer und überall Dank zu sagen Dir, o Herr, heiliger Vater, allmächtiger, ewiger Gott: der Du mit unsichtbarer Kraft Deine Sakra­mente wirksam machest. Wohl sind wir nicht würdig, so hohe Geheimnisse zu vollziehen, Du aber willst nicht ferne bleiben den Geschenken Deiner Gnade und neigest unsern Bitten gütig Dein Ohr. O Gott, dessen Geist über den Wassern schwebte am Anfang der Welt, auf daß die Natur des Wassers schon damals die Kraft empfange, heilig zu machen: 0 Gott, der Du unsere Wiederge­burt vorgebildet hast in den Wogen der Sintflut, der Du ab­gewaschen die Schuld der sündigen Welt in den Wassern, auf daß im Geheimnis dieses einen Elementes Untergang sei für die Sünde, für die Tugend ein neuer Beginn: Blicke, o Herr, in das Angesicht Deiner Kirche und mache zahlreich in ihr die Wun­der Deiner Wiedergeburt! Er­freuest Du doch Deine Stadt mit dem mächtigen Strom Deiner Gnade und öffnest den Brunnen der Taufe, um neu zu schaffen alle Völker der Erde. Laß die­sen Brunnen auf das Wort Dei­ner Majestät die Gnade Deines Eingeborenen empfangen vom Heiligen Geiste.],
  )
  #v(1pt)
  #bilingue(
    [Qui hanc aquam, regenerandis hominibus praeparatam, arcana sui numinis admixtione fecundet: ut, sanctificatione concepta, ab immaculato divini fontis utero, in novam renata creaturam, progenies caelestis emergat: et quos aut sexus in corpore, aut aetas discernit in tempore, omnes in unam pariat gratia mater infantiam. Procul ergo hinc, iubente te, Domine, omnis spiritus immundus abscedat: procul tota neqitia diabolicae fraudis absistat. Nihil hoc loci habeat contrariae virtutis admixtio: non insidiando cicumvolet: non latendo subrepat: non inficiendo corrumpat.],
    [Dieses Wasser hier, bereitet für die Wiedergeburt der Menschen, es werde befruchtet vom Hei­ligen Geist durch die geheimnis­volle Mitteilung Seines göttlichen Odems. Es empfange die Kraft, um heilig zu machen, und aus dem makellosen Mutterschoße des göttlichen Brunnens steige empor ein himmlisches Volk, zu neuen Geschöpfen geboren. Und seien sie auch verschieden nach Geschlecht und nach Alter, zu gleicher Kindheit gebäre als Mut­ter sie alle die Gnade. Fernab weiche von hier auf Deinen Be­fehl, o Herr, jeder unreine Geist; weithin fliehe alle Bosheit teuf­lischen Truges. Keinen Raum habe hier die Einwirkung feind­licher Macht, nicht kreise sie lau­ernd umher, nicht schleiche sie heimlich heran, mit ihrem Gifthauch verderbe sie nicht.],
  )
  #v(1pt)
  #bilingue(
    [Sit haec sancta et innocens creatura, libera ab omni impugnatoris incursu, et totius nequitiae purgata discessu. Sit fons vivus, aqua regenerans, unda purificans: ut omnes hoc lavacro salutifero diluendi, operante in eis Spiritu Sancto, perfectae purgationis indulgentiam consequantur.],
    [Dieses Wasser, geschaffen von Gott, sie heilig und sündelos; von jedem Ansturm des Widersachers befreit; rein sei es ein lebensspendender Quell, ein Wasser zu neuer Geburt , eine sühnende Flut. Und alle, die gewaschen werden in diesem heiligen Bad, volle Reinigung werde ihnen zuteil und Nachlaß der Sünden durch das Wirken des Heiligen Geistes in ihnen.],
  )
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Unde benedíco te, creatúra aquæ, per Deum #kreuz vivum, per Deum #kreuz verum, per Deum #kreuz sanctum: per Deum, qui te, in princípio, verbo separávit ab árida: cuius Spíritus super te ferebátur.],
      [Und so segne ich dich, du Geschöpf des Wassers, durch den #kreuz lebendigen Gott, den #kreuz wahren Gott, den #kreuz heiligen Gott, durch Gott, der mit Seinem Worte dich schied vom trockenen Land, dessen Geist im Anfang über dir schwebte.],
    )
  ]
  #v(1pt)
  #bilingue(
    [Qui te paradísi fonte manáre fecit, et in quátuor flumínibus totam terram rigáre præcépit. Qui te in desérto amáram, suavitáte índita, fecit esse potábilem, et sitiénti pópulo de petra prodúxit. Bene#kreuz díco te et per Iesum Christum Fílium eius únicum, Dóminum nostrum: qui te in Cana Galilaeae signo admirabili, sua potentia convertit in vinum. Qui pedibus super te ambulavit: et a Ioanne in Iordane in te baptizatus est. Qui te una cum sanguine de latere suo produxit: et discipulis suis iussit, ut credentes baptizarentur in te, dicens: Ite, docete omnes gentes, baptizantes eos in nomine Patris, et Filii, et Spiritus Sancti.],
    [Er ließ dich entspringen der Quelle im Paradies und gebot dir, in vier Strömen die ganze Erde zu netzen; Er verlieh dir Süßigkeit in der Wüste, als du bitter gewesen, und machte dich trinkbar; Er rief dich aus dem Felsen hervor, das dürstende Volk zu erquicken. Ich segne dich auch durch Seinen alleini­gen Sohn, unsern Herrn Jesus Christus, der dich zu Kana in Galiläa hat verwandelt in Wein durch ein Wunderzeichen Seiner göttlichen Macht; der mit Seinen Füßen auf dir einherging; der im Jordan von Johannes getauft ward mit dir; der dich aus Seiner Seite hervorquellen ließ zusam­men mit Blut. Er befahl Seinen Jüngern, sie sollten mit dir die Gläubigen taufen, und sprach: Geht hin und lehret alle Völker und taufet sie im Namen des Vaters und des Sohnes und des Heiligen Geistes.],
  )
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [U \
Haec nobis praecepta servantibus tu, Deus omnipotens, clemens adesto: tu benignus aspira.],
      [Indes wir diesen Auftrag voll­führen, stehe Du in Deiner Güte uns bei, allmächtiger Gott; sende Du uns gnädig den Hauch Dei­nes Geistes.],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [U \
Tu has simplices aquas tuo ore benedicito: ut praeter naturalem emundationem, quam lavandis possunt adhibere corporibus, sint etiam purificandis mentibus efficaces.],
      [Weihe Du mit Deinem Munde dieses lautere Wasser. Es wasche nicht nur den Körper auf die natürliche "Weise, wirksam sei es vielmehr, rein zu machen die Seele.],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Descendat in hanc plenitudinem fontis virtus Spiritus Sancti.],
      [Es steige herab in diesen vollen Born die Kraft des Heiligen Geistes.],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Totamque hujus aquae substantiam, regenerandi fecundet effectu.],
      [Und er befruchte all dieses Wasser, auf daß es wirke die neue Geburt.],
    )
  ]
  #v(1pt)
  #bilingue(
    [Hic omnium peccatorum maculae deleantur: hic natura ad imaginem tuam condita, et ad honorem sui reformata principii, conctis vetustatis squaloribus emundetur: ut omnis homo, sacramentum hoc regenerationis ingressus, in verae innocentiae novam infantium renascatur. Per Dominum nostrum Iesum Christum Filium tuum: qui venturus est iudicare vivos et mortuos, et saeculum per ignem. R. Amen.],
    [So werde hier getilgt alle Makel der Sünde; rein gewaschen werde hier die Natur von jedem Unflat des alten Menschen, jene Natur, die geschafften nach Deinem Bilde, die nun zur Würde ihres Ursprungs zurückkehrt. Und jeder, der eingeht in dieses Sakrament der neuen Geburt, zu neuer Kindheit werde er wiedergeboren in wahrer Unschuld. Durch DeinenSohn, unsern Herrn Jusus Christus, der da kommen wird, zu richten die Lebenden und die Toten und die Welt durch das Feuer. Amen.],
  )
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Sanctificetur et fecundetur fons iste Oleo salutis renascentibus ex eo, in vitam aeternam. A Amen.],
      [Das Öl des Heiles befruchte und heilige diesen Brunnen für alle, die aus ihm wiedergeboren wer­den zum ewigen Leben. Amen.],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Infusio Chrismatis Domini nostri Iesu Christi, et Spiritus Sancti Paracliti, fiat in nomine santae Trinitatis. R. Amen.],
      [Im Namen der Heiligen Drei­faltigkeit werde eingegossen der Chrisam unseres Herrn Jesus Christus und des Heiligen Gei­stes, des Helfers. Amen.],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Commíxtio Chrísmatis sanctificatiónis, et Ólei unctiónis, et aquæ baptísmatis, páriter fiat in nómine Pa#kreuz tris, et Fi#kreuz lii, et Spíritus #kreuz Sancti. ℟. Amen.],
      [Der Chrisam der Heiligung und das Öl der Salbung und das Wasser der Taufe, sie seien zusammengetan im Namen des #kreuz Vaters und des #kreuz Sohnes und des Heiligen #kreuz Geistes. ℟. Amen.],
    )
  ]
]

#v(4pt)

#abschnitt(taufe-strich)[
  #section-title("Eintauchen der Osterkerze", farbe: taufe-farbe)
  #rubrik[3× in aufsteigendem Ton wird die Osterkerze ins Wasser getaucht. #stehen]
  #v(2pt)
  #block(breakable: false)[
    #bilingue(
      [Descendat in hanc plenitudinem fontis virtus Spiritus Sancti.],
      [Es steige herab in diesen vollen Born die Kraft des Heiligen Geistes.],
    )
  ]
]

#v(4pt)

#abschnitt(taufe-strich)[
  #section-title("Sicut cervus", farbe: taufe-farbe)
  #referenz[Ps 41,2–4]
  #rubrik[Prozession zum Taufbrunnen. #stehen]
  #v(2pt)
  #bilingue(
    [Sicut cervus desiderat ad fontes aquarum: ita desiderat anima mea ad te, Deus. Sitivit anima mea ad Deum vivum, quando veniam, et apparebo ante faciem Dei? Fuerunt mihi lacrymae meae panes die ac nocte, dum dicitur mihi per singulos dies: Ubi est Deus tuus?],
    [Ch Wie der Hirsch verlangt nach den Quellen der Wasser, / so verlangt, o Gott, meine Seele nach Dir. Ch. Meine Seele dür­stet nadi dem lebendigen Gott. / Wann darf ich kommen und treten vor Gottes Angesicht? 1u. 2. Ch. Meine Tränen sind mir zum Brot geworden bei Tag und bei Nacht; / an jedem Tage fragen sie mich: Wo bleibt dein Gott?],
  )
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Pr. Dominus vobiscum. \
A. Et cum spiritu tuo.],
      [Der Herr sei mit euch. \
Und mit deinem Geiste.],
    )
  ]
  #v(1pt)
  #bilingue(
    [Oremus. Omnipotens sempiterne Deus, respice propitius ad devotionem populi renascentis, qui sicut cervus, aquarum tuarum expetit fontem: et concede propitius; ut fidei ipsius sitis, baptismatis mysterio, animam corpusque sanctificet. Per Dominum nostrum Iesum Christum, qui tecum vivit et regnat in unitate Spiritus Sancti, Deus, per omnia saecula saeculorum. R. Amen.],
    [Lasset uns beten. Allmächtiger, ewiger Gott, blicke gnädig herab auf das fromme Verlangen dieser Schar, die nun wiedergeboren soll werden und die gleich dem Hirsch verlangt nach dem Quell Deiner Wasser; gewähre in Gnaden, daß ihr Durst nach dem Glauben sie heilig mache an Leib und Seele im Heiltum der Taufe. Durch unsern Herrn. Amen.],
  )
]

// ═══════════════════════════════════════════════════════════════
// TEIL 5 — ERNEUERUNG DER TAUFVERSPRECHEN
// ═══════════════════════════════════════════════════════════════

#teil-label("V · Erneuerung der Taufversprechen", versprechen-farbe)

#abschnitt(versprechen-strich)[
  #section-title("Abschwörung und Glaubensbekenntnis", farbe: versprechen-farbe)
  #rubrik[Alle stehen mit brennenden Kerzen. Der Zelebrant wechselt auf weiße Paramente. #stehen]
  #v(2pt)
  #bilingue(
    [℣. Abrenuntiátis Sátanæ? \\ ℟. Abrenuntiámus.],
    [℣. Widersagt ihr dem Satan? \\ ℟. Wir widersagen.],
  )
  #v(2pt)
  #bilingue(
    [℣. Et ómnibus opéribus eius? \\ ℟. Abrenuntiámus.],
    [℣. Und allen seinen Werken? \\ ℟. Wir widersagen.],
  )
  #v(2pt)
  #bilingue(
    [℣. Et ómnibus pompis eius? \\ ℟. Abrenuntiámus.],
    [℣. Und all seiner Pracht? \\ ℟. Wir widersagen.],
  )
  #v(4pt)
  #bilingue(
    [℣. Créditis in Deum, Patrem omnipoténtem, Creatórem cæli et terræ? \\ ℟. Crédimus.],
    [℣. Glaubt ihr an Gott, den allmächtigen Vater, den Schöpfer des Himmels und der Erde? \\ ℟. Wir glauben.],
  )
  #v(2pt)
  #bilingue(
    [℣. Créditis in Iesum Christum, Fílium eius únicum, Dóminum nostrum, natum et passum? \\ ℟. Crédimus.],
    [℣. Glaubt ihr an Jesus Christus, seinen eingeborenen Sohn, unsern Herrn, der geboren und gelitten hat? \\ ℟. Wir glauben.],
  )
  #v(2pt)
  #bilingue(
    [℣. Créditis et in Spíritum Sanctum, sanctam Ecclésiam cathólicam, Sanctórum communiónem, remissiónem peccatórum, carnis resurrectiónem et vitam ætérnam? \\ ℟. Crédimus.],
    [℣. Glaubt ihr auch an den Heiligen Geist, die heilige katholische Kirche, die Gemeinschaft der Heiligen, die Nachlassung der Sünden, die Auferstehung des Fleisches und das ewige Leben? \\ ℟. Wir glauben.],
  )
]

#v(4pt)

#abschnitt(versprechen-strich)[
  #section-title("Besprengung", farbe: versprechen-farbe)
  #rubrik[Der Zelebrant besprengt das Volk mit dem neuen Taufwasser. #stehen]
  #v(2pt)
  #bilingue(
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
  )
]

// ═══════════════════════════════════════════════════════════════
// TEIL 6 — OSTERMESSE (Missa Sollemnis Vigiliæ Paschalis)
// ═══════════════════════════════════════════════════════════════

#teil-label("VI · Missa Sollemnis Vigiliæ Paschalis", messe-farbe)

#abschnitt(messe-strich)[
  #section-title("Litanei II — Kyrie", farbe: messe-farbe)
  #rubrik[Zweiter Teil der Allerheiligenlitanei, übergehend in das Kyrie. #kniebeuge]
  #v(2pt)
  #block(breakable: false)[
    #bilingue(
      [Propitius esto, parce nobis, Domine.],
      [Sei uns gnädig, verschone uns, o Herr.],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Propitius esto, exaudi nos, Domine.],
      [Sei uns gnädig, erhöre uns, o Herr.],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Ab omni malo, libera nos, Domine.],
      [Von allem Übel, erlöse uns, o Herr.],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Ab omni peccato, libera nos, Domine.],
      [Von aller Sünde,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [A morte perpetua, libera nos, Domine.],
      [Von dem ewigen Tode,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Per mysterium sanctae Incarnationis tuae, libera nos, Domine.],
      [Durch das Geheimnis Deiner heiligen Menschwerdung,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Per adventum tuum, libera nos, Domine.],
      [Durch Deine Ankunft,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Per nativitatem tuum, libera nos, Domine.],
      [Durch Deine Geburt,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Per baptismum et sanctum ieiunium tuum, libera nos, Domine.],
      [Durch Deine Taufe und Dein heiliges Fasten,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Per crucem et passionem tuam, libera nos, Domine.],
      [Durch Dein Kreuz und Leiden,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Per mortem et sepulturam tuam, libera nos, Domine.],
      [Durch Deinen Tod und Dein Begräbnis,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Per sanctam resurrectionem tuam, libera nos, Domine.],
      [Durch Deine heilige Auferstehung,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Per admirabilem ascensionem tuam, libera nos, Domine.],
      [Durch Deine wunderbare Himmelfahrt,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Per adventum Spiritus Sancti Paracliti, libera nos, Domine.],
      [Durch die Ankunft des Heiligen Geistes, des Trösters,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [In die iudicii, libera nos, Domine.],
      [Am Tage des Gerichtes],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Peccatores, te rogamus, audi nos.],
      [Wir armen Sünder, wir bitten Dich, erhöre uns.],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Ut nobis parcas, te rogamus, audi nos.],
      [Daß Du uns verschonest,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Ut Ecclesiam tuam sanctam regere et conservare digneris, te rogamus, audi nos.],
      [Daß Du Deine heilige Kirche regieren und erhalten wolllest,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Ut domnum apostolicum et omnes ecclesiasticosn ordines in sancta religione conservare digneris, te rogamus, audi nos.],
      [Daß Du den apostolischen Oberhirten und alle Stände der Kirche in der heiligen Religion erhalten wollest,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Ut inimicos sanctae Ecclesiae humiliare digneris, te rogamus, audi nos.],
      [Daß Du die Feinde der heiligen Kirche demütigen wollest,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Ut regibus et principibus christianis, pacem et veram concordiam donare digneris, te rogamus, audi nos.],
      [Daß Du den christlichen Königen und Staatslenkern Frieden und wahre Eintracht schenken wol­lest,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Ut nosmetipsos in tuo sancto servitio confortare et conservare digneris, te rogamus, audi nos.],
      [Daß Du uns selbst in Deinem heiligen Dienste stärken und erhalten wollest,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Ut omnibus benefactoribus nostris sempiterna bona retribuas, te rogamus, audi nos.],
      [Daß Du alle unsere Wohltäter mit den ewigen Gütern belohnen wollest,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Ut fructus terrae dare et conservare digneris, te rogamus, audi nos.],
      [Daß Du die Früchte der Erde geben und erhalten wollest,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Ut omnibus fidelibus defunctis requiem aeternam donare digneris, te rogamus, audi nos.],
      [Daß Du allen verstorbenen Gläubigen die ewige Ruhe verleihen wollest,],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Ut nos exaudire digneris, te rogamus, audi nos.],
      [Daß Du uns erhören wollest],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Agnus Dei, qui tollis peccata mundi, exaudi nos, Domine.],
      [O Lamm Gottes, das Du hinwegnimmst die Sünden der Wel,t erhöre uns, o Herr.],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Agnus Dei, qui tollis peccata mundi, parce nobis, Domine.],
      [O Lamm Gottes, das Du hinwegnimmst die Sünden der Welt, verschone uns, o Herr.],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Agnus Dei, qui tollis peccata mundi, miserere nobis.],
      [O Lamm Gottes, das Du hinwegnimmst die Sünden der Welt, ererbarme Dich unser.],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Christe, audi nos.],
      [Christus, höre uns.],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Christe, exaudi nos.],
      [Christus, erhöre uns.],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Kyrie eleison \
Kyrie eleison \
Kyrie eleison],
      [Herr, erbarme Dich unser \
Herr, erbarme Dich unser \
Herr, erbarme Dich unser],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Christe eleison \
Christe eleison \
Christe eleison],
      [Christus, erbarme Dich unser \
Christus, erbarme Dich unser \
Christus, erbarme Dich unser],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Kyrie eleison \
Kyrie eleison \
Kyrie eleison],
      [Herr, erbarme Dich unser \
Herr, erbarme Dich unser \
Herr, erbarme Dich unser],
    )
  ]
]

#v(4pt)

#abschnitt(messe-strich)[
  #section-title("Gloria in excelsis Deo", farbe: messe-farbe)
  #rubrik[Die Glocken läuten! Bilder und Kreuze werden enthüllt!
  Erstes Gloria seit Beginn der Fastenzeit. #stehen]
  #v(2pt)
  #bilingue(
    [Glória in excélsis Deo. Et in terra pax homínibus bonæ voluntátis. Laudámus te. Benedícimus te. #verneigung Adorámus te. Glorificámus te. Grátias ágimus tibi propter magnam glóriam tuam. Dómine Deus, Rex cæléstis, Deus Pater omnípotens. Dómine Fili unigénite, Iesu Christe. Dómine Deus, Agnus Dei, Fílius Patris. Qui tollis peccáta mundi, miserére nobis. Qui tollis peccáta mundi, súscipe deprecatiónem nostram. Qui sedes ad déxteram Patris, miserére nobis. Quóniam tu solus Sanctus. Tu solus Dóminus. Tu solus Altíssimus, #verneigung Iesu Christe. Cum Sancto Spíritu, #kreuz in glória Dei Patris. Amen.],
    [Ehre sei Gott in der Höhe. Und auf Erden Friede den Menschen, die guten Willens sind. Wir loben Dich. Wir preisen Dich. #verneigung Wir beten Dich an. Wir verherrlichen Dich. Wir sagen Dir Dank ob Deiner großen Herrlichkeit. Herr und Gott, König des Himmels, Gott allmächtiger Vater! Herr Jesus Christus, eingeborener Sohn! Herr und Gott, Lamm Gottes, Sohn des Vaters! Du nimmst hinweg die Sünden der Welt: erbarme Dich unser. Du nimmst hinweg die Sünden der Welt: nimm unser Flehen gnädig auf. Du sitzest zur Rechten des Vaters: erbarme Dich unser. Denn Du allein bist der Heilige. Du allein der Herr. Du allein der Höchste, #verneigung Jesus Christus. Mit dem Hl. Geiste, #kreuz in der Herrlichkeit Gottes des Vaters. Amen.],
  )
]

#v(4pt)

#abschnitt(messe-strich)[
  #section-title("Collecta — Tagesgebet", farbe: messe-farbe)
  #v(2pt)
  #block(breakable: false)[
    #bilingue(
      [Oremus Deus, qui hanc sacratissimum noctem gloria dominicae Resurrectionis illustras: conserva in nova familiae tuae progenie adoptionis spiritum, quem dedisti; ut, corpore et mente renovati, puram tibi exhibeant servitutem. Per eumdem Dominum nostrum Iesum Christum, Filium tuum: qui tecum vivit et regnat in unitate Spiritus Sancti Deus, per omnia saecula saeculorum. R. Amen.],
      [O Gott, Du erhellest diese hoch­heilige Nacht durch die glorreiche Auferstehung unseres Herrn; er­halte in den neugeborenen Glie­dern Deiner Kirche den Geist Deiner Kindschaft, den Du ihnen verliehen, auf daß sie, neu ge­worden an Seele und Leib, einen makellosen Dienst Dir entbieten. Durch Ihn, unsern Herrn. R Amen.],
    )
  ]
]

#v(4pt)

#abschnitt(messe-strich)[
  #section-title("Epistel", farbe: messe-farbe)
  #referenz[Kol 3,1–4]
  #v(2pt)
  #bilingue(
    [Fratres: si consurrexistis cum Christo, quae sursum sunt quaerite, ubi Christus est in dextera Dei sedens: quae sursum sunt sapite, non quae super terram. Mortui enim estis, et vita vestra est abscondita cum Christo in Deo. Cum Christus apparuerit, vita vestra: tunc et vos apparebitis cum ipso in gloria.],
    [Brüder! Seid ihr auferstanden mit Christus, so suchet, was oben ist, wo Christus thronet zur Rechten Gottes. Was oben ist, habet im Sinn, nicht was auf Erden. Denn gestorben seid ihr, und vereint mit Christus, ist euer Leben verborgen in Gott. Wenn aber Chistus, unser Leben, dereinst in Herrlichkeit wird erscheinen, dann sollet auch ihr, vereint mit Ihm, offenbar werden in Herrlichkeit.],
  )
]

#v(4pt)

#abschnitt(messe-strich)[
  #section-title("Alleluia", farbe: messe-farbe)
  #rubrik[Der Zelebrant singt 3× Alleluia in aufsteigendem Ton. Die Gemeinde wiederholt jeweils. Erstes Alleluia seit Septuagesima! #stehen]
  #v(2pt)
  #block(breakable: false)[
    #bilingue(
      [Pr. Alleluja. \
Pr. Alleluja. \
Pr. Alleluja.],
      [A Alleluja. \
A Alleluja. \
A Alleluja.],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [V Confitemini Domino, quoniam bonus: \
quoniam in saeculum misericordia eius.],
      [V Preiset den Herrn, denn Er ist gut! / \
In Ewigkeit währt Sein Erbarmen.],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Laudate Dominum omnes gentes: \
et collaudate eum, omnes populi. \
Quoniam confirmata est super nos misericordia eius: \
et veritas Domini manet in aeternum.],
      [Ch. Lobet den Herrn, alle Völ­ker; / \
ihr Stämme alle, lobpreiset Ihn! \
2. Ch. Denn mächtig waltet über uns Seine Gnade, / \
und Seine Treue währt in Ewigkeit.],
    )
  ]
]

#v(4pt)

#abschnitt(messe-strich)[
  #section-title("Evangelium", farbe: messe-farbe)
  #referenz[Mt 28,1–7]
  #rubrik[Auferstehungsevangelium. #stehen #dreikreuz]
  #v(2pt)
  #bilingue(
    [#dreikreuz Sequéntia sancti Evangélii secúndum Matthǽum. Véspere autem sábbati, quae lucescit in prima sabbati, venit Maria Magdalene, et altera Maria videre sepulchrum. Et ecce terraemotus factus est magnus. Angelus enim Domini descendit de coelo: et accedens revolvit lapidem, et sedebat super eum: erat autem aspectus eius sicut fulgur: et vestimentum eius sicut nix. Prae timore autem eius exterriti sunt custodes, et factu sunt velut mortui. Respondens autem Angelus, dixit mulieribus: Nolite timere vos: scio enim, quod Iesum, qui crucifixus est, quaeritis: non est hic: surrexit enim, sicut dixit. Venite, et videte locum, ubi positus erat Dominus. Et cito euntes dicite discipulis eius, quia surrexit et ecce praecedit vos in Galilaeam: ibi eum videbitis. Ecce praedixi vobis.],
    [#dreikreuz Als vorüber der Sabbat, als das Licht des ersten Tages nach dem Sabbat heraufkam, da gingen Maria Magdalena und die andere Maria, um nach dem Grabe zu sehen. Und siehe, es geschah ein großes Beben der Erde. Vom Himmel herab stieg ein Engel des Herrn, und er trat hinzu und wälzte den Stein hinweg und setzte sich nieder auf ihn. Er war anzusehn wie der Blitz, und sein Gewand war weiß wie der Schnee. In Furcht vor ihm erbebten die Wächter, und sie waren wie tot. Der Engel aber sprach zu den Frauen: „Ihr, fürchtet euch nicht! Ich weiß, ihr suchet Jesus, den Gekreuzigten. Er ist nicht hier denn auferstanden ist Er, wie er gesagt. Kommet und sehet die Stätte, wo Er gelegen. Eilends geht hin und sagt Seinen Jüngern: Er ist von von den Toten erstanden! Und wisset: Er wird euch vorangehen nach Galiläa, dort sollt ihr Ihn schauen. Seht, ich habe es euch gesagt."],
  )
]

#v(4pt)

#abschnitt(messe-strich)[
  #section-title("Offertorium", farbe: messe-farbe)
  #rubrik[Kein Offertorium-Vers. Stille Opferung.]
]

#v(4pt)

#abschnitt(messe-strich)[
  #section-title("Secreta — Sanctus — Canon", farbe: messe-farbe)
  #v(2pt)
  #block(breakable: false)[
    #bilingue(
      [Suscipe, quaesumus, Domine, preces populi tui, cum oblationibus hostiarum: ut paschalibus initiata mysteriis, ad aeternitatis nobis medelam, te operante, proficiant. Per Dominum nostrum Iesum Christum, Filium tuum, qui tecum vivit et regnat in unitate Spiritus Sancti, Deus, per omnia saecula saeculorum. R Amen.],
      [Wir bitten, Dich, Herr, nimm ari die Gebete Deines Volkes, nimttl an unsere Opfergaben; weihe sie durch diese österlichen Mysterien zu einem neuen Beginn, daß sie in der Kraft Deiner Gnade uns Mittel des Heiles werden zUrn ewigen Leben. Durch uns. Herrn Jesus Christus, Deinen Soh, der mit Dir lebt und herrscht in der Einheit mit dem Heiligen Geiste, Gott von Ewigkeit zu Ewigkeit. R Amen.],
    )
  ]
  #v(4pt)
  #section-title("Præfatio Paschalis", farbe: messe-farbe)
  #bilingue(
    [Vere dignum et justum est, æquum et salutare: Te quidem, Domine, omni tempore, sed in hac potissimum nocte gloriosius prædicare, cum Pascha nostrum immolatus est Christus. Ipse enim verus est Agnus, qui abstulit peccata mundi. Qui mortem nostram moriendo destruxit, et vitam resurgendo reparavit. Et ideo cum Angelis et Archangelis, cum Thronis et Dominationibus cumque omni militia cælestis exercitus, hymnum gloriæ tuæ canimus, sine fine dicentes:],
    [Es ist in Wahrheit würdig und recht, billig und heilsam, Dich, Herr, zu jeder Zeit, vornehmlich aber in dieser Nacht mit besonders festlichem Jubel zu preisen, weil Christus als unser Osterlamm geopfert ist. Er ist in Wahrheit das Lamm, das hinwegnimmt die Sünden der Welt. Durch sein Sterben hat Er unsern Tod vernichtet und durch Seine Auferstehung neues Leben uns erworben. Darum singen wir mit den Engeln und Erzengeln, mit den Thronen und Herrschaften und mit der ganzen himmlischen Heerschar den Hochgesang Deiner Herrlichkeit und rufen ohne Unterlaß:],
  )
  #v(2pt)
  #block(breakable: false)[
    #bilingue(
      [Sanctus, Sanctus, Sanctus, Dóminus Deus Sábaoth. Pleni sunt cæli et terra glória tua. Hosánna in excélsis. #verneigung Benedíctus, qui venit in nómine Dómini. Hosánna in excélsis.],
      [Heilig, Heilig, Heilig, Herr, Gott der Heerscharen. Himmel und Erde sind erfüllt von Deiner Herrlichkeit. Hosanna in der Höhe! #verneigung Hochgelobt sei, der da kommt im Namen des Herrn! Hosanna in der Höhe!],
    )
  ]
  #v(4pt)
  #section-title("Communicantes — Oster-Einschub", farbe: messe-farbe)
  #bilingue(
    [Communicantes, et noctem sacratissimam celebrantes Resurrectionis Domini nostri Jesu Christi secundum carnem: sed et memoriam venerantes, in primis gloriosæ semper Vírginis Maríæ, Genitrícis ejusdem Dei et Dómini nostri Jesu Christi: sed et beati Joseph, eiusdem Virginis Sponsi, et beatorum Apostolorum ac Martyrum tuorum, Petri et Pauli, Andreæ, Jacobi, Joannis, Thomæ, Jacobi, Philippi, Bartholomaei, Matthaei, Simonis et Thaddaei: Lini, Cleti, Clementis, Xysti, Cornelii, Cypriani, Laurentii, Chrysogoni, Joannis et Pauli, Cosmæ et Damiani: et omnium Sanctorum tuorum, quorum meritis precibusque concedas, ut in omnibus protectionis tuæ muniamur auxilio. Per eundem Christum Dominum nostrum. Amen],
    [In heiliger Gemeinschaft feiern wir die hochheilige Nacht der leiblichen Auferstehung unsres Herrn Jesus Christus. Dabei ehren wir vor allem das Andenken der glorreichen, allzeit reinen Jungfrau Maria, der Mutter Jesu Christi, unsres Herrn und Gottes, sowie des hl. Joseph, ihres Bräutigams, wie auch Deiner hll. Apostel und Blutzeugen Petrus und Paulus, Andreas, Jakobus, Johannes, Thomas, Jakobus, Philippus, Bartholomäus, Matthäus, Simon und Thaddäus, Linus, Kletus, Klemens, Xystus, Kornelius, Cyprianus, Laurentius, Chrysogonus, Johannes und Paulus, Kosmas und Damianus, und aller Deiner Heiligen. Ob ihrer Verdienste und Fürbitten gewähre uns in allem hilfreich Deinen Schutz und Beistand. Durch Christus unseren Herrn. Amen.],
  )
  #v(4pt)
  #section-title("Hanc igitur — Oster-Einschub", farbe: messe-farbe)
  #block(breakable: false)[
    #bilingue(
      [Hanc igitur oblationem servitutis nostræ, sed et cunctæ familiæ tuæ, quam tibi offerimus pro his quoque, quos regenerare dignatus es ex aqua et Spiritu Sancto, tribuens eis remissionem omnium peccatorum, quæsumus, Domine, ut placatus accipias: diesque nostros in tua pace disponas, atque ab æterna damnatione nos eripi, et in electorum tuorum jubeas grege numerari: Per Christum, Dominum nostrum. Amen.],
      [So nimm denn, Herr, wir bitten Dich, diese Opfergabe Deiner Diener, aber auch Deiner ganzen Familie huldvoll auf. Wir bringen sie Dir auch für jene dar, die Du erbarmungsvoll aus dem Wasser und dem Hl. Geiste wiedergeboren, denen Du Nachlassung all ihrer Sünden erteilt hast. Leite unsre Tage in Deinem Frieden, bewahre uns gütig vor der ewigen Verdammnis und reihe uns ein in die Schar Deiner Auserwählten. Durch Christus, unsern Herrn. Amen.],
    )
  ]
]

#v(4pt)

#abschnitt(messe-strich)[
  #section-title("Pater Noster — Kommunion", farbe: messe-farbe)
  #rubrik[Kein Agnus Dei! Direkt von Pater noster zur Brechung und Kommunion. #kniebeuge]
  #v(4pt)
  #bilingue(
    [Pater noster, qui es in cælis: sanctificétur nomen tuum: advéniat regnum tuum: fiat volúntas tua, sicut in cælo, et in terra. Panem nostrum quotidiánum da nobis hódie: et dimítte nobis débita nostra, sicut et nos dimíttimus debitóribus nostris. Et ne nos indúcas in tentatiónem. \\ ℟. Sed líbera nos a malo.],
    [Vater unser, der du bist im Himmel, geheiligt werde dein Name, dein Reich komme, dein Wille geschehe, wie im Himmel, also auch auf Erden. Unser tägliches Brot gib uns heute; und vergib uns unsere Schuld, wie auch wir vergeben unsern Schuldigern. Und führe uns nicht in Versuchung. \\ ℟. Sondern erlöse uns von dem Übel.],
  )
  #v(4pt)
  #section-title("Communio", farbe: messe-farbe)
  #referenz[Ps 117,1–4]
  #bilingue(
    [Danket dem Herrn, denn Er ist gut: / in Ewigkeit währt Sein Erbarmen. \
Saget, ihr Söhne Israels: / In Ewigkeit währt Sein Erbarmen. \
Saget, ihr Söhne Aarons: / In Ewigkeit währt Sein Erbarmen. \
Saget alle, die ihr fürchtet den Herrn: / In Ewigkeit währt Sein Erbarmen. \
Ich rief zum Herrn in meiner Bedrängnis, / und Er hat mich erhört und errettet. \
Der Herr ist mit mir, ich fürchte mich nicht: / was könnte ein Mensch mir antun! \
Der Herr ist mit mir, Er kommt mir zu Hilfe: / und in Schande werde ich sehn meine Feinde.Besser, seine Zuflucht nehmen zum Herrn, / als zu bauen auf Menschen! \
Besser, seine Zuflucht nehmen zum Herrn, / als zu bauen auf Fürsten! \
Die Heiden alle umringten mich: / ich habe sie zertreten im Namen des Herrn. \
Von allen Seiten umringten sie mich: / ich habe sie zertreten im Namen des Herrn. \
Sie drangen auf mich ein wie Schwärme von Bienen, / wie Feuer unter Dornen sind sie entbrannt: / ich habe sie zertreten im Namen des Herrn. \
Gestoßen ward ich, hart gestoßen, ich sollte fallen, / der Herr aber hat mir geholfen. \
Meine Stärke und meine Kraft ist der Herr, / Er ist mir geworden zum Retter. \
Hört! Welch ein Siegesjubel in den Zelten der Frommen! / Stark erwiesen hat sich die Rechte des Herrn. \
Die Rechte des Herrn, sie hat mich erhöht! / Ja,stark erwiesen hat sich die Rechte des Herrn.],
    [Ich werde nicht sterben, ich lebe, / und künden will ich die Taten des Herrn. \
Geschlagen hat mich der Herr, ja geschlagen, / doch Er gab mich dem Tode nicht preis. \
Tut mir auf der Gerechtigkeit Tore! / Eintreten will ich, Dank zu sagen dem Herrn. \
Dies ist die Pforte des Herrn, / durch sie gehn ein die Gerechten. \
Ich will Dir danken, denn Du hast mich erhört, / Du bist mir geworden zum Retter. \
Der Stein, den die Bauleute haben verworfen, / er ist zum Eckstein geworden. \
Durch den Herrn ist dieses geschehen: / ein Wunder vor unseren Augen. \
Dies ist der Tag, den uns bereitet der Herr: / laßt uns frohlocken und seiner uns freun! \
O Herr, sende Heil! / O Herr, gib Segen und Gnade! \
Gesegnet, der kommt im Namen des Herrn! / Vom Hause Gottes segnen wir euch; / der Herr ist Gott, uns leuchtet Sein Licht. \
Reihet euch ein in den Zug mit festlichen Zweigen, / bis zu den Hörnern des Altares ziehet hinan! \
Mein Gott bist Du, ich sage Dir Dank! / Mein Gott, mit Lobgesang will ich Dich preisen. \
Danket dem Herrn, denn Er ist gut: / in Ewigkeit währt Sein Erbarmen. \
Ehre sei dem Vater und dem Sohne und dem Heiligen Geiste: / wie es war im Anfang, so auch jetzt und allezeit und in Ewigkeit. Amen.],
  )
]

// ═══════════════════════════════════════════════════════════════
// TEIL 7 — LAUDES
// ═══════════════════════════════════════════════════════════════

#teil-label("VII · Laudes — Morgengebet der Auferstehung", licht-farbe)

#abschnitt(licht-strich)[
  #section-title("Psalm 150 — Laudáte Dóminum", farbe: licht-farbe)
  #rubrik[Antiphon: Allelúia, allelúia, allelúia. #stehen]
  #v(2pt)
  #block(breakable: false)[
    #bilingue(
      [Alleluia, alleluia, alleluia.],
      [Alleluia, alleluia, alleluia.],
    )
  ]
  #v(1pt)
  #bilingue(
    [Laudate Dominum in sanctis eius \* laudate eum in firmamento virtutis eius. \
Laudate eum in virtutibus eius, \* laudate eum secundum multitudinem magnitudinis eius. \
Laudate eum in sono tubae, \* laudate eum in psalterio, et cithara. \
Laudate eum in tympano, et choro: \* laudate eum in chordis et organo. \
Laudate eum in cymbalis benesonantibus: † laudate eum in cymbalis iubilationis: \* omnes spiritus laudet Dominum. \
Gloria Patri, et Filio, \* et Spiritui Sancto. \
Sicut erat in principio, et nunc, et semper, \* et in saecula saeculorum. Amen.],
    [Lobpreist den Herrn in Seinem Heiligtum \* lobt Ihn in Seiner starken Feste. \
Lobt Ihn ob Seiner Wunder taten, \* lobt Ihn ob Seiner großen Macht. \
Lobt Ihn im Schalle der Posaunen, \* lobt Ihn mit Harfe und mit Zither. \
Lobt Ihn mit Pauken und mit Reigentanz, \* lobt Ihn mit Saitenspiel und Flöten. \
Lobt Ihn im Klang der Zimbeln, lobt Ihn mit Freudenzimbeln. \* Alles, was Odem hat, lobe den Herrn! \
Ehre sei dem Vater und dem Sohne \* und dem Heiligen Geiste; \
Wie es war im Anfang, so auch jetzt und allezeit \* und in Ewigkeit. Amen.],
  )
]

#v(4pt)

#abschnitt(licht-strich)[
  #section-title("Benedictus — Canticum Zachariæ", farbe: licht-farbe)
  #referenz[Lk 1,68–79]
  #rubrik[Antiphon: Et valde mane una sabbatórum … #stehen]
  #v(2pt)
  #block(breakable: false)[
    #bilingue(
      [Alleluia, alleluia, alleluia. \
Et valde mane una sabbatorum, veniunt ad monumentum, orto iam sole, alleluia.],
      [Alleluia, alleluia, alleluia. \
Und gar frühe, / am ersten Tag nach dem Sabbat, / da kommen sie zum Grab, als eben aufging die Sonne, alleluja],
    )
  ]
  #v(1pt)
  #bilingue(
    [Benedictus Dominus, Deus Israel, \* quia visitavit et redemit populum suum. \
Et erexit cornu salutis nobis \* in domo David pueri sui. \
Sicut locutus est per os sanctorum, \* qui a saeculo sunt, prophatarum eius: \
Salutem ex inimicis nostris, \* et de manu omnium qui oderunt nos, \
Ad faciendam misericordiam cum patribus nostris: \* et memorari testamenti sui sancti. \
Iusiurandum, quod iuravit ad Abraham patrem nostrum, \* daturum se nobis, \
Ut sine timore, de manu inimicorum nostrorum liberati, \* serviamus illi, \
In sanctitate et iustitia coram ipso, \* omnibus diebus nostris. \
Et tu, puer, propheta Altissimi vocaberis: \* praeibis enim ante faciem Domini parare vias eius, \
Ad dandam scientiam salutis plebi eius, \* in remissionem peccatorum eorum, \
Per viscera misericordiae Dei nostri: \* in quibus visitavit nos, oriens ex alto, \
Illuminare his qui in tenebris et in umbra mortis sedent: \* ad dirigendos pedes nostros in viam pacis. \
Gloria Patri, et Filio, \* et Spiritui Sancto. \
Sicut erat in principio, et nunc, et semper, \* et in saecula saeculorum. Amen.],
    [Gepriesen sei der Herr, der Gott Israels! \* Denn heimgesucht hat Er Sein Volk und ihm Erlösung bereitet. \
Er ließ uns erstehn ein Zeichen des Heiles * in dem Haus Seines Knechtes David. \
So hat Er gesprochen durch den Mund Seiner Heiligen, \* durch die Propheten der Vorzeit: Er werde uns befreien aus der Feinde Gewalt, \* aus den Händen aller, die mit Haß uns verfolgen; \
Er werde Sich unserer Väter er­barmen \* und gedenken Seines heiligen Bundes; Ja, gedenken will Er des Eides, \* den Er geschworen Abraham, unserem Vater: \
Daß wir dürfen furchtlos Ihm dienen, * befreit aus den Hän­den der Feinde: \
In Heiligkeit und Treue vor Ihm \* an allen Tagen des Lebens. Und du, mein Kind, wirst ge­nannt: des Höchsten Prophet! \* Vorangehn wirst du dem Herrn, Ihm bereiten die Wege. Seinem Volke wirst du künden das Heil: \* die Vergebung der Sünden. \
Durch unseres Gottes erbarmen­de Liebe * sucht Er uns heim: der hervorgeht von oben: Um zu erleuchten, die in Finster­nis sitzen und im Schatten des Todes, * um unsere Füße zu len­ken auf die Pfade des Friedens. \
Ehre sei dem Vater und dem Sohne \* und dem Heiligen Geiste; \
Wie es war im Anfang, so auch jetzt und allezeit \* und in Ewigkeit. Amen.],
  )
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Et valde mane una sabbatorum, veniunt ad monumentum, orto iam sole, alleluja.],
      [Und gar frühe, / am ersten Tag nach dem Sabbat, / da kommen sie zum Grab, als eben aufging die Sonne, alleluja.],
    )
  ]
]

#v(4pt)

#abschnitt(licht-strich)[
  #section-title("Postcommunio — Segen — Entlassung", farbe: licht-farbe)
  #v(2pt)
  #block(breakable: false)[
    #bilingue(
      [Pr. Dominus vobiscum. \
A. Et cum spiritu tuo.],
      [Pr. Der Herr sei mit euch. \
A. Und mit deinem Geiste.],
    )
  ]
  #v(1pt)
  #block(breakable: false)[
    #bilingue(
      [Pr. Oremus. Spiritum nobis, Domine, tuae caritatis infunde: ut, quos sacramentis Paschalibus satiasti tua facias pietate concordes. Per Dominum nostrum Jesum Christum, Filium tuum: Qui tecum vivit et regnat in unitate Spiritus Sancti Deus: per omnia sæcula sæculorum. R Amen.],
      [Pr. Lasset uns beten. Gieße uns ein, o Herr, den Geist Deiner Liebe und wie Du uns mit den österlichen Sakramenten gesättigt, so schließe uns huldvoll zusammen in dauernder Eintracht. Durch unsern Herrn Jesus Christus, Deinen Sohn, der mit Dir lebt und herrscht in der Einheit des Heiligen Geistes, Gott von Ewigkeit zu Ewigkeit. R Amen.],
    )
  ]
  #v(2pt)
  #rubrik[Kein Schlussevangelium.]
  #v(4pt)
  #block(breakable: false)[
    #bilingue(
      [℣. Ite, Missa est, allelúia, allelúia.
       ℟. Deo grátias, allelúia, allelúia.],
      [℣. Gehet hin, die Messe ist zu Ende, Halleluja, Halleluja.
       ℟. Dank sei Gott, dem Herrn, Halleluja, Halleluja.],
    )
  ]
]

#strich-state.update(none)

// ═══════════════════════════════════════════════════════════════
// LETZTE SEITE — Aufbau der Osternachtfeier
// ═══════════════════════════════════════════════════════════════

#pagebreak()
#set page(numbering: none)

#v(1fr)
#align(center)[
  #text(size: 8pt, weight: "bold", fill: grau, tracking: 0.8pt)[
    #upper[Aufbau der Osternachtfeier]
  ]
  #v(3pt)
  #line(length: 35%, stroke: 0.3pt + grau)
]
#v(14pt)

#block(width: 100%)[
  #set text(size: 6pt, fill: grau)
  #grid(
    columns: (auto, auto, 1fr),
    column-gutter: 6pt,
    row-gutter: 6pt,

    rect(width: 7pt, height: 7pt, fill: licht-farbe, radius: 1pt), [I], strong[Lucernarium — Lichtfeier],
    [], [], [Feuerweihe · Osterkerze · Prozession · Exsultet],

    rect(width: 7pt, height: 7pt, fill: prophetien-farbe, radius: 1pt), [II], strong[Prophetien — Wortgottesdienst],
    [], [], [Lesung I–IV · Cantica · Orationen],

    rect(width: 7pt, height: 7pt, fill: litanei-farbe, radius: 1pt), [III], strong[Allerheiligenlitanei — Erster Teil],
    [], [], [Kyrie … bis Omnes Sancti],

    rect(width: 7pt, height: 7pt, fill: taufe-farbe, radius: 1pt), [IV], strong[Taufwasserweihe],
    [], [], [Präfation · Eintauchen der Osterkerze · _Sicut cervus_],

    rect(width: 7pt, height: 7pt, fill: versprechen-farbe, radius: 1pt), [V], strong[Erneuerung der Taufversprechen],
    [], [], [Abschwörung · Glaubensbekenntnis · Besprengung],

    rect(width: 7pt, height: 7pt, fill: messe-farbe, radius: 1pt), [VI], strong[Ostermesse],
    [], [], [Litanei II · Gloria! · Epistel · _Alleluia!_ · Evangelium · Opferung · Canon · Kommunion],

    rect(width: 7pt, height: 7pt, fill: licht-farbe, radius: 1pt), [VII], strong[Laudes — Morgengebet],
    [], [], [Psalm 150 · Benedictus · Postcommunio · Segen],
  )
]

#v(18pt)
#line(length: 100%, stroke: 0.2pt + grau)
#v(10pt)

// Besonderheiten gegenüber normaler Messe
#align(center)[
  #text(size: 6.5pt, weight: "bold", fill: grau, tracking: 0.5pt)[
    #upper[Besonderheiten der Osternacht]
  ]
]
#v(8pt)

#block(width: 100%)[
  #set text(size: 5.5pt, fill: grau)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 6pt,
    row-gutter: 3pt,
    [—], [Kein Stufengebet (Ps 42 + Confiteor entfallen)],
    [—], [Kein Introitus (Litanei geht in Kyrie über)],
    [—], [Kein Credo],
    [—], [Kein Offertorium-Vers],
    [—], [Kein Agnus Dei],
    [—], [Kein Schlussevangelium],
    [—], [Gloria mit Glockengeläut und Enthüllung der Bilder],
    [—], [3× Alleluia in aufsteigendem Ton],
    [—], [_Ite, Missa est, allelúia, allelúia_],
    [—], [Laudes direkt an die Messe angeschlossen],
  )
]

#v(1fr)

#align(center)[
  #text(size: 5pt, fill: grau)[
    Latein und Deutsch · Missale Romanum 1962 · Ordo 1955
  ]
]
