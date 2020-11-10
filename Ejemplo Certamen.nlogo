breed [walkers walker]
;TODO definiciones de atributos

walkers-own [tpM1 tpM2 poS tiempo_proceso_total tiempo_proceso_actual pos1 pos2
  presupuesto-M1 presupuesto-M2
  oferta_M1 oferta_M2
  riesgo_procesamiento_M1 riesgo_procesamiento_M2
  oferta_total]


patches-own [tpp1 tpp2 costo_procesamiento ultima-subasta num_ofertas_ronda tasa-exito-subasta descuento]

globals [tiempo posiciones final ite ite2 max1 max2 max3 tp_max_M1]


;==========================================Procedimientos para el setup====================================================

to setup
  ca
  nodos
  create-walkers (P1 + P2 + P3 + P4 + P5 + P6) / Lote_min [
    set color white
    move-to patch 0 0 ;funcionará como cola para M1
    set size 0.5 set heading 90
    set label who

  ]
  diferenciacion
  fijar-presupuesto-inicial
  posicion
  reset-ticks

end

to nodos
  ask patch 0 0 [set pcolor white set plabel "cola-M1" set plabel-color black]
  ask patch 1 0 [set pcolor blue set plabel "M1" set plabel-color white set tpp1 1 set tpp2 2 ]
  ask patch 2 0 [set pcolor white set plabel "cola-M2" set plabel-color black]
  ask patch 3 2 [set pcolor blue set plabel "M2" set plabel-color white set tpp1 3 set tpp2 8 set pcolor orange]
  ask patch 3 -2 [set pcolor blue set plabel "M4" set plabel-color white set tpp1 3 set tpp2 8 set pcolor orange]
  ask patch 3 0 [set pcolor blue set plabel "M3" set plabel-color white set tpp1 3 set tpp2 8 set pcolor orange]
   ask patch 4 0 [set pcolor white set plabel "PT" set plabel-color black]
  ask patch 5 0 [set pcolor blue set plabel "B0" set plabel-color white]
  ask patches [set ultima-subasta 0 set num_ofertas_ronda 0 set tasa-exito-subasta 0]
end

to diferenciacion
  if P1 > 0 [ask n-of (P1 / Lote_min) walkers with [color = white] [set color red set tpM1 T_P1_M1 set tpM2 T_P1_M2  ]]
  if P2 > 0 [ask n-of (P2 / Lote_min) walkers with [color = white] [set color green set tpM1 T_P2_M1 set tpM2 T_P2_M2  ]]
  if P3 > 0 [ask n-of (P3 / Lote_min) walkers with [color = white] [set color blue set tpM1 T_P3_M1 set tpM2 T_P3_M2 ]]
  if P4 > 0 [ask n-of (P4 / Lote_min) walkers with [color = white] [set color yellow set tpM1 T_P4_M1 set tpM2 T_P4_M2 ]]
  if P5 > 0 [ask n-of (P5 / Lote_min) walkers with [color = white] [set color pink set tpM1 T_P5_M1 set tpM2 T_P5_M2 ]]
  if P6 > 0 [ask n-of (P6 / Lote_min) walkers with [color = white] [set color brown set tpM1 T_P6_M1 set tpM2 T_P6_M2 ]]
  ask walkers [set riesgo_procesamiento_M1 (1 + (tpM1 / 10))
                set riesgo_procesamiento_M2 (1 + (tpM1 / 10))] ; 10 es el máximo tiempo de procesamiento en una máquina
end

to fijar-presupuesto-inicial
  ask walkers [
              set presupuesto-M1 (Base-presupuesto-procesamiento * tpM1 )
              set presupuesto-M2 (Base-presupuesto-procesamiento * tpM2 )
              set oferta_M2 0]
end

to posicion ;???

  if funcion = "Negociacion"[

  ]

  if funcion = "Entrenar" [
    let aux3 0
    set posiciones shuffle (n-values count walkers [i -> i])
    foreach [who] of walkers [x -> ask walker x [set poS item aux3 posiciones set aux3 aux3 + 1]]
  ]


  if funcion = "Makespan" [ask turtles [set poS pos1]]
  if funcion = "Tiempo Medio Finalizacion" [ask turtles [set poS pos2]]
end





;==========================================Procedimientos para la Ejecución====================================================


to go



  ask patches with [plabel = "M1"] [

    if pcolor = blue [subastar-uso-M1]
    ifelse any? walkers-here [set pcolor red] [set pcolor blue]
  ]


  ask turtles-on patches with [plabel = "M1"]
   [ ;a la tortuga seleccionada se le fija tiempo_proceso_total igual a tiempo:  !!!!!!!!!!! tiempo_proceso_total
      set tiempo_proceso_total tiempo


      ifelse tiempo_proceso_actual = round(tpM1 + (tpM1 * (1 - Tasa_M1)))
      ;si su tiempo_proceso_actual es igual tiempo de procesamiento de la máquina se ejecuta análisis
      [ set tiempo_proceso_total tiempo_proceso_total + tiempo_proceso_actual
        set tiempo_proceso_actual 0

        analisis]
      ;si su tiempo_proceso_actual es distinto tiempo de procesamiento de la máquina se actualiza su tiempo y tiempo_proceso_actual
      [set tiempo tiempo + 1 set tiempo_proceso_actual tiempo_proceso_actual + 1]]


ask turtles-on patches with [plabel = "M2"]
   [ ;a la tortuga seleccionada se le fija tiempo_proceso_total igual a tiempo:  !!!!!!!!!!! tiempo_proceso_total



      ifelse tiempo_proceso_actual = round(tpM2 + (tpM2 * (1 - Tasa_M2)))
      ;si su tiempo_proceso_actual es igual tiempo de procesamiento de la máquina se ejecuta análisis
      [
        set tiempo_proceso_total tiempo_proceso_total + tiempo_proceso_actual ;TODO
        move-to patch 4 0
       ]
      ;si su tiempo_proceso_actual es distinto tiempo de procesamiento de la máquina se actualiza su tiempo y tiempo_proceso_actual
      [set tiempo_proceso_actual tiempo_proceso_actual + 1]]



  ;hacer la subasta 2


    tick


;  ifelse count turtles-on patches with [pcolor = orange] = count turtles
;
;  ;se detiene si todas las tortugas están  en las máquinas tipo dos (ocupadas)
;
;  [
;    ;show max [tiempo_proceso_total] of walkers
;    set final max [tiempo_proceso_total] of walkers
;    makespan
;    TMFin
;    ask turtles [move-to patch 1 0 set tiempo_proceso_total 0 set tiempo_proceso_actual 0 set tiempo 0] posicion ;show poS
;  ]




end

to analisis ; primero revisa si las máquinas tipo 2 están vacías, si están ocupadas realiza la función decisión
  ifelse not any? walkers-on patch 3 2 [move-to patch 3 2 set tiempo_proceso_total (tiempo_proceso_total + round(tpM2 + (tpM2 * (1 - Tasa_M2))))][
    ifelse not any? walkers-on patch 3 0 [move-to patch 3 0 set tiempo_proceso_total (tiempo_proceso_total + round(tpM2 + (tpM2 * (1 - Tasa_M3))))][
      ifelse not any? walkers-on patch 3 -2 [move-to patch 3 -2 set tiempo_proceso_total (tiempo_proceso_total + round(tpM2 + (tpM2 * (1 - Tasa_M4))))] [move-to patch 2 0]]
  ]
end


to subastar-uso-M2

  let ofertantes walkers-on patches with [plabel = "cola-M2"]
  let costo_M2 one-of [costo_procesamiento] of patches with [plabel = "M2"] ;se usa un solo valor porque las máquinas son iguales




 ; while [ ]







  ask patches with [plabel = "M1"] [set num_ofertas_ronda 0
                                    set costo_procesamiento Max-costo-proc * .8 * (count turtles-here) + .2 * Max-costo-proc ; la cantidad de tortugas en la máquina se toma como la utilización, debería ser 0 o 1
                                    set descuento (Max-desc-subasta * (1 - tasa-exito-subasta ) )


                                    ]

  ask ofertantes  [set oferta_M2 (.9 * (presupuesto-M2 / 2))]

;mientras no haya un agente que ofrezca más de procesamiento

ifelse not any? ofertantes with [oferta_M2 >= costo_M2]

[  while [ not any? ofertantes with [oferta_M2 >= costo_M2] ]


  [
    ask patches with [plabel = "M1"]
      [
        set costo_procesamiento (costo_procesamiento - descuento)
        set num_ofertas_ronda (num_ofertas_ronda + 1 )
      ]


    ask ofertantes [set oferta_M1 (riesgo_procesamiento_M1 * oferta_M1)]
   ]
]
  [ask patches with [plabel = "M1"] [set num_ofertas_ronda (num_ofertas_ronda + 1 )]]

;
;TODO subastas
  let mejores_postores ofertantes with [oferta_M2 >= costo_M2]

 ask max-one-of mejores_postores [oferta_M1] [move-to patch 1 0 ]
 ask patches with [plabel = "M1"] [set tasa-exito-subasta (1 / num_ofertas_ronda)]  ; se fija la tasa de éxitos como los éxitos en la última ronda, pero puede ser un registro de toda la historia de subastas

end


to decision ;???
  ifelse tiempo_proceso_total >= min [tiempo_proceso_total] of walkers-on patches with [pcolor = orange]

  ;accion en caso de que tiempo_proceso_total sea mayor o igual a tiempo_proceso_total menor en alguna máquina ocupada
  [
    move-to min-one-of walkers-on patches with [pcolor = orange] [tiempo_proceso_total] ;moverse a alguna máquina con producto con mínimo tiempo_proceso_total
    ;se actualiza el tiempo_proceso_total según la capacidad de procesamiento de la máquina actual
    if plabel = "M2" [set tiempo_proceso_total (tiempo_proceso_total + round(tpM2 + (tpM2 * (1 - Tasa_M2))))]
    if plabel = "M3" [set tiempo_proceso_total (tiempo_proceso_total + round(tpM2 + (tpM2 * (1 - Tasa_M3))))]
    if plabel = "M4" [set tiempo_proceso_total (tiempo_proceso_total + round(tpM2 + (tpM2 * (1 - Tasa_M4))))]
    ; se le pide a los otros productos que actualicen su tiempo_proceso_total al mayor
    ask other walkers-here [set tiempo_proceso_total max [tiempo_proceso_total] of walkers-here]
  ]

  ;accion en caso de que tiempo_proceso_total sea menor al tiempo_proceso_total menor en alguna máquina ocupada
  [
    move-to min-one-of walkers-on patches with [pcolor = orange] [tiempo_proceso_total] ;
    if plabel = "M2" [set tiempo_proceso_total (max [tiempo_proceso_total] of other walkers-here + round(tpM2 + (tpM2 * (1 - Tasa_M2))))]
    if plabel = "M3" [set tiempo_proceso_total (max [tiempo_proceso_total] of other walkers-here + round(tpM2 + (tpM2 * (1 - Tasa_M3))))]
    if plabel = "M4" [set tiempo_proceso_total (max [tiempo_proceso_total] of other walkers-here + round(tpM2 + (tpM2 * (1 - Tasa_M4))))]
    ask other walkers-here [set tiempo_proceso_total max [tiempo_proceso_total] of walkers-here]
  ]
end

;____________________________________________________________________________________________________________________
to subastar-uso-M1

  let ofertantes walkers-on patches with [plabel = "cola-M1"]
  let costo_M1 one-of [costo_procesamiento] of patches with [plabel = "M1"]

  ask patches with [plabel = "M1"] [set num_ofertas_ronda 0
                                    set costo_procesamiento Max-costo-proc * .8 * (count turtles-here) + .2 * Max-costo-proc ; la cantidad de tortugas en la máquina se toma como la utilización, debería ser 0 o 1
                                    set descuento (Max-desc-subasta * (1 - tasa-exito-subasta ) )


                                    ]

  ask ofertantes  [set oferta_M1 (.9 * (presupuesto-M1 / 2))]

;mientras no haya un agente que ofrezca más de procesamiento

ifelse not any? ofertantes with [oferta_M1 >= costo_M1]

[  while [ not any? ofertantes with [oferta_M1 >= costo_M1] ]

  [
    ask patches with [plabel = "M1"]
      [
        set costo_procesamiento (costo_procesamiento - descuento)
        set num_ofertas_ronda (num_ofertas_ronda + 1 )
      ]


    ask ofertantes [set oferta_M1 (riesgo_procesamiento_M1 * oferta_M1)]
   ]
]
  [ask patches with [plabel = "M1"] [set num_ofertas_ronda (num_ofertas_ronda + 1 )]]

;
;TODO subastas
  let mejores_postores ofertantes with [oferta_M1 >= costo_M1]

 ask max-one-of mejores_postores [oferta_M1] [move-to patch 1 0 ]
 ask patches with [plabel = "M1"] [set tasa-exito-subasta (1 / num_ofertas_ronda)]  ; se fija la tasa de éxitos como los éxitos en la última ronda, pero puede ser un registro de toda la historia de subastas

end



to makespan ;???
  set ite (sentence ite final) set ite remove 0 ite ;https://ccl.northwestern.edu/netlogo/docs/dictionary.html#se
  show ite ;debugging
  if min ite = final [ask turtles [set pos1 poS]]
end

to TMFin ;???
  ask turtles-on patch 3 2 [set max1 ((max [tiempo_proceso_total] of walkers-here) / count walkers-here)]
  ask turtles-on patch 3 0 [set max2 ((max [tiempo_proceso_total] of walkers-here) / count walkers-here)]
  ask turtles-on patch 3 -2 [set max3 ((max [tiempo_proceso_total] of walkers-here) / count walkers-here)]

  set ite2 (se ite2 precision ((max1 + max2 + max3) / 3) 3) set ite2 remove 0 ite2
  if min ite2 = precision ((max1 + max2 + max3) / 3) 3 [ask turtles [set pos2 poS]]
end

to nueva_demanda
  create-walkers (nP1 + nP2 + nP3 + nP4 + nP5 + nP6) / Lote_min [
    set color white
    move-to patch 1 0
    set size 0.5 set heading 90
    set label who
  ]
  diferenciacion2
  posicion2
end

to diferenciacion2
  if nP1 > 0 [ask n-of (nP1 / Lote_min) walkers with [color = white] [set color red set tpM1 T_P1_M1 set tpM2 T_P1_M2  ]]
  if nP2 > 0 [ask n-of (nP2 / Lote_min) walkers with [color = white] [set color green set tpM1 T_P2_M1 set tpM2 T_P2_M2  ]]
  if nP3 > 0 [ask n-of (nP3 / Lote_min) walkers with [color = white] [set color blue set tpM1 T_P3_M1 set tpM2 T_P3_M2 ]]
  if nP4 > 0 [ask n-of (nP4 / Lote_min) walkers with [color = white] [set color yellow set tpM1 T_P4_M1 set tpM2 T_P4_M2 ]]
  if nP5 > 0 [ask n-of (nP5 / Lote_min) walkers with [color = white] [set color pink set tpM1 T_P5_M1 set tpM2 T_P5_M2   ]]
  if nP6 > 0 [ask n-of (nP6 / Lote_min) walkers with [color = white] [set color brown set tpM1 T_P6_M1 set tpM2 T_P6_M2   ]]

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
538
539
-1
-1
40.0
1
10
1
1
1
0
1
1
1
-6
6
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
NIL
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
"Entrenar" "Makespan" "Tiempo Medio Finalización" "Negociacion"
0

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
691
90
783
123
T_P1_M1
T_P1_M1
0
10
3.0
1
1
NIL
HORIZONTAL

SLIDER
790
90
882
123
T_P1_M2
T_P1_M2
0
10
3.0
1
1
NIL
HORIZONTAL

INPUTBOX
531
160
581
220
P2
100.0
1
0
Number

SLIDER
690
167
782
200
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
789
167
881
200
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
531
229
581
289
P3
500.0
1
0
Number

INPUTBOX
531
298
581
358
P4
200.0
1
0
Number

INPUTBOX
531
364
581
424
P5
600.0
1
0
Number

INPUTBOX
531
430
581
490
P6
300.0
1
0
Number

SLIDER
689
237
781
270
T_P3_M1
T_P3_M1
0
10
7.0
1
1
NIL
HORIZONTAL

SLIDER
789
237
881
270
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
689
307
781
340
T_P4_M1
T_P4_M1
0
10
4.0
1
1
NIL
HORIZONTAL

SLIDER
788
307
880
340
T_P4_M2
T_P4_M2
0
10
7.0
1
1
NIL
HORIZONTAL

SLIDER
688
372
780
405
T_P5_M1
T_P5_M1
0
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
786
372
878
405
T_P5_M2
T_P5_M2
0
10
3.0
1
1
NIL
HORIZONTAL

SLIDER
687
437
779
470
T_P6_M1
T_P6_M1
0
10
1.0
1
1
NIL
HORIZONTAL

SLIDER
785
437
877
470
T_P6_M2
T_P6_M2
0
10
5.0
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
1374
15
1498
48
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
100.0
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

PLOT
1065
297
1265
447
plot 1
NIL
NIL
0.0
1000.0
0.0
1000.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot ite"

INPUTBOX
591
82
673
142
Entrega_P1
1000.0
1
0
Number

INPUTBOX
593
158
671
218
Entrega_P2
1000.0
1
0
Number

INPUTBOX
594
228
674
288
Entrega_P3
1000.0
1
0
Number

INPUTBOX
596
295
673
355
Entrega_P4
3000.0
1
0
Number

INPUTBOX
595
367
673
427
Entrega_P5
2000.0
1
0
Number

INPUTBOX
598
432
670
492
Entrega_P6
2500.0
1
0
Number

SLIDER
905
94
997
127
Multa_P1
Multa_P1
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
900
165
992
198
Multa_P2
Multa_P2
0
10
1.0
1
1
NIL
HORIZONTAL

SLIDER
899
233
991
266
Multa_P3
Multa_P3
0
10
1.0
1
1
NIL
HORIZONTAL

SLIDER
915
308
1007
341
Multa_P4
Multa_P4
0
10
1.0
1
1
NIL
HORIZONTAL

SLIDER
904
373
996
406
Multa_P5
Multa_P5
0
10
1.0
1
1
NIL
HORIZONTAL

SLIDER
914
435
1006
468
Multa_P6
Multa_P6
0
10
0.0
1
1
NIL
HORIZONTAL

INPUTBOX
1265
11
1357
71
Llegada_pedido
500.0
1
0
Number

SLIDER
710
530
908
563
Base-presupuesto-entrega
Base-presupuesto-entrega
0
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
922
529
1122
562
Base-presupuesto-procesamiento
Base-presupuesto-procesamiento
0
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
1138
529
1310
562
Max-costo-proc
Max-costo-proc
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
1321
528
1493
561
Max-desc-subasta
Max-desc-subasta
0
10
5.0
1
1
NIL
HORIZONTAL

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
