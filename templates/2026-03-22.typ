// ═══════════════════════════════════════════════════════════════
// Messe-Booklet: Dominica I Passionis — 22. März 2026
// Format: A5, 8 Seiten, Latein/Deutsch zweispaltig
// Schrift: Ubuntu Sans (schlicht, modern)
// 4 Messteile durch farbige Seitenstreifen an den Abschnitten
//   Grau:        Präliminarie (Asperges)
//   Dunkelblau:  Missa Catechumenorum (Vormesse) — Wort/Taufe
//   Burgunder:   Missa Fidelium (Opfermesse) — Sanguis Christi
//   Violett:     Schlussevangelium — Mysterium
// ═══════════════════════════════════════════════════════════════

#set page(
  paper: "a5",
  binding: left,
  margin: (top: 16mm, bottom: 14mm, inside: 16mm, outside: 11mm),
  numbering: none,
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

// ── Farben (liturgisch) ──

#let prelim-farbe = rgb("#707070")     // Grau — Präliminarie
#let vormesse-farbe = rgb("#1B4F72")   // Dunkelblau — Missa Catechumenorum (Wort/Taufe)
#let opfer-farbe = rgb("#922B21")      // Burgunder — Missa Fidelium (Sanguis Christi)
#let schluss-farbe = rgb("#6C3483")    // Violett — Schlussevangelium (Mysterium)
#let grau = rgb("#3D3D3D")
#let hellgrau = rgb("#F0F0F0")

// ── Liturgische Symbole ──

// Drei Kreuze übereinander (Stirn, Mund, Brust)
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

// Verneigung (Kopf/Oberkörper) — Bogen
#let verneigung = box(
  inset: (x: 1.5pt, y: 0pt),
  baseline: 1pt,
  text(size: 7pt, fill: grau)[⌒],
)

#let fa-icon(code) = text(font: "Font Awesome 6 Free Solid", code)

// Knien — Font Awesome person-praying
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

// Schlichtes lateinisches Kreuz — gerade, symmetrisch
#let lateinkreuz(size: 40pt, farbe: rgb("#5B2C6F")) = {
  let w = size * 0.6
  let h = size
  let t = 2pt
  let qy = h * 0.3
  box(width: w, height: h)[
    // Vertikaler Balken (mittig)
    #place(left, dx: w / 2 - t / 2,
      rect(width: t, height: h, fill: farbe))
    // Horizontaler Balken
    #place(left, dy: qy,
      rect(width: w, height: t, fill: farbe))
  ]
}

// ── Farbige Seitenstreifen mit S/W-unterscheidbaren Mustern ──
// Im Farbdruck: Farbe erkennbar. Im S/W-Druck: Muster unterscheidbar.

#let prelim-strich = stroke(paint: prelim-farbe, thickness: 4pt)                                          // ━━━ durchgezogen
#let vormesse-strich = stroke(paint: vormesse-farbe, thickness: 4pt, dash: (8pt, 3pt))                    // ── ── lang gestrichelt
#let opfer-strich = stroke(paint: opfer-farbe, thickness: 4pt, dash: (2pt, 2pt))                          // ·· ·· kurz (gepunktet)
#let schluss-strich = stroke(paint: schluss-farbe, thickness: 4pt, dash: (6pt, 2pt, 1.5pt, 2pt))          // ─·─· Strich-Punkt

// ── Abschnitts-Block mit Seitenstreifen ──

#let abschnitt(strich, body) = {
  block(
    width: 100%,
    inset: (left: 8pt, top: 0pt, bottom: 0pt, right: 0pt),
    stroke: (left: strich),
  )[#body]
}

// ── Hilfsfunktionen ──

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
    #lateinkreuz(size: 40pt, farbe: rgb("#5B2C6F"))

    #v(10pt)

    #text(size: 6.5pt, fill: grau, tracking: 1.5pt, weight: "bold")[
      #upper[Die Heilige Messe]
    ]

    #v(3pt)
    #line(length: 30%, stroke: 0.3pt + rgb("#5B2C6F"))
    #v(8pt)

    #text(size: 15pt, fill: rgb("#5B2C6F"), weight: "bold", tracking: 0.3pt)[
      Dominica I Passionis
    ]

    #v(3pt)

    #text(size: 9.5pt, fill: grau)[
      Passionssonntag
    ]

    #v(14pt)

    #block(
      width: 70%,
      inset: 8pt,
      radius: 2pt,
      fill: rgb("#E8DAEF").lighten(60%),
    )[
      #align(center)[
        #text(size: 6.5pt, fill: rgb("#5B2C6F"))[
          Beginn der Passionszeit \
          Kreuze und Bilder sind verhüllt \
          Liturgische Farbe: #strong[Violett]
        ]
      ]
    ]

    #v(16pt)

    #text(size: 9pt, weight: "bold")[22. März 2026]

    #v(3pt)

    #text(size: 6.5pt, fill: grau)[
      Außerordentliche Form des Römischen Ritus \
      Missale Romanum 1962
    ]

    #v(16pt)

    // Legende — 4 Messteile
    #block(width: 75%)[
      #set text(size: 5.5pt, fill: grau)
      #grid(
        columns: (auto, 1fr),
        column-gutter: 6pt,
        row-gutter: 3pt,
        rect(width: 10pt, height: 6pt, fill: prelim-farbe, radius: 1pt),
        [Präliminarie — Asperges],
        rect(width: 10pt, height: 6pt, fill: vormesse-farbe, radius: 1pt),
        [Missa Catechumenorum — Vormesse],
        rect(width: 10pt, height: 6pt, fill: opfer-farbe, radius: 1pt),
        [Missa Fidelium — Opfermesse],
        rect(width: 10pt, height: 6pt, fill: schluss-farbe, radius: 1pt),
        [Schlussevangelium],
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
      Latein und Deutsch · Ordinarium und Proprium
    ]
  ]
]

// ═══════════════════════════════════════════════════════════════
// SEITE 2 — PRÄLIMINARIE + BEGINN VORMESSE
// ═══════════════════════════════════════════════════════════════

#pagebreak()

// ── PRÄLIMINARIE (grau) ──
#teil-label("Präliminarie", prelim-farbe)

  #abschnitt(prelim-strich)[
    #section-title(farbe: prelim-farbe)[Asperges — Besprengung]
    #rubrik[Vor dem Hochamt am Sonntag. Priester besprengt die Gemeinde. Gemeinde steht.]
    #v(2pt)

    #bilingue(
      [Aspérges me, Dómine, hyssópo, et mundábor: lavábis me, et super nivem dealbábor.

      ℣. Miserére mei, Deus, secúndum magnam misericórdiam tuam.

      Aspérges me…],

      [Besprenge mich, o Herr, mit Ysop, und ich werde rein; wasche mich, und ich werde weißer als Schnee.

      ℣. Erbarme dich meiner, o Gott, nach deiner großen Barmherzigkeit.

      Besprenge mich…],
    )

    #v(1pt)
    #rubrik[Gloria Patri entfällt in der Passionszeit.]
    #v(3pt)

    #bilingue(
      [Exáudi nos, Dómine sancte, Pater omnípotens, ætérne Deus: et míttere dignéris sanctum Angelum tuum de cælis, qui custódiat, fóveat, prótegat, vísitet atque deféndat omnes habitántes in hoc habitáculo. Per Christum Dóminum nostrum. ℟. Amen.],

      [Erhöre uns, heiliger Herr, allmächtiger Vater, ewiger Gott: und sende gnädig deinen heiligen Engel vom Himmel, der alle, die in diesem Hause wohnen, behüte, nähre, schütze, besuche und verteidige. Durch Christus, unsern Herrn. ℟. Amen.],
    )
  ]

  #v(4pt)

  // ── MISSA CATECHUMENORUM (petrol) ──
  #teil-label("Missa Catechumenorum — Die Vormesse", vormesse-farbe)

  #abschnitt(vormesse-strich)[
    #section-title(farbe: vormesse-farbe)[Stufengebet]
    #rubrik[Psalm 42 (Iudica me) entfällt in der Passionszeit.]
    #v(2pt)

    #text(size: 7pt, style: "italic", fill: vormesse-farbe)[#kreuz In nómine Patris, et Fílii, et Spíritus Sancti. Amen.]
    #v(1pt)
    #rubrik[Confiteor — Priester spricht das Schuldbekenntnis, dann die Gemeinde:]
    #v(2pt)

    #bilingue(
      [Confíteor Deo omnipoténti, beátæ Maríæ semper Vírgini, beáto Michaéli Archángelo, beáto Ioánni Baptístæ, sanctis Apóstolis Petro et Paulo, ómnibus Sanctis, et tibi, Pater: quia peccávi nimis cogitatióne, verbo et ópere: #emph[(schlägt sich dreimal an die Brust)] mea culpa, mea culpa, mea máxima culpa. Ídeo precor beátam Maríam semper Vírginem, beátum Michaélem Archángelum, beátum Ioánnem Baptístam, sanctos Apóstolos Petrum et Paulum, omnes Sanctos, et te, Pater, oráre pro me ad Dóminum Deum nostrum.],

      [Ich bekenne Gott, dem Allmächtigen, der seligen, allzeit reinen Jungfrau Maria, dem heiligen Erzengel Michael, dem heiligen Johannes dem Täufer, den heiligen Aposteln Petrus und Paulus, allen Heiligen und dir, Vater: daß ich viel gesündigt habe in Gedanken, Worten und Werken: #emph[(schlägt sich dreimal an die Brust)] durch meine Schuld, durch meine Schuld, durch meine übergroße Schuld. Darum bitte ich die selige Jungfrau Maria, den heiligen Erzengel Michael, den heiligen Johannes den Täufer, die heiligen Apostel Petrus und Paulus, alle Heiligen und dich, Vater, für mich zu beten bei Gott, unserm Herrn.],
    )

    #v(1pt)
    #rubrik[Priester:]
    #text(size: 6.5pt, style: "italic")[Misereátur vestri omnípotens Deus, et dimíssis peccátis vestris, perdúcat vos ad vitam ætérnam. #strong[℟. Amen.]]
    #v(1pt)
    #text(size: 6.5pt, style: "italic")[Indulgéntiam, #kreuz absolutiónem et remissiónem peccatórum nostrórum tríbuat nobis omnípotens et miséricors Dóminus. #strong[℟. Amen.]]

    #v(4pt)

    #section-title(farbe: vormesse-farbe)[Introitus]
    #rubrik[Gloria Patri entfällt.]
    #v(2pt)

    #bilingue(
      [Iúdica me, Deus, et discérne causam meam de gente non sancta: ab hómine iníquo et dolóso éripe me: quia tu es Deus meus et fortitúdo mea.

      ℣. Emítte lucem tuam et veritátem tuam: ipsa me deduxérunt et adduxérunt in montem sanctum tuum et in tabernácula tua. — Iúdica me…],

      [Richte mich, Gott, und führe meine Sache gegen ein unheiliges Volk; von dem ungerechten und arglistigen Menschen befreie mich; denn du bist mein Gott und meine Stärke.

      ℣. Sende dein Licht und deine Wahrheit; sie sollen mich leiten und führen zu deinem heiligen Berge und zu deinen Zelten. — Richte mich…],
    )

    #v(3pt)
    #section-title(farbe: vormesse-farbe)[Kyrie]
    #align(center)[
      #text(size: 7pt, style: "italic")[
        Kýrie, eléison. (3×) — Christe, eléison. (3×) — Kýrie, eléison. (3×)
      ]
    ]
    #v(1pt)
    #rubrik[Das Gloria entfällt in der Fastenzeit.]
  ]

// ═══════════════════════════════════════════════════════════════
// COLLECTA, LECTIO, GRADUALE, TRACTUS
// ═══════════════════════════════════════════════════════════════

  #abschnitt(vormesse-strich)[
    #section-title(farbe: vormesse-farbe)[Collecta — Tagesgebet]

    #bilingue(
      [Quǽsumus, omnípotens Deus, famíliam tuam propítius réspice: ut, te largiénte, regátur in córpore; et, te servánte, custodiátur in mente. Per Dóminum nostrum… ℟. Amen.],

      [Wir bitten dich, allmächtiger Gott, blicke gnädig auf deine Familie: damit sie durch deine Freigebigkeit am Leibe gelenkt und durch deine Bewahrung im Geiste behütet werde. Durch unsern Herrn… ℟. Amen.],
    )

    #v(3pt)

    #section-title(farbe: vormesse-farbe)[Epistola — Lesung]
    #referenz[Hebr 9, 11–15]
    #h(6pt)
    #rubrik[Gemeinde sitzt.]
    #v(2pt)

    #bilingue(
      [Fratres: Christus assístens Póntifex futurórum bonórum, per ámplius et perféctius tabernáculum non manufáctum, id est, non huius creatiónis: neque per sánguinem hircórum aut vitulórum, sed per próprium sánguinem introívit semel in Sancta, ætérna redemptióne invénta.

      Si enim sanguis hircórum et taurórum, et cinis vítulæ aspérsus inquinátos sanctíficat ad emundatiónem carnis: quanto magis sanguis Christi, qui per Spíritum Sanctum semetípsum óbtulit immaculátum Deo, emundábit consciéntiam nostram ab opéribus mórtuis, ad serviéndum Deo vivénti?

      Et ídeo novi testaménti mediátor est: ut, morte intercedénte, in redemptiónem eárum prævaricatiónum quæ erant sub prióri testaménto, repromissiónem accípiant, qui vocáti sunt, ætérnæ hereditátis, in Christo Iesu, Dómino nostro.],

      [Brüder! Christus ist als Hoherpriester der künftigen Güter erschienen und ist durch das größere und vollkommenere Zelt, das nicht von Menschenhand gemacht, das heißt nicht von dieser Schöpfung ist, auch nicht mit dem Blute von Böcken und Stieren, sondern mit seinem eigenen Blut ein für allemal in das Heiligtum eingegangen und hat eine ewige Erlösung bewirkt.

      Denn wenn das Blut von Böcken und Stieren und die Asche einer Kuh die Unreinen besprengt und zur Reinheit des Fleisches heiligt: wieviel mehr wird das Blut Christi, der sich selbst durch den Heiligen Geist als makelloses Opfer Gott dargebracht hat, unser Gewissen reinigen von toten Werken, damit wir dem lebendigen Gott dienen?

      Und darum ist er Mittler eines neuen Bundes, damit durch seinen Tod, der zur Erlösung von den Übertretungen unter dem ersten Bund geschehen ist, die Berufenen die verheißene ewige Erbschaft empfangen, in Christus Jesus, unserm Herrn.],
    )

    #v(3pt)

    #section-title(farbe: vormesse-farbe)[Graduale]

    #bilingue(
      [Eripe me, Dómine, de inimícis meis: doce me fácere voluntátem tuam.

      ℣. Liberátor meus, Dómine, de géntibus iracúndis: ab insurgéntibus in me exaltábis me: a viro iníquo erípies me.],

      [Entreiße mich, o Herr, meinen Feinden; lehre mich, deinen Willen tun.

      ℣. Mein Befreier, o Herr, von den zornigen Völkern: über die, die sich gegen mich erheben, wirst du mich erhöhen; dem ungerechten Manne wirst du mich entreißen.],
    )

    #v(3pt)
    #section-title(farbe: vormesse-farbe)[Tractus]
    #bilingue(
      [Sæpe expugnavérunt me a iuventúte mea. ℣. Dicat nunc Israël: sæpe expugnavérunt me a iuventúte mea. ℣. Etenim non potuérunt mihi: supra dorsum meum fabricavérunt peccatóres. ℣. Prolongavérunt iniquitátes suas: Dóminus iustus concídit cervíces peccatórum.],

      [Oft haben sie mich bedrängt von Jugend an. ℣. So spreche nun Israel: Oft haben sie mich bedrängt von Jugend an. ℣. Doch sie vermochten nichts gegen mich; auf meinem Rücken schmiedeten die Sünder. ℣. Sie zogen ihre Bosheit in die Länge; der gerechte Herr zerschlug den Nacken der Sünder.],
    )
  ]

// ═══════════════════════════════════════════════════════════════
// EVANGELIUM
// ═══════════════════════════════════════════════════════════════

  #abschnitt(vormesse-strich)[
    #section-title(farbe: vormesse-farbe)[Evangelium]
    #referenz[Io 8, 46–59]
    #h(6pt)
    #rubrik[Gemeinde steht. #dreikreuz Kreuzzeichen auf Stirn, Mund und Brust.]
    #v(2pt)

    #bilingue(
      [In illo témpore: Dicébat Iesus turbis Iudæórum: Quis ex vobis árguet me de peccáto? Si veritátem dico vobis, quare non créditis mihi? Qui ex Deo est, verba Dei audit. Proptérea vos non audítis, quia ex Deo non estis.

      Respondérunt ergo Iudǽi et dixérunt ei: Nonne bene dícimus nos, quia Samaritánus es tu, et dæmónium habes?

      Respóndit Iesus: Ego dæmónium non hábeo, sed honorífico Patrem meum, et vos inhonorástis me. Ego autem non quæro glóriam meam: est qui quærat et iúdicet. Amen, amen, dico vobis: si quis sermónem meum serváverit, mortem non vidébit in ætérnum.

      Dixérunt ergo Iudǽi: Nunc cognóvimus quia dæmónium habes. Abraham mórtuus est et Prophétæ, et tu dicis: Si quis sermónem meum serváverit, non gustábit mortem in ætérnum. Numquid tu maior es patre nostro Abraham, qui mórtuus est? Et Prophétæ mórtui sunt. Quem teípsum facis?

      Respóndit Iesus: Si ego glorífico meípsum, glória mea nihil est: est Pater meus, qui gloríficat me, quem vos dícitis quia Deus vester est, et non cognovístis eum: ego autem novi eum. Et si díxero quia non scio eum, ero símilis vobis, mendax. Sed scio eum et sermónem eius servo.

      Abraham pater vester exsultávit ut vidéret diem meum: vidit et gavísus est.

      Dixérunt ergo Iudǽi ad eum: Quinquagínta annos nondum habes, et Abraham vidísti?

      Dixit eis Iesus: Amen, amen, dico vobis, ántequam Abraham fíeret, #strong[ego sum.]

      Tulérunt ergo lápides, ut iácerent in eum: Iesus autem abscóndit se et exívit de templo.],

      [In jener Zeit sprach Jesus zu den Scharen der Juden: Wer von euch kann mich einer Sünde beschuldigen? Wenn ich die Wahrheit sage, warum glaubt ihr mir nicht? Wer aus Gott ist, hört Gottes Wort. Darum hört ihr nicht, weil ihr nicht aus Gott seid.

      Da antworteten die Juden und sprachen zu ihm: Sagen wir nicht mit Recht, daß du ein Samariter bist und einen Teufel hast?

      Jesus antwortete: Ich habe keinen Teufel, sondern ich ehre meinen Vater, und ihr verunehrt mich. Ich aber suche nicht meine Ehre; es ist Einer, der sie sucht und richtet. Wahrlich, wahrlich, ich sage euch: Wenn jemand mein Wort bewahrt, wird er den Tod nicht schauen in Ewigkeit.

      Da sagten die Juden: Jetzt erkennen wir, daß du einen Teufel hast. Abraham ist gestorben und die Propheten, und du sagst: Wenn jemand mein Wort bewahrt, wird er den Tod nicht kosten in Ewigkeit. Bist du etwa größer als unser Vater Abraham, der gestorben ist? Auch die Propheten sind gestorben. Für wen gibst du dich aus?

      Jesus antwortete: Wenn ich mich selbst verherrliche, ist meine Herrlichkeit nichts. Es ist mein Vater, der mich verherrlicht, von dem ihr sagt, er sei euer Gott; und doch kennt ihr ihn nicht. Ich aber kenne ihn. Und wenn ich sagte, ich kenne ihn nicht, wäre ich ein Lügner wie ihr. Aber ich kenne ihn und halte sein Wort.

      Abraham, euer Vater, jubelte, daß er meinen Tag sehen sollte; er sah ihn und freute sich.

      Da sagten die Juden zu ihm: Du bist noch nicht fünfzig Jahre alt und hast Abraham gesehen?

      Jesus sprach zu ihnen: Wahrlich, wahrlich, ich sage euch: Ehe Abraham ward, #strong[bin ich.]

      Da hoben sie Steine auf, um auf ihn zu werfen. Jesus aber verbarg sich und ging aus dem Tempel hinaus.],
    )
  ]

// ═══════════════════════════════════════════════════════════════
// PREDIGT, CREDO → ÜBERGANG OPFERMESSE
// ═══════════════════════════════════════════════════════════════

  #abschnitt(vormesse-strich)[
    #section-title(farbe: vormesse-farbe)[Predigt]
    #rubrik[Gemeinde sitzt. Der Priester predigt über die Texte des Tages.]
  ]

  #v(4pt)

  #abschnitt(vormesse-strich)[
    #section-title(farbe: vormesse-farbe)[Credo — Großes Glaubensbekenntnis]
    #rubrik[Gemeinde steht.]
    #v(2pt)

    #bilingue(
      [Credo in unum Deum, Patrem omnipoténtem, factórem cæli et terræ, visibílium ómnium et invisibílium.

      Et in unum Dóminum Iesum Christum, Fílium Dei unigénitum. Et ex Patre natum ante ómnia sǽcula. Deum de Deo, lumen de lúmine, Deum verum de Deo vero. Génitum, non factum, consubstantiálem Patri: per quem ómnia facta sunt. Qui propter nos hómines et propter nostram salútem descéndit de cælis.

      #kniebeuge Et incarnátus est de Spíritu Sancto ex María Vírgine: #strong[et homo factus est.]

      #stehen Crucifíxus étiam pro nobis: sub Póntio Piláto passus et sepúltus est.

      Et resurréxit tértia die, secúndum Scriptúras. Et ascéndit in cælum: sedet ad déxteram Patris. Et íterum ventúrus est cum glória iudicáre vivos et mórtuos: cuius regni non erit finis.

      Et in Spíritum Sanctum, Dóminum et vivificántem: qui ex Patre Filióque procédit. Qui cum Patre et Fílio simul adorátur et conglorificátur: qui locútus est per Prophétas.

      Et unam sanctam cathólicam et apostólicam Ecclésiam. Confíteor unum baptísma in remissiónem peccatórum. Et exspécto resurrectiónem mortuórum. #kreuz Et vitam ventúri sǽculi. Amen.],

      [Ich glaube an den einen Gott, den allmächtigen Vater, Schöpfer des Himmels und der Erde, aller sichtbaren und unsichtbaren Dinge.

      Und an den einen Herrn Jesus Christus, Gottes eingeborenen Sohn. Er ist aus dem Vater geboren vor aller Zeit. Gott von Gott, Licht vom Lichte, wahrer Gott vom wahren Gott. Gezeugt, nicht geschaffen, eines Wesens mit dem Vater: durch ihn ist alles geschaffen. Für uns Menschen und um unseres Heiles willen ist er vom Himmel herabgestiegen.

      #kniebeuge Und ist Fleisch geworden durch den Heiligen Geist aus Maria, der Jungfrau, #strong[und ist Mensch geworden.]

      #stehen Gekreuzigt wurde er sogar für uns; unter Pontius Pilatus hat er gelitten und ist begraben worden.

      Und ist auferstanden am dritten Tage gemäß der Schrift. Und ist aufgefahren in den Himmel; er sitzt zur Rechten des Vaters. Und er wird wiederkommen in Herrlichkeit, zu richten die Lebenden und die Toten; seines Reiches wird kein Ende sein.

      Und an den Heiligen Geist, den Herrn und Lebensspender, der vom Vater und dem Sohne ausgeht. Der mit dem Vater und dem Sohne zugleich angebetet und verherrlicht wird; der gesprochen hat durch die Propheten.

      Und die eine, heilige, katholische und apostolische Kirche. Ich bekenne die eine Taufe zur Vergebung der Sünden. Und ich erwarte die Auferstehung der Toten. #kreuz Und das Leben der kommenden Welt. Amen.],
    )
  ]

  // ── Übergang zur Opfermesse ──
  #v(4pt)
  #teil-label("Missa Fidelium — Die Opfermesse", opfer-farbe)

  #abschnitt(opfer-strich)[
    #section-title(farbe: opfer-farbe)[Offertorium — Opferung]
    #rubrik[Gemeinde sitzt. Der Priester bereitet die Gaben am Altar.]
    #v(2pt)

    #bilingue(
      [Confitébor tibi, Dómine, in toto corde meo: retríbue servo tuo: vivam, et custódiam sermónes tuos: vivífica me secúndum verbum tuum, Dómine.],

      [Ich will dich preisen, o Herr, aus ganzem Herzen; vergilt deinem Knecht: laß mich leben, und ich will deine Worte bewahren; belebe mich nach deinem Wort, o Herr.],
    )
  ]

// ═══════════════════════════════════════════════════════════════
// SECRETA → PATER NOSTER
// ═══════════════════════════════════════════════════════════════

  #abschnitt(opfer-strich)[
    #section-title(farbe: opfer-farbe)[Secreta — Stillgebet]

    #bilingue(
      [Hæc múnera, quǽsumus, Dómine, et víncula nostræ pravitátis absólvant, et tuæ nobis misericórdiæ dona concílient. Per Dóminum nostrum… ℟. Amen.],

      [Diese Gaben, so bitten wir, o Herr, mögen die Fesseln unserer Verkehrtheit lösen und uns die Geschenke deiner Barmherzigkeit gewinnen. Durch unsern Herrn… ℟. Amen.],
    )

    #v(3pt)
    #section-title(farbe: opfer-farbe)[Præfatio de Sancta Cruce]
    #rubrik[Präfation vom Heiligen Kreuz. Gemeinde steht.]
    #v(1pt)
    #rubrik[Der Priester singt die Präfation. Die Gemeinde antwortet und stimmt ein:]
    #v(3pt)

    #section-title(farbe: opfer-farbe)[Sanctus]

    #bilingue(
      [Sanctus, Sanctus, Sanctus Dóminus Deus Sábaoth.
      Pleni sunt cæli et terra glória tua.
      Hosánna in excélsis.
      Benedíctus qui venit in nómine Dómini.
      Hosánna in excélsis.],

      [Heilig, heilig, heilig, Herr, Gott der Heerscharen.
      Himmel und Erde sind erfüllt von deiner Herrlichkeit.
      Hosanna in der Höhe.
      Hochgelobt sei, der da kommt im Namen des Herrn.
      Hosanna in der Höhe.],
    )

    #v(4pt)

    #section-title(farbe: opfer-farbe)[Canon Missæ — Wandlung]
    #rubrik[Gemeinde kniet. Der Priester betet den Canon still.]
    #v(3pt)

    #align(center)[
      #block(
        width: 88%,
        inset: 8pt,
        radius: 2pt,
        fill: rgb("#EBEBEB"),
      )[
        #text(size: 6.5pt, fill: opfer-farbe)[
          #kreuz #strong[Wandlung] #kreuz — Der Priester spricht die Wandlungsworte über Brot und Wein. \
          #verneigung Bei der Elevation (Emporheben) von Hostie und Kelch: Haupt neigen, aufblicken. \
          Ministrant läutet die Glocke (dreimal je Elevation).
        ]
      ]
    ]

    #v(4pt)

    #section-title(farbe: opfer-farbe)[Pater Noster]
    #rubrik[Gemeinde kniet.]
    #v(2pt)

    #bilingue(
      [Pater noster, qui es in cælis: sanctificétur nomen tuum; advéniat regnum tuum; fiat volúntas tua, sicut in cælo et in terra. Panem nostrum quotidiánum da nobis hódie; et dimítte nobis débita nostra, sicut et nos dimíttimus debitóribus nostris; et ne nos indúcas in tentatiónem.

      #strong[℟. Sed líbera nos a malo.]],

      [Vater unser, der du bist im Himmel, geheiligt werde dein Name; dein Reich komme; dein Wille geschehe, wie im Himmel so auf Erden. Unser tägliches Brot gib uns heute; und vergib uns unsere Schuld, wie auch wir vergeben unsern Schuldigern; und führe uns nicht in Versuchung.

      #strong[℟. Sondern erlöse uns von dem Bösen.]],
    )

    #v(3pt)

    #section-title(farbe: opfer-farbe)[Agnus Dei]
    #rubrik[Gemeinde kniet.]
    #v(2pt)

    #bilingue(
      [Agnus Dei, qui tollis peccáta mundi: miserére nobis.
      Agnus Dei, qui tollis peccáta mundi: miserére nobis.
      Agnus Dei, qui tollis peccáta mundi: dona nobis pacem.],

      [Lamm Gottes, du nimmst hinweg die Sünden der Welt: erbarme dich unser.
      Lamm Gottes, du nimmst hinweg die Sünden der Welt: erbarme dich unser.
      Lamm Gottes, du nimmst hinweg die Sünden der Welt: gib uns den Frieden.],
    )

    #v(3pt)
    #rubrik[Priester zeigt die Hostie und spricht dreimal:]
    #v(2pt)

    #bilingue(
      [#verneigung Dómine, non sum dignus, ut intres sub tectum meum: sed tantum dic verbo, et sanábitur ánima mea. #emph[(3×)]],

      [#verneigung Herr, ich bin nicht würdig, daß du eingehst unter mein Dach; aber sprich nur ein Wort, so wird meine Seele gesund. #emph[(3×)]],
    )

    #v(2pt)
    #rubrik[Kommunionempfang: kniend, auf die Zunge.]
  ]

// ═══════════════════════════════════════════════════════════════
// COMMUNIO → SEGEN + SCHLUSSEVANGELIUM
// ═══════════════════════════════════════════════════════════════

  #abschnitt(opfer-strich)[
    #section-title(farbe: opfer-farbe)[Communio — Kommunion]

    #bilingue(
      [Hoc corpus, quod pro vobis tradétur: hic calix novi testaménti est in meo sánguine, dicit Dóminus: hoc fácite, quotiescúmque súmitis, in meam commemoratiónem.],

      [Dies ist mein Leib, der für euch hingegeben wird; dieser Kelch ist der neue Bund in meinem Blute, spricht der Herr; tut dies, sooft ihr ihn empfangt, zu meinem Gedächtnis.],
    )

    #v(4pt)

    #block(breakable: false)[
    #section-title(farbe: opfer-farbe)[Postcommunio — Schlussgebet]

    #bilingue(
      [Adésto nobis, Dómine Deus noster: et, quos tuis mystériis recreásti, perpétuis defénde subsídiis. Per Dóminum nostrum… ℟. Amen.],

      [Steh uns bei, Herr, unser Gott, und die du durch deine Geheimnisse erquickt hast, die verteidige mit immerwährender Hilfe. Durch unsern Herrn… ℟. Amen.],
    )
    ]

    #v(4pt)

    #block(breakable: false)[
    #section-title(farbe: opfer-farbe)[Entlassung und Segen]
    #rubrik[#kniebeuge Gemeinde kniet für den Segen.]
    #v(2pt)

    #bilingue(
      [℣. Ite, Missa est. \
      #strong[℟. Deo grátias.] \
      #v(2pt)
      #kniebeuge #kreuz Benedícat vos omnípotens Deus, Pater, et Fílius, et Spíritus Sanctus. ℟. Amen.],
      [℣. Gehet hin, ihr seid entlassen. \
      #strong[℟. Gott sei Dank.] \
      #v(2pt)
      #kniebeuge #kreuz Es segne euch der allmächtige Gott, der Vater und der Sohn und der Heilige Geist. ℟. Amen.],
    )
    ]
  ]

  #v(6pt)

  // ── SCHLUSSEVANGELIUM (lila) ──
  #teil-label("Schlussevangelium", schluss-farbe)

  #abschnitt(schluss-strich)[
    #section-title(farbe: schluss-farbe)[Letztes Evangelium — Johannes-Prolog]
    #referenz[Io 1, 1–14]
    #v(2pt)

    #bilingue(
      [In princípio erat Verbum, et Verbum erat apud Deum, et Deus erat Verbum. Hoc erat in princípio apud Deum. Ómnia per ipsum facta sunt: et sine ipso factum est nihil, quod factum est: in ipso vita erat, et vita erat lux hóminum: et lux in ténebris lucet, et ténebræ eam non comprehendérunt.

      Fuit homo missus a Deo, cui nomen erat Ioánnes. Hic venit in testimónium, ut testimónium perhibéret de lúmine, ut omnes créderent per illum. Non erat ille lux, sed ut testimónium perhibéret de lúmine.

      Erat lux vera, quæ illúminat omnem hóminem veniéntem in hunc mundum. In mundo erat, et mundus per ipsum factus est, et mundus eum non cognóvit. In própria venit, et sui eum non recepérunt. Quotquot autem recepérunt eum, dedit eis potestátem fílios Dei fíeri, his, qui credunt in nómine eius: qui non ex sanguínibus, neque ex voluntáte carnis, neque ex voluntáte viri, sed ex Deo nati sunt.

      #kniebeuge #strong[Et Verbum caro factum est,] et habitávit in nobis: et vídimus glóriam eius, glóriam quasi Unigéniti a Patre, plenum grátiæ et veritátis.],

      [Im Anfang war das Wort, und das Wort war bei Gott, und Gott war das Wort. Dieses war im Anfang bei Gott. Alles ist durch dasselbe gemacht, und ohne dasselbe ist nichts gemacht, was gemacht ist. In ihm war das Leben, und das Leben war das Licht der Menschen. Und das Licht leuchtet in der Finsternis, und die Finsternis hat es nicht erfaßt.

      Es war ein Mensch, von Gott gesandt, sein Name war Johannes. Dieser kam zum Zeugnis, um Zeugnis zu geben vom Lichte, damit alle durch ihn glaubten. Er war nicht das Licht, sondern er sollte Zeugnis geben vom Lichte.

      Es war das wahre Licht, das jeden Menschen erleuchtet, der in diese Welt kommt. Er war in der Welt, und die Welt ist durch ihn gemacht, und die Welt hat ihn nicht erkannt. Er kam in sein Eigentum, und die Seinen nahmen ihn nicht auf. Allen aber, die ihn aufnahmen, gab er Macht, Kinder Gottes zu werden, denen, die an seinen Namen glauben, die nicht aus dem Blute, noch aus dem Willen des Fleisches, noch aus dem Willen des Mannes, sondern aus Gott geboren sind.

      #kniebeuge #strong[Und das Wort ist Fleisch geworden] und hat unter uns gewohnt; und wir haben seine Herrlichkeit gesehen, die Herrlichkeit des Eingeborenen vom Vater, voll der Gnade und Wahrheit.],
    )
  ]

  #v(2pt)
  #rubrik[Leoninische Gebete nach der stillen Messe \(3× Ave Maria, Salve Regina, Oratio\).]

// ═══════════════════════════════════════════════════════════════
// SEITE 8 — AUFBAU DER HEILIGEN MESSE
// ═══════════════════════════════════════════════════════════════

#pagebreak()
#page()[
  #section-title[Aufbau der Heiligen Messe]
  #v(0pt)

  #set text(size: 6pt)

  // Legende Ordinarium / Proprium
  #block(
    width: 100%,
    inset: (x: 5pt, y: 3pt),
    radius: 1.5pt,
    fill: hellgrau,
  )[
    #text(size: 5.5pt)[
      #strong[O] = Ordinarium #text(fill: grau)[(gleichbleibend)] #h(6pt)
      #strong[P] = Proprium #text(fill: grau)[(wechselt mit dem Kirchenjahr)] #h(6pt)
      #strong[()] = entfällt je nach Tag
    ]
  ]

  #v(3pt)

  // ── 1. Präliminarie ──
  #abschnitt(prelim-strich)[
    #text(size: 6.5pt, weight: "bold", fill: prelim-farbe)[1 · Präliminarie]
    #v(1pt)
    #grid(
      columns: (14pt, 1fr),
      row-gutter: 1.5pt,
      strong[O], [Asperges — Besprengung mit Weihwasser #text(fill: grau)[(nur sonntags)]],
    )
  ]

  #v(3pt)

  // ── 2. Missa Catechumenorum ──
  #abschnitt(vormesse-strich)[
    #text(size: 6.5pt, weight: "bold", fill: vormesse-farbe)[2 · Missa Catechumenorum — Die Vormesse]
    #v(1pt)
    #grid(
      columns: (14pt, 1fr),
      row-gutter: 1.5pt,
      strong[O], [Stufengebet (Psalm 42) mit Confiteor — #stehen],
      strong[P], [Introitus — Eingangsgesang],
      strong[O], [Kyrie eleison],
      strong[(O)], [Gloria — #text(fill: grau)[entfällt in Advent, Septuagesima, Fastenzeit, Vigilien, Bitt- u. Quatembertagen]],
      strong[P], [Collecta — Tagesgebet],
      strong[P], [Epistel — Lesung (Apostelbriefe / AT) — #kniebeuge sitzen],
      strong[P], [Graduale / Tractus / Alleluja — #kniebeuge sitzen],
      strong[P], [Evangelium — #stehen #dreikreuz],
      [], [Predigt],
      strong[(O)], [Credo — Glaubensbekenntnis — #stehen #text(fill: grau)[(an Sonn- u. Festtagen)]],
    )
  ]

  #v(3pt)

  // ── 3. Missa Fidelium ──
  #abschnitt(opfer-strich)[
    #text(size: 6.5pt, weight: "bold", fill: opfer-farbe)[3 · Missa Fidelium — Die Opfermesse]
    #v(1pt)
    #grid(
      columns: (14pt, 1fr),
      row-gutter: 1.5pt,
      strong[P], [Offertorium — Opferungsvers — #kniebeuge sitzen],
      strong[P], [Secreta — Stillgebet],
      strong[O], [Präfation — #stehen],
      strong[O], [Sanctus — #kniebeuge knien],
      strong[O], [Canon Missae — Wandlung (Konsekration) — #kreuz #kniebeuge knien],
      strong[O], [Pater Noster — Vaterunser],
      strong[O], [Agnus Dei],
      strong[O], [Domine, non sum dignus — 3× Brust klopfen],
      strong[P], [Communio — Kommunionvers],
      strong[P], [Postcommunio — Schlussgebet],
      strong[O], [Ite, Missa est — Entlassung · Segen — #kniebeuge knien],
    )
  ]

  #v(3pt)

  // ── 4. Schlussevangelium ──
  #abschnitt(schluss-strich)[
    #text(size: 6.5pt, weight: "bold", fill: schluss-farbe)[4 · Schlussevangelium]
    #v(1pt)
    #grid(
      columns: (14pt, 1fr),
      row-gutter: 1.5pt,
      strong[O], [Johannesprolog (Joh 1,1–14) — #stehen · #kniebeuge bei „Et Verbum caro factum est"],
      strong[O], [Leoninische Gebete #text(fill: grau)[(3× Ave Maria, Salve Regina, Gebet zum Hl. Michael)]],
    )
  ]

  #v(4pt)

  // ── Antworten der Gemeinde (kompakt) ──
  #section-title[Antworten der Gemeinde]
  #v(0pt)

  #grid(
    columns: (1fr, 1fr),
    column-gutter: 6pt,
    row-gutter: 2pt,
    [#strong[℣.] Dóminus vobíscum.], [#strong[℟.] Et cum spíritu tuo.],
    [#strong[℣.] Orémus. #emph[(Gebet)]], [#strong[℟.] Amen.],
    [#strong[℣.] Per ómnia sǽcula sæculórum.], [#strong[℟.] Amen.],
    [#strong[℣.] Sursum corda.], [#strong[℟.] Habémus ad Dóminum.],
    [#strong[℣.] Grátias agámus Dómino Deo nostro.], [#strong[℟.] Dignum et iustum est.],
    [#strong[℣.] Ite, Missa est.], [#strong[℟.] Deo grátias.],
  )

  #v(1fr)

  #line(length: 100%, stroke: 0.3pt + luma(200))
  #v(2pt)

  #align(center)[
    #text(size: 5pt, fill: grau)[
      Messe-Booklet · Außerordentliche Form · Missale Romanum 1962 \
      Texte nach dem Schott-Messbuch · Zusammengestellt als Hilfe für die Mitfeier
    ]
  ]
]
