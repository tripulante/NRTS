;;; possible rhythms: h
;;; { 3 tq tq tq }
;;; { 5 - fs fs fs fs fs - }
;;; { 3 te te te}
;;; (q) e (e)
;;; (e) e (e)

(in-scale :chromatic)
(add
  (make-instrument 'snare
                   :staff-name "Snare" :staff-short-name "sd"
                   :lowest-written 'g3 :highest-written 'a6 
                   :starting-clef 'percussion 
                   :chords nil :microtones nil :missing-notes nil
                   :midi-program 26)
  +slippery-chicken-standard-instrument-palette+)
(add
 (make-instrument 'sample
		  :staff-name "Sample" :staff-short-name "spl"
		  :lowest-written 'c4 :highest-written 'c5
		  :starting-clef 'percussion
		  :chords nil :microtones T :missing-notes nil
		  :midi-program 26)
 +slippery-chicken-standard-instrument-palette+)

(let* ((mini
        (make-slippery-chicken
	 '+mov1+
         :title "Sub1"
	 :composer "John Palma"
	 :instrument-palette +slippery-chicken-standard-instrument-palette+
         :ensemble '((
		      (pitch-sm (sample :midi-channel 1))
		      (sd (snare :midi-channel 2))
                      (sm_one (sample :midi-channel 3))
		      (sm_two (sample :midi-channel 4))
		      (sm_three (sample :midi-channel 5))
		      (sm_four (sample :midi-channel 6))
		      ))
	 :staff-groupings '(1 1 4)
	 :tempo-map '((1 (q 120)))
	 ;:set-limits-high '((sd (0 c4 100 c4)))
	 ;:set-limits-low '((sm_one (0 c4 100 c4)))
	 :set-palette '((set1 ((f5 c6 f6 c6 bf3 ef3 c4)))
			(set2 ((e4 gs4 b4 af2 ef3)))
			)
	 :set-map '((1 (set1 set1 set1 set1 set1 set1
			set1 set1 set1 set1 set1 set1
			set1 set1 set1 set1 set1 set1))
		    )
	 :rthm-seq-palette '((r1 ((((5 4) (w) (q) )
				   ( w+q )
				   ( +w+q )
				   ( w+q )
				   ( +w+q )
				   ( +w+q ))
				  :pitch-seq-palette ((1 1) ; 25
						      )
;				  :marks (slur 1 24)
				  ))
			     (r2 ((((5 4) q x 5)
				   ( (e) e (e) e q (q) q )
				   ( (e) e { 3 (tq) te } { 3 - te x 3 - } (e) e (e) e )
				   ( - s e s - q - +s s x 3 - e e (q) )
				   ( - s x 4 e. s e e e. s s s e - )
				   ( - e s s - - e s s - q - s x 4 - q))
				  :pitch-seq-palette ((1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1  
							 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)) ; 26
				  :marks (t3 1)
				  ))
			     (r3 ((((5 4) (h.) (e) e (e) e)
				   ( - e s s - q - e e - - s s e - q)
				   ( q q (q) q q)
				   ( - e e - (h) (q) (e) e)
				   ( (q) q. e (e) e (e) e)
				   ( - e. s - h - e e - - e. s -))
				  :pitch-seq-palette ((1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1))
				  ))
			     (r4 ((((5 4) q { 3 te te te } q (e) q (e))
				   ((h.) (e) q.)
				   (+e q e (e) e s s q (e))
				   ((e) q q q q (e))
				   (e e+h (h))
				   ( q x 3 { 3 te x 3 } (q)))
				  :pitch-seq-palette ((1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))))
			     (r5 ((((5 4) { 3 tq tq tq } (q) h )
				   (+h q (h))
				   ({ 5 fe fe fs fe fe fs } (q) h)
				   ({ 5 fe fe fs fe fe fs } (q) (e) { 3 tq te } (e))
				   ((h) e e { 3 te x 3 } s x 4)
				   ((h) { 3 tq te } e x 4))
				  :pitch-seq-palette ((1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1))))
			     (r6 ((((5 4) h. (h) )
				   ({ 3 - te x 3 - } q q (h))
				   ((q) e x 4 (e) e (e) e)
				   (+e q x 4 (e))
				   (q h h)
				   ((w) (q)))
				  :pitch-seq-palette ((1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 ))))
			     (r7 ((((5 4) (q) e. s (q) q s s e)
				   ((q) e. s (q) e q e)
				   ((q) e. s (q) q (q))
				   ((q) e. s (q) e q e)
				   ((q) e. s (q) q (e) e)
				   ((q) e. s (q.) e (e) e))
				  :pitch-seq-palette ((1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1))))
			     (r8 ((((5 4) q (q) q (h))
				   (q (q) q (e) q (e))
				   (q (q) q (q) s s e)
				   (h s e. (e) q (e))
				   (q (q) q (e.) s s (e.))
				   (q (q) q h))
				  :pitch-seq-palette ((1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1))))
			     (r9 ((((5 4) s e. (h.) s e.)
				   ((h.) s e. s e.)
				   ((h.) s x 4 s e.)
				   (s e. (h.) s e.)
				   ((h.) s e. s e.)
				   ((h.) s x 4 s e.))
				  :pitch-seq-palette ((1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1))))
			     (r10 ((((5 4) (q) e. s q e. s (q))
				   (e. s q e. s (e.) s (q))
				   (e. s q e. s (h))
				   ((q) e. s q e. s (q))
				   (e. s q e. s (e.) s (q))
				   (e. s q e. s (h)))
				  :pitch-seq-palette ((1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1 1))))
			     )
	 :avoid-melodic-octaves nil
	 :rthm-seq-map '((1 ((pitch-sm (nil nil r6  r3  nil nil nil r2  r9  nil nil r10 r8  nil nil r9  r6 r10))
			     (sd       (nil nil r5  r2  nil nil nil nil nil r6  r1  nil nil r5  r1  r8  r5 r9))
			     (sm_one   (r10 r8  nil nil r10 nil nil r1  nil r5  nil r9  nil r4  nil r7  r4 r8))
			     (sm_two   (r9  r7  nil nil nil r7  nil nil r8  nil r4  nil r7  nil r5  r10 r3 r7))
			     (sm_three (nil nil r4  nil r9  r6  r4  r10 nil nil r3  nil r6  r3  nil nil r2 r6))
			     (sm_four  (nil nil nil r1  r8  r5  r3  nil r3  r7  nil r2  nil nil r2  nil r1 r5))
			     ))
			 )			 
	 )))
  (loop for n in '((sm_one "Sample 1" "smp 1") (sm_two "Sample 2" "smp 2")
		   (sm_three "Sample 3" "smp 3") (sm_four "Sample 4" "smp 4"))
     do 
       (setf (staff-name 
              (get-data-data (first n) (ensemble mini))) 
             (second n))
       (setf (staff-short-name 
              (get-data-data (first n) (ensemble mini)))
             (third n)))
  (setf (staff-name (get-data-data 'pitch-sm (ensemble mini))) "Pitched Sample")
  (setf (staff-short-name (get-data-data 'pitch-sm (ensemble mini))) "P. Smp")
  (midi-play mini :midi-file "~/Documents/uni/sem 2/NRTS/Code/Pieces/Midi/Sub1.mid")
  (cmn-display mini :file "~/Documents/uni/sem 2/NRTS/Code/Pieces/Sub1/Score/Sub1.eps")
  (write-lp-data-for-all mini :base-path "~/Documents/uni/sem 2/NRTS/Code/Pieces/Sub1/Score/"))

