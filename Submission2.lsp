
(load "~/Documents/Uni/sem 2/NRTS/Code/Pieces/Sub2/Sub2ExternalFunctions.lsp")

(let*
    (
     (ensemble '((tr (b-flat-trumpet :midi-channel 1))
		 (sx (alto-sax :midi-channel 2))
		 (cl (b-flat-clarinet :midi-channel 3))
		 (cp (computer :midi-channel 4))))
     (instruments (loop for i in ensemble collect (first i)))
     (init-direction-seq (loop for i in instruments
			    for j from 0
			      for k from 1 to (* 2 (length instruments)) by 2
			    collect (list i (evenp j) k)))
     (instr-rotation (make-assoc-list 'rotations
				      (loop for i in instruments
					 for j in '(5 4 8 3)
					 collect (list i j))))
     (instr-direction (make-assoc-list 'direction
				      (loop for i in instruments
					 for j from 0 ;; ()
					 collect (list i (evenp j)))))
     (instr-comb
      (append 
	 (k-combinations instruments 1)
	 (k-combinations instruments 2)
	 (k-combinations instruments 3)
	 (list instruments)))
     ;; create chopped items and resort palette
     (orig-palette (make-rsp 'orig 
                               '((seq1 ((((5 4) (e) q q q e e e))
					:pitch-seq-palette ((1 2 3 4 5 6)
							    (8 4 3 1 10 2))))
				 (seq2 ((((3 4) (e) q q. ))
					:pitch-seq-palette ((12 (20)))))
                                 )))
     (chopped-palette (chop orig-palette 
                              '((1 4)
				(1 3) (2 4)
				(1 2) (2 3) (3 4)
				(1 1) (2 2) (3 3) (4 4))
                              's))
     (simplechop (chop-simplified chopped-palette))
     (time-sigs (ts-in-chop simplechop))
     (seqs-by-ts (loop for s in time-sigs
		    collect (get-chop-pairs (get-chops-by-ts s simplechop))))
     (chopseqs (get-chop-pairs (get-non-empty-seqs simplechop)))
     (numsections (length instr-comb))
     (numloops-section (length simplechop))
     (set-map-loop (loop for i from 1 to numsections
			    collect
			      (list i
				    (fibonacci-transitions 80 '(s1 s2)))))
     ;; loop that creates the rthmseqmap
     ;; TODO create cycling structure between instrument ensemble
     (ensembleloop (loop repeat (* numsections (length instr-comb))
		      append (loop for i in instr-comb
				collect i)))
     (rthmmap (loop for sec in instr-comb
		 for counter from 1 
		 collect (list counter
			       (loop for i in sec
				  for dir = (get-data-data i instr-direction)
				  for rot = (get-data-data i instr-rotation)
				  collect (list i
						(loop for ts in seqs-by-ts
						   append (rotate-list ts dir rot)))
				  finally 
				    (replace-data i (not dir) instr-direction)))))
     (rthmmap2 (loop for i in instr-comb
		  for seccounter from 1 to (length instr-comb)
		  collect (list seccounter
				(loop for section in i
				   collect (list section
						 ;; TODO change here to retrieve different lists
						 ;; according to section and instrument rules
						 (loop repeat numloops-section
						    for seq in chopseqs
					  collect seq))))))
     ;; create loop of palettes for using in the final instrument loop
     ;; create loop of tempo instructions according to rules
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
	     
	     )))
  ;; (print (loop for i in ensemble collect i))
  ;; (print (length chopseqs))
  ;; (print chopts)
  ;; (print set-map-loop)
  (print numloops-section)
  ;; (print (swap-elements instr-comb))
  ;; (print (merge 'list (k-combinations instruments 1) (k-combinations instruments 2) #'equal))
  ;; (print retro-rh)
  ;; (cmn-display cycle)
  (re-bar cycle :min-time-sig '(4 4))
  ;; (print time-sigs)
  ;; (print instr-comb)
  ;; (print (loop for l in seqs-by-ts
  ;; 	    for (dir val) in '((t 5) (nil 6) (t 8) (nil 6))
  ;; 	    collect (rotate-list l dir val)))
  ;; (print rthmmap)
  ;; (print rthmmap2)
  ;; (print (first seqs-by-ts))
  (print (loop for i in instruments
	      collect (get-data-data i instr-direction)))
  ;; this one rotates the list according to the conditionals
  ;; (print (loop for sec in instr-comb
  ;; 	    for counter from 1 
  ;; 	    collect (list counter
  ;; 			  (loop for i in sec
  ;; 			     for dir = (get-data-data i instr-direction)
  ;; 		 for rot = (get-data-data i instr-rotation)
  ;; 		       collect (list i
  ;; 				     (loop for ts in seqs-by-ts
  ;; 					append (rotate-list ts dir rot)))
  ;; 		 finally 
  ;; 			 (replace-data i (not dir) instr-direction)))))
  ;; (print (loop for i in instruments
  ;; 	    collect (get-data-data i instr-direction)))
  ;; (print (loop for i in instr-comb
  ;; 	    for seccounter from 1 to (length instr-comb)
  ;; 	    collect (list seccounter
  ;; 			  (loop for section in i
  ;; 			     collect (list section
  ;; 				       (loop repeat numloops-section
  ;; 					  for seq in chopseqs
  ;; 					  collect seq))))))
  ;; (write-lp-data-for-all cycle :base-path "~/Documents/uni/sem 2/NRTS/Code/Pieces/Sub2/Score/")
  (midi-play cycle :midi-file "~/Documents/uni/sem 2/NRTS/Code/Pieces/MIDI/cycle1.mid" )
  )


