init_mscroll:
	move.l	#mtexte,ptr_mtexte
	rts

mscroll:   
      move.w 	bit,d0
      cmp.w 	#8,d0
      bne.s 	plusloin3
      clr.w 	bit
      move.l 	ptr_mtexte,a1
      move.b 	(a1),d0
      cmp.b 	#255,d0
      bne.s 	lsuite
      move.l 	#mtexte,ptr_mtexte
      move.l 	ptr_mtexte,a1
      move.b 	(a1),d0
lsuite
      addq.l 	#1,ptr_mtexte
      asl.l 	#3,d0
      lea	      fonts_8x8,a1
      sub.w	      #256,d0
      add.w 	d0,a1
      lea	      bufferscr,a2

i          set 	0
           rept 	8
      move.b 	(a1)+,i(a2)
i          set 	i+2
           endr

plusloin3: addq.w 	#1,bit

           lea	trav,a1
           lea	bufferscr,a2
i          set 	0
           rept	 8
           roxl 	(a2)+
           roxl 	i+38(a1)
           roxl 	i+36(a1)
           roxl 	i+34(a1)
           roxl 	i+32(a1)
           roxl 	i+30(a1)
           roxl 	i+28(a1)
           roxl 	i+26(a1)
           roxl 	i+24(a1)
           roxl 	i+22(a1)
           roxl 	i+20(a1)
           roxl 	i+18(a1)
           roxl 	i+16(a1)
           roxl 	i+14(a1)
           roxl 	i+12(a1)
           roxl 	i+10(a1)
           roxl 	i+8(a1)
           roxl 	i+6(a1)
           roxl 	i+4(a1)
           roxl 	i+2(a1)
           roxl 	i+0(a1)
i          set 	i+40
           endr

aff_scr:   movea.l 	LOG4,a1
           subq.w	#2,a1
           add.l		#160*40,a1
           lea	trav,a2
i          set 	2
           rept 	9-1	*	hauteur du scroll
           move.w 	(a2)+,i+2(a1)
           move.w 	(a2)+,i+10(a1)
           move.w 	(a2)+,i+18(a1)
           move.w 	(a2)+,i+26(a1)
           move.w 	(a2)+,i+34(a1)
           move.w 	(a2)+,i+42(a1)
           move.w 	(a2)+,i+50(a1)
           move.w 	(a2)+,i+58(a1)
           move.w 	(a2)+,i+66(a1)
           move.w 	(a2)+,i+74(a1)
           move.w 	(a2)+,i+82(a1)
           move.w 	(a2)+,i+90(a1)
           move.w 	(a2)+,i+98(a1)
           move.w 	(a2)+,i+106(a1)
           move.w 	(a2)+,i+114(a1)
           move.w 	(a2)+,i+122(a1)
           move.w 	(a2)+,i+130(a1)
           move.w 	(a2)+,i+138(a1)
           move.w 	(a2)+,i+146(a1)
           move.w 	(a2)+,i+154(a1)
i          set 	i+160
           endr
     
           rts
mtexte: 
	dc.b	" A new world record here! 630 atari st crews greetings list!   go!!!      1984, 1st crew, 2 life crew, 2smart4u, 3d corp, 42 crew, 44e, 49ers, a clockwork orange, a-team, aac, abc, abstract, accs, "
      dc.b	"ace, acf, acid team, admirables, adrenalin, adrenaline, aenigmatica, aggression, albedo, alien nation, alive, alkaline, alpha flight, ambassadors, amnesic cactus, anarchy, anatomica, ancient celts, "
      dc.b	"animal mine, animi dux, antic, apa, arakis, argonauts, arkham, armada, armalyte, arsenic, artis magia, atari boys, atari legend, atb, atrocity, aura, automation, avena, avengers, awesome, awg, axxept, "
      dc.b	"axxis, bac, bad boys, bad stars, barbarians, bastards, bbc, bcs, beast, bits, blabla, black boxes, black byte, black rainbow, blitzboys, blue software, blue system, blues boys, blues brothers, bmt, "
      dc.b	"boring, brain power, brainiacs, brainless institute, brainstorm, bugbusters, bushwackers, cat, central european team, cerebral vortex, channel 38, chaos, chaotic motion, checkpoint, chronicle, cia, "
      dc.b	"clan, clone, cnc, cobra, collaboration, condemned, confederacy, confederation, confusions, cream, creators, crime, crossbones, crystal corps, crystalic, csd, csm, css, cybernetics, cyclemasters, cynix, "
      dc.b	"dba, dbug, ddc, death, death stone, defence force, deflect, delight, deliverance, delta force, denise team, depression, desaster area, detonators, dhs, diamond design, digital crew, digital interactive, "
      dc.b	"digital justice, digital rainbow, digital vision, digitallis, diskmap crew, dma, dmg, dnt crew, dodgysoft, dune, dws, dynamic duo, dynamic labs, eagles, ecg, effect, ego trippers, eko, electra, "
      dc.b	"electric blue, electricity, electronic images, elite, ellipse, empire, emt, energetic, enigma, eos, epsilon, equinox, esc, eternal, euphoria, euroswap, evolution, exhaust port, exo7, extacy, "
      dc.b	"extreme design, factory, fallen angels, fantasy, fashion, fbi, fingerbobs, fire cracker, firehawks, flames of diamonds, flash, flatliners, flexible front, flexichron, floppy copy crew, "
      dc.b	"fmc connexion, fof, foft, foxx, fraggles, frb, friendchip, frontline, fun, funvision, futur minds, fuzion, g-force, galtan six, genesis, genesis inc, genesis project, germs, gesox, ghost, "
      dc.b	"ghostbusters, giants, golden dawn, gravitics, grim reaper crew, grinder, hardcore, high voltage, hofa, holocaust, horde, hotline, hsc, humbug, hyades, hybris, hydroxid, hysteria, ice, ics, "
      dc.b	"idemline, iic, imagina, immortality, immortals, impact, impact uk, imponance, impulse, independent, inercy, inner circle, insanity, insomnia, inter, intruders, invalids, invizibles, istari, ixion, "
      dc.b	"jacob's cream crackers, jsd, kgb, kruz, kua, kuba, lamers, latinoids, lazer, legacy, legend, lemmings, les nuls, level 16, light, lineout, lod, lost boys, loud, lowlife, lsd, lunatic asylum, lynx, "
      dc.b	"mad, mad vision, maggie team, magnum force, masters, mca, mcs, mdk, mec, medway boys, mega4, megabusters, mercs, misfits, mjj prod, mlp, mmu, moving pixels, mph, mystic, mystic bytes, naos, "
      dc.b	"napalm soldiers, nasa, nato, neonlights, network, new core, new generation, new order, new system, new trend, newline, next, ngc, night force, nlc, no extra, no limits, no return, nocrew, noice, "
      dc.b	"noktural, nordik coders, northside, nothing personal, now5, npg, nsonic, odyssey, off base, offbeat, offensive system, omega, onyx, orion, ouch, out of order, overlanders, oxygene, oxygenes, oxyron, "
      dc.b	"pacc, paradize, paradox, paranoia, paranoia, passion, passwords, pendragons, phalanx, phenix, phf, pixeven crew, poets of decay, poltergeist, pompey pirates, positivity, pov, prism, prophecy, psychonomix, "
      dc.b	"public enemys, pulse, pulsion, pure energy, pwc, quartet, quartex, radiation, radical systemz, ramsess soft, razor, reanimators, rebel squad, recall, redlite, reflection, removers, reprobates, "
      dc.b	"reservoir gods, respectables, reverses, revolution, reward, rip, ripped off, risk, rno, sas, sash, sbf, scb, scottish cracking crew, scsi, section one, sector 99, sector one, sentry, serenade, "
      dc.b	"serval, sewer software, sf crew, shaolin masters, shogun, sigma, silent noise, silents, slaytanic cult, smfx, soap, sote, special forces, special fx, spectre, sphere, spherical, spi, spice boys, "
      dc.b	"spirits, spyjack, squadron x, srg, sss, st apocalypse, st cnx, st computer service, st cops, st squad, st-force, st-rebels, stax, steel wings, stellar, stew, stk, stonaction, stranger, "
      dc.b	"sub humans in turkey, sublime, subsonic records, superior, supremacy, suspiria, sync, synchro system, syndicate, synergy, syntax, tam, taq, tbb, tbb, tbc, tbm, tcb, tcc, tcc, tcg, tcp, "
      dc.b	"tda, tdc, tds, tex, tfc, tge, the alien mutation, the alliance, the alliance, the androids, the art machine, the asylum, the beasts crew, the big four, the bitmasters, the black panthers, "
      dc.b	"the black twins, the blade runners, the british alliance, the byte changers, the chaos engine, the chaos krew, the coders, the constellations, the corporation, the crack connexion, the crusaders, "
      dc.b	"the druids, the enterprise, the estate, the evil force, the face inc, the fanatics, the final space coders, the futures, the gigabyte crew, the gods, the guild, the hackers, the heavy killers, "
      dc.b	"the highlanders, the hobbit brothers, the hooker, the imperator, the invisibles, the legion, the light team, the lightnings, the lords, the lower level, the maniax, the marvel corp, the mega crew, "
      dc.b	"the mersey pirates, the nephilim, the nerve center, the north boys, the opposition, the outsiders, the overlords, the pact, the pixel boys, the pixel masters, the predators, the psykopats, "
      dc.b	"the purple pig, the raiders brothers, the rebeliants, the rebels, the red herrings, the replicants, the sag, the screen killers, the shadow warriors, the sign of four, the silvers, the source, "
      dc.b	"the starfires, the starks, the stranglers, the techno gangsters, the triad, the ultimate, the ultra crew, the union, the vision, the watchmen, the wizards, the zone troopers, thg, thi, "
      dc.b	"thunderbirds, time lords, time team, tion, titanium, tkt, tlf, tmc, tnb, tnb, tnm, tnt crew, tool 8, torment, total vision inc, toxic, toxic twins, toys, tpp, tpt, track 41, tranceaction, "
      dc.b	"trash section, trb, trh, trinity, tripple h, triton development, tronic, trr, trsi, tsb, tsc, tscc, tsi, tsm, ttk, tts, ttzp, tuh, tumult, twb, twilight, twilight zone, twins, txc, typhoon, "
      dc.b	"ulm, undead, underground resistanz, unit 17, united forces, united vision, universal coders, unreal, untouchables, uten, utos, v8, vbl, vector, vectronix, vegetables, vikings, vision, "
      dc.b	"visualizers, vmax, voyagers, vulk, wabb, warning sign, was not was, white status, wild, wild chip, wildfire, worshippers, x factor, x-men, x-static, x-troll, xenex, xtream, xxx international, "
      dc.b	"yes crew, ymrockerz, zap creation, zeal, zenit, zodiac, zokathra, zpc, zuul                                   "
      dc.b	"  "
	dc.b	"                      "
	dc.b	-1
	even
fonts_8x8:
	incbin	"E:\hallof\DATA\FONT8X8.DAT"
	even    
ptr_mtexte:
	ds.l	1
bit:
	ds.w 	1
bufferscr:
	ds.w 	8
trav:
	ds.l	220
	even
