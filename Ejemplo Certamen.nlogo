breed [walkers walker]

walkers-own [tpM1 tpM2 poS tp tpp pos1 pos2]
;
;
;
;
patches-own [tpp1 tpp2]
globals [tiempo posiciones final ite ite2 max1 max2 max3]

to setup
  ca
  nodos
  create-walkers (P1 + P2 + P3 + P4 + P5 + P6 + P7 + P8 + P9 + P10 + P11 + P12) / Lote_min [
    set color white
    move-to patch 1 0
    set size 0.5 set heading 90
    set label who
  ]
  diferenciacion
  posicion
  reset-ticks
end

to nodos
  ask patch 1 0 [set pcolor blue set plabel "M1" set plabel-color white set tpp1 1 set tpp2 2]
  ask patch 3 2 [set pcolor blue set plabel "M2" set plabel-color white set tpp1 3 set tpp2 8 set pcolor orange]
  ask patch 3 -2 [set pcolor blue set plabel "M4" set plabel-color white set tpp1 3 set tpp2 8 set pcolor orange]
  ask patch 3 0 [set pcolor blue set plabel "M3" set plabel-color white set tpp1 3 set tpp2 8 set pcolor orange]
  ask patch 5 0 [set pcolor blue set plabel "B0" set plabel-color white]
end

to diferenciacion
  if P1 > 0 [ask n-of (P1 / Lote_min) walkers with [color = white] [set color red set tpM1 T_P1_M1 set tpM2 T_P1_M2]]
  if P2 > 0 [ask n-of (P2 / Lote_min) walkers with [color = white] [set color green set tpM1 T_P2_M1 set tpM2 T_P2_M2]]
  if P3 > 0 [ask n-of (P3 / Lote_min) walkers with [color = white] [set color blue set tpM1 T_P3_M1 set tpM2 T_P3_M2]]
  if P4 > 0 [ask n-of (P4 / Lote_min) walkers with [color = white] [set color yellow set tpM1 T_P4_M1 set tpM2 T_P4_M2]]
  if P5 > 0 [ask n-of (P5 / Lote_min) walkers with [color = white] [set color pink set tpM1 T_P5_M1 set tpM2 T_P5_M2]]
  if P6 > 0 [ask n-of (P6 / Lote_min) walkers with [color = white] [set color brown set tpM1 T_P6_M1 set tpM2 T_P6_M2]]
  if P7 > 0 [ask n-of (P7 / Lote_min) walkers with [color = white] [set color lime set tpM1 T_P7_M1 set tpM2 T_P7_M2]]
  if P8 > 0 [ask n-of (P8 / Lote_min) walkers with [color = white] [set color cyan set tpM1 T_P8_M1 set tpM2 T_P8_M2]]
  if P9 > 0 [ask n-of (P9 / Lote_min) walkers with [color = white] [set color sky set tpM1 T_P9_M1 set tpM2 T_P9_M2]]
  if P10 > 0 [ask n-of (P10 / Lote_min) walkers with [color = white] [set color violet set tpM1 T_P10_M1 set tpM2 T_P10_M2]]
  if P11 > 0 [ask n-of (P11 / Lote_min) walkers with [color = white] [set color magenta set tpM1 T_P11_M1 set tpM2 T_P11_M2]]
  if P12 > 0 [ask n-of (P12 / Lote_min) walkers with [color = white] [set color gray set tpM1 T_P12_M1 set tpM2 T_P12_M2]]
end

to go
  ifelse count turtles-on patches with [pcolor = orange] = count turtles [

    ;show max [tp] of walkers
    set final max [tp] of walkers
    makespan
    TMFin
    ask turtles [move-to patch 1 0 set tp 0 set tpp 0 set tiempo 0] posicion ;show poS
  ][

    ask walkers with [min [poS] of turtles-on patches with [plabel = "M1"] = poS][
      set tp tiempo
      ifelse tpp = round(tpM1 + (tpM1 * (1 - Tasa_M1))) [analisis] [set tiempo tiempo + 1 set tpp tpp + 1]

  ]]

  tick
end

to analisis
  ifelse not any? walkers-on patch 3 2 [move-to patch 3 2 set tp (tp + round(tpM2 + (tpM2 * (1 - Tasa_M2))))][
    ifelse not any? walkers-on patch 3 0 [move-to patch 3 0 set tp (tp + round(tpM2 + (tpM2 * (1 - Tasa_M3))))][
      ifelse not any? walkers-on patch 3 -2 [move-to patch 3 -2 set tp (tp + round(tpM2 + (tpM2 * (1 - Tasa_M4))))] [decision]]
  ]
end

to decision
  ifelse tp >= min [tp] of walkers-on patches with [pcolor = orange] [
    move-to min-one-of walkers-on patches with [pcolor = orange] [tp]
    if plabel = "M2" [set tp (tp + round(tpM2 + (tpM2 * (1 - Tasa_M2))))]
    if plabel = "M3" [set tp (tp + round(tpM2 + (tpM2 * (1 - Tasa_M3))))]
    if plabel = "M4" [set tp (tp + round(tpM2 + (tpM2 * (1 - Tasa_M4))))]
    ask other walkers-here [set tp max [tp] of walkers-here]
  ][
    move-to min-one-of walkers-on patches with [pcolor = orange] [tp]
    if plabel = "M2" [set tp (max [tp] of other walkers-here + round(tpM2 + (tpM2 * (1 - Tasa_M2))))]
    if plabel = "M3" [set tp (max [tp] of other walkers-here + round(tpM2 + (tpM2 * (1 - Tasa_M3))))]
    if plabel = "M4" [set tp (max [tp] of other walkers-here + round(tpM2 + (tpM2 * (1 - Tasa_M4))))]
    ask other walkers-here [set tp max [tp] of walkers-here]
  ]
end

to posicion
  if funcion = "Entrenar" [
    let aux3 0
    set posiciones shuffle (n-values count walkers [i -> i])
    foreach [who] of walkers [x -> ask walker x [set poS item aux3 posiciones set aux3 aux3 + 1]]
  ]
  if funcion = "Makespan" [ask turtles [set poS pos1]]
  if funcion = "Tiempo Medio Finalizacion" [ask turtles [set poS pos2]]
end

to makespan
  set ite (sentence ite final) set ite remove 0 ite ;https://ccl.northwestern.edu/netlogo/docs/dictionary.html#se
  show ite ;debugging
  if min ite = final [ask turtles [set pos1 poS]]
end

to TMFin
  ask turtles-on patch 3 2 [set max1 ((max [tp] of walkers-here) / count walkers-here)]
  ask turtles-on patch 3 0 [set max2 ((max [tp] of walkers-here) / count walkers-here)]
  ask turtles-on patch 3 -2 [set max3 ((max [tp] of walkers-here) / count walkers-here)]

  set ite2 (se ite2 precision ((max1 + max2 + max3) / 3) 3) set ite2 remove 0 ite2
  if min ite2 = precision ((max1 + max2 + max3) / 3) 3 [ask turtles [set pos2 poS]]
end

to nueva_demanda
  create-walkers (nP1 + nP2 + nP3 + nP4 + nP5 + nP6 + nP7 + nP8 + nP9 + nP10 + nP11 + nP12) / Lote_min [
    set color white
    move-to patch 1 0
    set size 0.5 set heading 90
    set label who
  ]
  diferenciacion2
  posicion
end

to diferenciacion2
  if nP1 > 0 [ask n-of (nP1 / Lote_min) walkers with [color = white] [set color red set tpM1 T_P1_M1 set tpM2 T_P1_M2]]
  if nP2 > 0 [ask n-of (nP2 / Lote_min) walkers with [color = white] [set color green set tpM1 T_P2_M1 set tpM2 T_P2_M2]]
  if nP3 > 0 [ask n-of (nP3 / Lote_min) walkers with [color = white] [set color blue set tpM1 T_P3_M1 set tpM2 T_P3_M2]]
  if nP4 > 0 [ask n-of (nP4 / Lote_min) walkers with [color = white] [set color yellow set tpM1 T_P4_M1 set tpM2 T_P4_M2]]
  if nP5 > 0 [ask n-of (nP5 / Lote_min) walkers with [color = white] [set color pink set tpM1 T_P5_M1 set tpM2 T_P5_M2]]
  if nP6 > 0 [ask n-of (nP6 / Lote_min) walkers with [color = white] [set color brown set tpM1 T_P6_M1 set tpM2 T_P6_M2]]
  if nP7 > 0 [ask n-of (nP7 / Lote_min) walkers with [color = white] [set color lime set tpM1 T_P7_M1 set tpM2 T_P7_M2]]
  if nP8 > 0 [ask n-of (nP8 / Lote_min) walkers with [color = white] [set color cyan set tpM1 T_P8_M1 set tpM2 T_P8_M2]]
  if nP9 > 0 [ask n-of (nP9 / Lote_min) walkers with [color = white] [set color sky set tpM1 T_P9_M1 set tpM2 T_P9_M2]]
  if nP10 > 0 [ask n-of (nP10 / Lote_min) walkers with [color = white] [set color violet set tpM1 T_P10_M1 set tpM2 T_P10_M2]]
  if nP11 > 0 [ask n-of (nP11 / Lote_min) walkers with [color = white] [set color magenta set tpM1 T_P11_M1 set tpM2 T_P11_M2]]
  if nP12 > 0 [ask n-of (nP12 / Lote_min) walkers with [color = white] [set color gray set tpM1 T_P12_M1 set tpM2 T_P12_M2]]
end

to posicion2
  if funcion = "Entrenar" [
    let aux3 0
    set posiciones shuffle (n-values count walkers [i -> i])
    foreach [who] of walkers [x -> ask walker x [set poS item aux3 posiciones set aux3 aux3 + 1]]
  ]
  if funcion = "Makespan" [ask turtles [set poS pos1]]
  if funcion = "Tiempo Medio Finalizacion" [ask turtles [set poS pos2]]
end
@#$#@#$#@
GRAPHICS-WINDOW
10
10
528
409
-1
-1
30.0
1
10
1
1
1
0
1
1
1
-8
8
-6
6
0
0
1
ticks
30.0

INPUTBOX
533
12
688
72
Lote_min
100.0
1
0
Number

BUTTON
699
13
762
46
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
772
13
835
46
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
846
15
1035
60
funcion
funcion
"Entrenar" "Makespan" "Tiempo Medio Finalización"
2

INPUTBOX
533
82
583
142
P1
300.0
1
0
Number

SLIDER
590
83
682
116
T_P1_M1
T_P1_M1
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
689
83
781
116
T_P1_M2
T_P1_M2
0
10
10.0
1
1
NIL
HORIZONTAL

INPUTBOX
533
148
583
208
P2
0.0
1
0
Number

SLIDER
590
148
682
181
T_P2_M1
T_P2_M1
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
689
148
781
181
T_P2_M2
T_P2_M2
0
10
10.0
1
1
NIL
HORIZONTAL

INPUTBOX
533
217
583
277
P3
0.0
1
0
Number

INPUTBOX
533
286
583
346
P4
100.0
1
0
Number

INPUTBOX
533
352
583
412
P5
0.0
1
0
Number

INPUTBOX
533
418
583
478
P6
0.0
1
0
Number

INPUTBOX
792
83
842
143
P7
0.0
1
0
Number

INPUTBOX
792
148
842
208
P8
0.0
1
0
Number

INPUTBOX
792
216
842
276
P9
0.0
1
0
Number

INPUTBOX
792
286
842
346
P10
700.0
1
0
Number

INPUTBOX
791
353
841
413
P11
0.0
1
0
Number

INPUTBOX
791
420
841
480
P12
0.0
1
0
Number

SLIDER
589
218
681
251
T_P3_M1
T_P3_M1
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
689
218
781
251
T_P3_M2
T_P3_M2
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
589
288
681
321
T_P4_M1
T_P4_M1
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
688
288
780
321
T_P4_M2
T_P4_M2
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
588
353
680
386
T_P5_M1
T_P5_M1
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
686
353
778
386
T_P5_M2
T_P5_M2
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
587
418
679
451
T_P6_M1
T_P6_M1
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
685
418
777
451
T_P6_M2
T_P6_M2
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
849
83
941
116
T_P7_M1
T_P7_M1
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
948
83
1040
116
T_P7_M2
T_P7_M2
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
848
148
940
181
T_P8_M1
T_P8_M1
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
947
148
1039
181
T_P8_M2
T_P8_M2
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
848
216
940
249
T_P9_M1
T_P9_M1
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
946
216
1038
249
T_P9_M2
T_P9_M2
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
848
286
940
319
T_P10_M1
T_P10_M1
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
945
286
1037
319
T_P10_M2
T_P10_M2
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
847
353
939
386
T_P11_M1
T_P11_M1
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
945
353
1037
386
T_P11_M2
T_P11_M2
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
847
420
939
453
T_P12_M1
T_P12_M1
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
946
419
1038
452
T_P12_M2
T_P12_M2
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
1071
15
1243
48
Tasa_M1
Tasa_M1
0
1
1.0
0.1
1
NIL
HORIZONTAL

SLIDER
1072
83
1244
116
Tasa_M2
Tasa_M2
0
1
1.0
0.1
1
NIL
HORIZONTAL

SLIDER
1071
148
1243
181
Tasa_M3
Tasa_M3
0
1
1.0
0.1
1
NIL
HORIZONTAL

SLIDER
1070
216
1242
249
Tasa_M4
Tasa_M4
0
1
1.0
0.1
1
NIL
HORIZONTAL

BUTTON
1358
17
1482
50
NIL
nueva_demanda
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
1303
73
1357
133
nP1
0.0
1
0
Number

INPUTBOX
1305
146
1355
206
nP2
0.0
1
0
Number

INPUTBOX
1304
218
1354
278
nP3
200.0
1
0
Number

INPUTBOX
1305
286
1355
346
nP4
1000.0
1
0
Number

INPUTBOX
1307
361
1357
421
nP5
0.0
1
0
Number

INPUTBOX
1309
434
1359
494
nP6
0.0
1
0
Number

INPUTBOX
1399
76
1449
136
nP7
0.0
1
0
Number

INPUTBOX
1404
154
1454
214
nP8
0.0
1
0
Number

INPUTBOX
1401
225
1451
285
nP9
100.0
1
0
Number

INPUTBOX
1400
291
1450
351
nP10
0.0
1
0
Number

INPUTBOX
1400
366
1450
426
nP11
0.0
1
0
Number

INPUTBOX
1401
436
1451
496
nP12
0.0
1
0
Number

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
