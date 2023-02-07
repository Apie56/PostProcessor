(test1)
N0 G90
N1 G64
(Select spindle #1)
N2 M91
N3 G00 C0.
N4 G00 X55 Y60
(plunge blade and wait)
N5 M3
N6 G01 C180.
N7 X5 F6000
N8 C57.995
N9 X55 Y140
(lift blade and wait)
N10 M5
N11 G00 Y60
(plunge blade and wait)
N12 M3
N13 G01 C-30.
N14 X124.282 Y20 F6000
N15 C30.
N16 X193.564 Y60
N17 C90.
N18 Y140
N19 C150.
N20 X124.282 Y180
N21 C-150.
N22 X55 Y140
N23 C-90.
N24 Y60
(lift blade and wait)
N25 M5
(select spindle 0)
N26 M90
(go to corner)
N27 G30
