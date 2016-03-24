
(load "~/Documents/Uni/sem 2/NRTS/Code/Pieces/Sub2/Sub2ExternalFunctions.lsp")

(let*
    (
     (ensemble '((tr (b-flat-trumpet :midi-channel 1))
		 (sx (alto-sax :midi-channel 2))
		 (cl (b-flat-clarinet :midi-channel 3))
		 (cp (computer :midi-channel 4))))
     (instruments (loop for i in ensemble collect (first i)))
     (instr-comb
       (append
       (k-combinations instruments 1)
       (k-combinations instruments 2)
       (k-combinations instruments 3)
       (list instruments)))
     ;; create chopped items and resort palette
     (orig-palette (make-rsp 'orig 
                               '((seq1 ((((5 4) (e) q q q e e e))
					:pitch-seq-palette ((1 2 3 4 5 6))))
				 (seq2 ((((3 4) (e) q q. ))
					:pitch-seq-palette ((12 (20)))))
                                 )))
     (chopped-palette (chop orig-palette 
                              '((1 4)
				(1 3) (2 4)
				(1 2) (2 3) (3 4)
				(1 1) (2 2) (3 3) (4 4))
                              's))
     (simplechop (sort-simplified-chop (chop-simplified chopped-palette)))
     (chopts (ts-in-chop simplechop))
     (chopseqs (get-chop-pairs (get-non-empty-seqs simplechop)))
     (numsections 3)
     (numloops-section 44)
     (set-map-loop (loop for i from 1 to numsections
			    collect
			      (list i
				    (loop repeat numloops-section
				       collect 'set1))))
     ;; loop that creates the rthmseqmap
     ;; TODO create cycling structure between instrument ensemble
     (ensembleloop (loop repeat (* numsections (length instr-comb))
		      append (loop for i in instr-comb
			collect i)))
     (rthmmap (loop for i from 1 to numsections
		 collect
		   (list i
			 (loop for j in instruments
			    collect (list j
					  (loop repeat numloops-section
					     for k in chopseqs
						     collect k))))))
     ;; create loop of palettes for using in the final instrument loop
     ;; create loop of tempo instructions according to rules
     (cycle (make-slippery-chicken
	     '+cycle+
	     :title "Cycling 2"
	     :composer "John Palma"
	     :ensemble `(,(loop for i in ensemble collect i))
	     :set-palette '((set1 ((f4 g4 a4 b4 cs5 ds5 f2 g2 a2 b2 cs3 ds3))))
	     :tempo-map '((1 (q 120)))
	     :set-map set-map-loop
	     :rthm-seq-palette chopped-palette
	     :rthm-seq-map rthmmap
	     
	     )))
  ;; (print (loop for i in ensemble collect i))
  (print (length chopseqs))
  (print (wrap-list instr-comb 1))
  ;; (print set-map-loop)
  ;; (print instr-comb)
  ;; (print (merge 'list (k-combinations instruments 1) (k-combinations instruments 2) #'equal))
  ;; (print retro-rh)
  ;; (cmn-display cycle)
  (re-bar cycle :min-time-sig '(4 4))
  (write-lp-data-for-all cycle :base-path "~/Documents/uni/sem 2/NRTS/Code/Pieces/Sub2/Score/")
  (midi-play cycle :midi-file "~/Documents/uni/sem 2/NRTS/Code/Pieces/MIDI/cycle1.mid" )
  )
