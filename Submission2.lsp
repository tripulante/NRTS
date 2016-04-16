;;;------------------------------------------------
;;;------------------------------------------------
;;; Cycling II
;;; Piece created for Non Real Time Systems 2016-1
;;; @author John Palma
;;;------------------------------------------------
;;;------------------------------------------------

(in-package :sc)

(set-sc-config 'default-dir "/tmp/")
;; loading external functions created for the piece
(load "/tmp/Sub2ExternalFunctions.lsp")

(let*
    (
     ;; instrument ensemble
     (ensemble '((tr (b-flat-trumpet :midi-channel 1))
		 (sx (alto-sax :midi-channel 2))
		 (cl (b-flat-clarinet :midi-channel 3))
		 (cp (computer :midi-channel 4))))
     ;; instrument list for manipulation
     (instruments (loop for i in ensemble collect (first i)))
     ;; assoc-list created to map instruments with rotation index
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
					 collect
					   (list i
						 (rotate-list dynamics
							      dir j)))))
     ;; ensemble creation for sections
     (2-sections (k-combinations instruments 2))
     (3-sections (k-combinations instruments 3))
     (instr-comb 
      (append 
	 (rotate-list 2-sections t 3)
	 (rotate-list 3-sections nil 4)
	 (list instruments)
	 (reverse 3-sections)
	 (list instruments)))
     ;; create chopped items and resort palette
     (orig-palette (make-rsp 'orig 
			     `((seq1 ((((4 4) e q q e e e)
				       (w))
				      :pitch-seq-palette
				      ((,(logistic-curve 0.04 3.75 7 2 6)
					 b-flat-trumpet)
				       (,(logistic-curve 0.04 3.87 7 1 8)
					 b-flat-clarinet)
				       (,(reverse
					  (logistic-curve 0.04 3.75 7 2 6))
					 alto-sax)
				       (4 5 6 4 5 6 6)
				       ,(logistic-curve 0.04 3.85 7 2 8))))
			       (seq2 ((((3 4) s x 4 e x 4 ))
				      :pitch-seq-palette
				      ((,(reverse
					  (logistic-curve 0.005 3.75 8 1 9))
					 b-flat-trumpet)
				       (,(logistic-curve 0.04 3.75 8 1 9)
					 b-flat-clarinet)
				       (,(logistic-curve 0.005 3.9871 8 1 8)
					 alto-sax)
				       ,(logistic-curve 0.005 3.65 8 1 4)
				       ,(logistic-curve 0.9 3 8 2 5)))))))
     (chopped-palette (chop orig-palette 
			    '((1 4) (5 8)
			      (1 3) (2 4) (3 5) (4 6) (5 7) (6 8)
			      (1 2) (2 3) (3 4) (4 5) (5 6) (6 7) (7 8))
			    '32))
     ;; simplified chop sequence
     (simplechop (sort-simplified-chop (chop-simplified chopped-palette)))
     ;; retrieves all time signatures in the chop points
     (time-sigs (ts-in-chop simplechop))
     ;; retrieves the sequences by time signature
     (seqs-by-ts (loop for s in time-sigs
		    collect (get-chop-pairs (get-chops-by-ts s simplechop))))
     ;; the sections are determined by the ensemble playing at that point in time
     (numsections (length instr-comb))
     ;; the bars in every section are determined by the chop points
     (numloops-section (loop for i in seqs-by-ts
			    sum (length i)))
     ;; loop that creates the rhythm section map
     (rthmmap (loop for sec in instr-comb
		 for counter from 1
		 collect (list counter
			       (loop for i in sec
				  for dir = (get-data-data i instr-direction)
				  for rot = (get-data-data i instr-rotation)
				  ;; changing direction midway through the piece
				  if (not (>= counter (/ numsections 2)))
				  collect (list i
						(loop for ts in seqs-by-ts
						   append
						     (rotate-list ts dir rot)))
				  else
				  collect (list i
						(loop for ts in seqs-by-ts
						   append
						     (rotate-list
						      ts (not dir) rot)))
				  ;; changing rotation rate
				  do
				    (replace-data i (+ rot 2) instr-rotation)
				    )))
       )
     ;; create loop of palettes for using in the final instrument loop
     (palettes `((s1 (,(reverse '(c2 cs2 d2 ef2 e2 f2 fs2 g2 af2 a2 bf2 b2
			  c3 cs3 d3 ef3 e3 f3 fs3 g3 af3 a3 bf3
			  c4 cs4 d4 ef4 e4 f4 fs4 g4 af4 a4 bf4)))) ; E, B
		 (s2 ((b2 fs3 d4 e4 a4 d5 e5 a5))) ; A A dim
		 (s3 ((cs3 fs3 e4 a4 e5 a5 e6))); B, G
		 (s4 ((fs2 cs3 e4 a4 b4 e5 a5 b5))) ; Transposition to D
		 ;; Whole Tone Scale
		 (s5 ((c2 d2 e2 fs2 gs2 as2 c4 d4 e4 fs4 gs4 as4
			  c5 d5 e5)))
		 (s6 ((c2 cs2 d2 ef2 e2 f2 fs2 g2 af2 a2 bf2 b2
			  c3 cs3 d3 ef3 e3 f3 fs3 g3 af3 a3 bf3
			  c4 cs4 d4 ef4 e4 f4 fs4 g4 af4 a4 bf4
			  )))
		 (s7 ((c5 cs5 d5 ef5 e5 f5 fs5 g5 af5 a5 bf5)))))
     (map-combinations '(s1 s2 s3 s4 s5 s6 s7))
     ;; creates the map based on the sections and the bars
     (set-map-loop2 (loop for i from 1 to numsections
		       for map = map-combinations
		       then (wrap-list map 1)
		       for len = (length map)
		       collect
			 (list i
			       (loop for j from 1 to numloops-section
				  for pos = (mod j len)
				    collect (nth pos map)))))
     ;; set of available tempi
     (tempi '(120 100 97 90 100 115 120 140 155 170 180))
     (sndgroups (append instruments '(tape)))
     (cycle (make-slippery-chicken
	     '+cycle+
	     :title "Cycling 2"
	     :composer "John Palma"
	     :ensemble `(,(loop for i in ensemble collect i))
	     :set-limits-high '((cl (0 bf5 100 bf5))
				(tr (0 gs5 100 gs5))
				(sx (0 f5 100 a5)))
	     :set-limits-low '((cl (0 a4 100 a4))
			       (tr (0 c4 100 c4))
			       (sx (0 c4 100 c4)))
	     :set-palette palettes
	     :set-map set-map-loop2
	     :rthm-seq-palette chopped-palette
	     :rthm-seq-map rthmmap
	     :avoid-used-notes nil
	     :avoid-melodic-octaves nil
	     :snd-output-dir (get-sc-config 'default-dir)
	     :sndfile-palette `(((tr ((trpt-C-1)
				      (trpt-C-2)
				      (trpt-C-3)))
				 (cl ((cl-1)
				      (cl-2)
				      (cl-3)))
				 (sx ((sx-1)
				      (sx-2)
				      (sx-3)
				      (sx-4)))
				 (cp ((cp-1)
				      (cp-2)
				      ;;(cp-3)
				      (cp-4)
				      (cp-7
				       :amplitude 0.5)
				      (cp-5)))
				 (tape ((cp-4)
					(cp-8)
					(cp-5)
					(cp-6)
					(trpt-C-1)
					(cp-1)))
				 )
				("/tmp/")
				("wav"))
	     ))
     )
  ;; post generation rest and note consolidation
  (consolidate-all-rests cycle 1 (num-bars cycle) instruments)
  (map-over-bars cycle 1 nil nil #'consolidate-rests-max)
  (map-over-bars cycle 1 nil nil #'consolidate-notes nil 'q)
  ;; re-bar
  (re-bar cycle :min-time-sig '(3 4))
  ;; post-generation editing of time signatures for score
  (loop for i from  1 to (num-bars cycle)
     for cur-ts = (get-time-sig cycle i)
     if (or (and (eq (num cur-ts) 24)
		 (eq (denom cur-ts) 32))
	    (and (eq (num cur-ts) 12)
		 (eq (denom cur-ts) 16)))
     do
       (change-time-sig cycle i '(6 8))
     else if (and (eq (num cur-ts) 26)
		  (eq (denom cur-ts) 32))
     do
       (change-time-sig cycle i '(13 16))
     else if (and (eq (num cur-ts) 6)
		  (eq (denom cur-ts) 32))
     do
       (change-time-sig cycle i '(3 16)))
  (consolidate-all-rests cycle 1 (num-bars cycle) instruments)
  (map-over-bars cycle 1 nil nil #'consolidate-rests-max)
  ;; delete empty bars
  (print (loop for to-del in
	      (loop for i from 1 to (num-bars cycle)
		 for bars = (get-bar cycle i nil)
		 for empty = (loop for b in bars
				if (all-rests? b)
				collect t)
		 if (= (length empty) 4)
		 collect i)
	      for correct from 0
	    do
	      (delete-bars cycle (- to-del correct) :num-bars 1)))
  ;; rotate through dynamics
  ;; TODO check if there is a better way to rotate through the algorithm
  (loop for i from 1 to (get-num-sections cycle)
     for players = (nth (1- i) instr-comb)
     for s = (get-section cycle i)
     for sb = (start-bar s)
     for eb = (end-bar s)
     for nb = (num-bars s)
     do
       (loop for pl in players
	  for dyn = (get-data-data pl instr-dynamics)
	  for d = (first dyn)
	  with cur = sb
	  do
	    (add-mark-to-note cycle cur 1 pl d)
	    (replace-data pl (rotate-list dyn nil 1) instr-dynamics)))
  ;; creates a loop of tempo mappings
  (replace-tempo-map cycle 
		     (loop 
			with rebar-total = (num-bars cycle)
			with unit = 'q
			with rate = (round (/ rebar-total (length tempi)))
			for tm = tempi then (wrap-list tm 1)
			for tp = (first tm)
			for i from 1 to rebar-total by rate
			collect (list i (list unit tp))))
  ;; post-generation editing of slurs on pitched notes
  (auto-slur cycle nil 
	     :over-accents nil
	     :rm-staccatos nil)
  ;; clm file generation
  ;; (loop for i in instruments
  ;;    do
  ;;      (clm-play cycle 1 i i
  ;; 		 :pitch-synchronous t
  ;; 		 :check-overwrite nil
  ;; 		 :ignore-rests nil
  ;; 		 :channels 1
  ;; 		 :rev-amt 0.05)
  ;;      (clm-play cycle 1 nil i
  ;; 		 :check-overwrite nil
  ;; 		 :ignore-rests nil
  ;; 		 :duration-scaler 3.0
  ;; 		 :rev-amt 0.05))
  ;; (clm-play cycle 1 'cp 'cp
  ;; 		 :check-overwrite nil
  ;; 		 :ignore-rests nil
  ;; 		 :rev-amt 0.05)
  ;; (clm-play cycle 1 nil 'cp
  ;; 	    :sound-file-palette-ref2 'tape
  ;; 	    :duration-scaler 4.0
  ;; 	    :check-overwrite nil
  ;; 	    :rev-amt 0.1)
  ;; (clm-play cycle 1 nil 'tape
  ;; 	    :sound-file-palette-ref2 'cp
  ;; 	    :duration-scaler 10.0
  ;; 	    :check-overwrite nil
  ;; 	    :rev-amt 0.1)
  ;; (clm-play cycle 1 nil 'tape
  ;; 	    :duration-scaler 10.0
  ;; 	    :check-overwrite nil
  ;; 	    :rev-amt 0.1)
  ;; Lilypond output
  (write-lp-data-for-all cycle :base-path "/tmp/") 
  ;; Midi output
  (midi-play cycle :midi-file "/tmp/cycle1.mid" )
  ;; print
  )


