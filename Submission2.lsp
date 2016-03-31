
(load "~/Documents/Uni/sem 2/NRTS/Code/Pieces/Sub2/Sub2ExternalFunctions.lsp")

(let*
    (
     ;; instrument ensemble
     (ensemble '((tr (b-flat-trumpet :midi-channel 1))
		 (sx (alto-sax :midi-channel 2))
		 (cl (b-flat-clarinet :midi-channel 3))
		 (cp (computer :midi-channel 4))))
     ;; instrument list for manipulation
     (instruments (loop for i in ensemble collect (first i)))
     ;; assoc list created to map instruments with rotation index
     (instr-rotation (make-assoc-list 'rotations
				      (loop for i in instruments
					 for j in '(5 4 6 3)
					 collect (list i j))))
     ;; assoc-list created to map instruments with rotation direction
     (instr-direction (make-assoc-list 'direction
				      (loop for i in instruments
					 for j from 0
					 collect (list i (evenp j)))))
     ;; dynamic options for piece
     (dynamics '(p f pp ff))
     ;; dynamics map
     (instr-dynamics (make-assoc-list 'dynamics
				      (loop for i in instruments
					 for j from 1
					 for dir = t then (not dir)
					 collect (list i (rotate-list dynamics dir j)))))
     ;; ensemble creation for sections
     (2-sections (k-combinations instruments 2))
     (3-sections (k-combinations instruments 3))
     ;; TODO create cycling structure between instrument ensemble
     (instr-comb 
      (append 
	 (list (list (first instruments)));; trumpet only
	 (rotate-list 2-sections t 3)
	 (rotate-list 3-sections nil 4)
	 (list instruments)
	 (reverse (interleave 2-sections 3-sections))
	 ))
     ;; create chopped items and resort palette
     ;; TODO change sequences and curves
     (orig-palette (make-rsp 'orig 
                               '((seq1 ((((4 4) e q q e e e))
					:pitch-seq-palette (( 1 2 3 1 2 3)
							    ( 4 5 6 4 5 6))))
				 (seq2 ((((3 4) (e) q q. ))
					:pitch-seq-palette ((1 3))))
                                 )))
     ;; TODO experiment w/ chop points
     (chopped-palette (chop orig-palette 
                              '((1 4)
				(1 3) (2 4)
				(1 2) (2 3) (3 4)
				(1 1) (2 2) (3 3) (4 4))
                              's))
     ;; simplified chop sequence
     (simplechop (sort-simplified-chop (chop-simplified chopped-palette)))
     ;; retrieves all time signatures in the chop points
     (time-sigs (ts-in-chop simplechop))
     ;; retreves the sequences by time signature
     (seqs-by-ts (loop for s in time-sigs
		    collect (get-chop-pairs (get-chops-by-ts s simplechop))))
     ;; the sections are determined by the ensemble playing at that point in time
     (numsections (length instr-comb))
     ;; the bars in every section are determined by the chop points
     (numloops-section (loop for i in seqs-by-ts
			    sum (length i)))
     ;; creates the map based on the sections and the bars
     ;; TODO define final map
     ;; TODO define if we should use fibonacci or l systems to create them
     (set-map-loop (loop for i from 1 to numsections
			    collect
			      (list i
				    (fibonacci-transitions numloops-section '(s1 s2)))))
     ;; loop that creates the rhythm section map
     (rthmmap (loop for sec in instr-comb
		 for counter from 1 
		 collect (list counter
			       ;; TODO check if this can be created somewhere else and
			       ;; interpolated and/ or shuffled
			       (loop for i in sec
				  for dir = (get-data-data i instr-direction)
				  for rot = (get-data-data i instr-rotation)
				  collect (list i
						(loop for ts in seqs-by-ts
						   append (rotate-list ts dir rot)))
				  finally 
				    (replace-data i (not dir) instr-direction)))))
     ;; create loop of palettes for using in the final instrument loop
     ;; set of available tempi
     (tempi '(120 90 180))
     (cycle (make-slippery-chicken
	     '+cycle+
	     :title "Cycling 2"
	     :composer "John Palma"
	     :ensemble `(,(loop for i in ensemble collect i))
	     :set-palette '((s1 ((e4 gs4 b4 a4 cs4 e5 g4 b4 d4 b5 ds5 fs5)))
			    (s2 ((e4 g4 b4 ds4 fs4))))
	     :tempo-map '((1 (q 120)))
	     :set-map set-map-loop
	     :rthm-seq-palette chopped-palette
	     :rthm-seq-map rthmmap
	     
	     ))
     )
  ;; (print (loop repeat 10
  ;; 	    for i from 1 to 4
  ;; 	    for dyn = (wrap-list dynamics i)
  ;; 	    collect dyn))
  ;; (print cycle)
  ;; (print instr-comb)
  

  (re-bar cycle :min-time-sig '(3 4))
  ;; rotate through dynamics
  ;; TODO check if there is a better way to rotate through the algorithm
  (print (loop for i from 1 to (get-num-sections cycle)
	    for players = (nth (1- i) instr-comb)
	    for s = (get-section cycle i)
	    for sb = (start-bar s)
	    for eb = (end-bar s)
	    for nb = (num-bars s)
	    collect (list i sb eb nb players)
	    do
	      (loop for pl in players
		 for dyn = (get-data-data pl instr-dynamics)
		 for d = (first dyn)
		 with cur = sb
		 do
		   (print (list cur pl))
		   (add-mark-to-note cycle cur 1 pl d)
		   (replace-data pl (rotate-list dyn nil 1) instr-dynamics))))
  ;; creates a loop of tempo mappings
  (replace-tempo-map cycle 
		     (loop 
			with rebar-total = (num-bars cycle)
			with unit = 'q
			with rate = 40
			for tm = tempi then (wrap-list tm 1)
			for tp = (first tm)
			for i from 1 to rebar-total by rate
			collect (list i (list unit tp))))
  (write-lp-data-for-all cycle :base-path "~/Documents/uni/sem 2/NRTS/Code/Pieces/Sub2/Score/")

  ;; (midi-play cycle :midi-file "~/Documents/uni/sem 2/NRTS/Code/Pieces/MIDI/cycle1.mid" )
  )


