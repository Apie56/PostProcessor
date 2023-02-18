(test1)
N0 G90
N1 G64
(Select spindle #1)
N2 M91
N3 G00 A0.
N4 G00 X55 Y60
(plunge blade and wait)
N5 M3
(lift knife and wait)
N6 M5
N7 G00 A180.
(plunge blade and wait)
N8 M3
N9 G01 X5 F10000
(lift knife and wait)
N10 M5
N11 G00 A57.995
(plunge blade and wait)
N12 M3
N13 G01 X55 Y140
(lift knife and wait)
N14 M5
N15 G00 Y60
(plunge blade and wait)
N16 M3
(lift knife and wait)
N17 M5
N18 G00 A-30.
(plunge blade and wait)
N19 M3
N20 G01 X124.282 Y20 F10000
(lift knife and wait)
N21 M5
N22 G00 A30.
(plunge blade and wait)
N23 M3
N24 G01 X193.564 Y60
(lift knife and wait)
N25 M5
N26 G00 A90.
(plunge blade and wait)
N27 M3
N28 G01 Y140
(lift knife and wait)
N29 M5
N30 G00 A150.
(plunge blade and wait)
N31 M3
N32 G01 X124.282 Y180
(lift knife and wait)
N33 M5
N34 G00 A-150.
(plunge blade and wait)
N35 M3
N36 G01 X55 Y140
(lift knife and wait)
N37 M5
N38 G00 A-90.
(plunge blade and wait)
N39 M3
N40 G01 Y60
(lift knife and wait)
N41 M5
(select spindle 0)
N42 M90
(go to corner)
N43 G30
