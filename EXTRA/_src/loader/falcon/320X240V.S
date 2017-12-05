* ###########################################################################
* #                                                                         #
* #  'ScreensPain' coded 1993 by Chris of AURA & Scandion of the Mugwumps  #
* #                                                                         #
* #                 --- It's an INDEPENDENT-Product ---                     #
* #                                                                         #
* ###########################################################################
* Monitor: VGA
* 320*240, 16 Farben, 50.0 Hz, 31470 Hz

        MOVE.L   #$170012,$FFFF8282.W
        MOVE.L   #$1020E,$FFFF8286.W
        MOVE.L   #$D0011,$FFFF828A.W
        MOVE.L   #$4EB0465,$FFFF82A2.W
        MOVE.L   #$A500A5,$FFFF82A6.W
        MOVE.L   #$46504E7,$FFFF82AA.W
        MOVE.W   #$200,$FFFF820A.W
        MOVE.W   #$186,$FFFF82C0.W
        CLR.W    $FFFF8266.W
        MOVE.B   #$0,$FFFF8260.W
        MOVE.W   #$5,$FFFF82C2.W
        MOVE.W   #$50,$FFFF8210.W
