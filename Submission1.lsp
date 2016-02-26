(get-sc-config 'default-dir)

(in-scale :chromatic)
(let* ((p (make-l-for-lookup 'lsys
			     '((1 ((3)))
			       (2 ((1)))
			       (3 ((4)))
			       (4 ((5)))
			       (5 ((7))))
			     '((1 (2 3))
			       (2 (4 5))
			       (3 (2))
			       (4 (5 1))
			       (5 (2 3))))
			     )
       (p1 (flatten (do-simple-lookup p 1 8)))
       )
  (print p1)
)

(let*
    ((snd-file-dir "~/Documents/uni/sem 2/NRTS/Code/Pieces/Sub1/Files/")
     (output-file-dir "~/Documents/uni/sem 2/NRTS/Code/Pieces/Snd/")
     (looktempos (make-l-for-lookup 'lsys
				'((1 ((120)))
				  (2 ((85)))
				  (3 ((100))))
				'((1 (2 3))
				  (2 (1 2))
				  (3 (1)))))
     (tempolist (flatten (do-simple-lookup looktempos 1 18)))
     (t_curve (flatten (loop for i from 0 to 18
		 for j in tempolist
			  collect (list i j))))
     ;;pitch
     (pitchcurve (make-l-for-lookup 'lsys
			     '((1 ((5)))
			       (2 ((1)))
			       (3 ((4)))
			       (4 ((2)))
			       (5 ((7))))
			     '((1 (2 3))
			       (2 (4 5))
			       (3 (2))
			       (4 (5 1))
			       (5 (2 3)))))
     (mini
        (make-slippery-chicken
	 '+mov1+
         :title "Sub1"
	 :composer "John Palma"
	 :instrument-palette '((sample (:staff-name "Sample" :staff-short-name "spl"
					:lowest-written b4 :highest-written b5
					:starting-clef percussion
					:chords nil :microtones T :missing-notes nil
					:subset-id sm-note
					:midi-program 26
					:staff-lines 1))
			       (psample (:staff-name "Pitched Sample" :staff-short-name "ps"
					:lowest-written c4 :highest-written c6
					:starting-clef treble
					:chords nil :microtones T :missing-notes nil
					:midi-program 26)))
	 
         :ensemble '(((pitch-sm (psample :midi-channel 1))
		      (sd (sample :midi-channel 2))
                      (sm_one (sample :midi-channel 3))
		      (sm_two (sample :midi-channel 4))
		      (sm_three (sample :midi-channel 5))
		      (sm_four (sample :midi-channel 6))))
	 :staff-groupings '(1 1 4)
;	 :tempo-map '((1 (q 100)) (36 (q 85)) (72 (q 120)))
	 :tempo-curve `(10 q ,t_curve)
	 :set-palette '((set1 ((b4 e4 gs4 b5 fs2 b6 ds5 fs5)
			       :subsets ((sm-note (b4))))))
	 :set-map '((1 (set1 set1 set1 set1 set1 set1
			set1 set1 set1 set1 set1 set1
			set1 set1 set1 set1 set1 set1)))
	 :rthm-seq-palette `((r1 ((((5 4) (w) (q) )
				   ( w+q )
				   ( +w+q )
				   ( w+q )
				   ( +w+q )
				   ( +w+q ))
				  :pitch-seq-palette ((1 2))
				  :marks (p 1 slur 1 2)))
			     (r2 ((((5 4) q x 5)
				   ( (e) e (e) e q (q) q )
				   ( (e) e { 3 (tq) te } { 3 - te x 3 - } (e) e (e) e )
				   ( - s e s - q - +s s x 3 - e e (q) )
				   ( - s x 4 e. s e e e. s s s e - )
				   ( - e s s - - e s s - q - s x 4 - q))
				  :pitch-seq-palette ((1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1)
						      (,(procession 50 7) psample))
				  :marks ( p 1 cresc-beg 1 cresc-end 5 f 6 dim-beg 20 dim-end 50)))
			     (r3 ((((5 4) (h.) (e) e (e) e)
				   ( - e s s - q - e e - - s s e - q)
				   ( q q (q) q q)
				   ( - e e - (h) (q) (e) e)
				   ( (q) q. e (e) e (e) e)
				   ( - e. s - h - e e - - e. s -))
				  :pitch-seq-palette ((1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1)
						      (,(flatten (do-simple-lookup pitchcurve 1 30)) psample))
				  :marks (p 1 mf 3 dim-beg 3 dim-end 30)))
			     (r4 ((((5 4) q { 3 - te te te - } q (e) q (e))
				   ((h.) (e) q.)
				   (+e q - e (e) e s s - q (e))
				   ((e) q q q q (e))
				   (e e+h (h))
				   ( q x 3 { 3 - te x 3 - } (q)))
				  :pitch-seq-palette ((1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1)
						      (,(flatten (do-simple-lookup pitchcurve 1 25)) psample))
				  :marks (p 1 dim-beg 1 dim-end 7 pp 7 cresc-beg 19 cresc-end 25)))
			     (r5 ((((5 4) { 3 tq tq tq } (q) h )
				   (+h q (h))
				   ({ 5 - fe fe fs fe fe fs - } (q) h)
				   ({ 5 - fe fe fs fe fe fs - } (q) (e) { 3 tq te } (e))
				   ((h) - e e { 3 te x 3 } s x 4 -)
				   ((h) { 3 tq te } - e x 4 -))
				  :pitch-seq-palette ((1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1))
				  :marks (p 1 ff 6 fff 33)))
			     (r6 ((((5 4) h. (h) )
				   ({ 3 - te x 3 - } q q (h))
				   ((q) - e x 4 (e) e (e) e -)
				   (+e q x 4 (e))
				   (q h h)
				   ((w) (q)))
				  :pitch-seq-palette ((1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 )
						      (,(flatten (do-simple-lookup pitchcurve 1 19)) psample))
				  :marks ( f 1 dim-beg 1 dim-end 6 p 6 f 7 dim-beg 13 dim-end 16 mf 16 pp 19)))
			     (r7 ((((5 4) (q) - e. s - (q) q - s s e -)
				   ((q) - e. s - (q) e q e)
				   ((q) - e. s - (q) q (q))
				   ((q) - e. s - (q) e q e)
				   ((q) - e. s - (q) q (e) e)
				   ((q) - e. s - (q.) - e (e) e - ))
				  :pitch-seq-palette ((1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1)
						      (,(flatten (do-simple-lookup pitchcurve 1 27)) psample))
				  :marks (f 2 dim-beg 6 dim-end 8 mf 8 pp 14 ff 20
					   dim-beg 21 dim-end 23 p 25)))
			     (r8 ((((5 4) q (q) q (h))
				   (q (q) q (e) q (e))
				   (q (q) q (q) - s s e -)
				   (h - s e. - (e) q (e))
				   (q (q) q (e.) - s s - (e.))
				   (q (q) q h))
				  :pitch-seq-palette ((1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1))
				  :marks (ff 2 mf 4 dim-beg 5 dim-end 10 pp 10 dim-beg 11 dim-end 14 ff 14
					     dim-beg 14 dim-end 16 mf 16 cresc-beg 16 cresc-end 20 f 20)))
			     (r9 ((((5 4) - s e. - (h.) - s e. -)
				   ((h.) - s e. s e. -)
				   ((h.) - s x 4 s e. -)
				   (- s e. - (h.) - s e. -)
				   ((h.) - s e. s e. -)
				   ((h.) - s x 4 s e. -))
				  :pitch-seq-palette ((1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1))
				  :marks (f 3 cresc-beg 3 cresc-end 7 ff 7 pp 12
					    cresc-beg 12 cresc-end 21 f 21 dim-beg 21 dim-end 24 mf 24)))
			     (r10 ((((5 4) (q) - e. s - q - e. s - (q))
				   (- e. s - q - e. s (e.) s - (q))
				   (- e. s - q - e. s - (h))
				   ((q) { 6 - ts x 2 te. ts - } q - e. s - (q))
				   (- e. s - q - e. s (e.) s - (q))
				   (- e. s - q - e. s - (h)))
				  :pitch-seq-palette ((1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1 1 1 1 1 1 1 1 1 1
							 1 1 1 1))
				   :marks (f 1 dim-beg 1 dim-end 11 pp 11 ff 12
					     p 17 cresc-beg 17 cresc-end 20 f 20 dim-beg 25 dim-end 28 pp 29)))
			     ;; created to manage bug in clm-play
			     (sil ((((5 4) (w)(q))
				    ((w)(q))
				    ((w)(q))
				    ((w)(q))
				    ((w)(q))
				    ((w)(q)))
				   :pitch-seq-palette (()))))
	 :avoid-melodic-octaves nil
	 :rthm-seq-map '((1 ((pitch-sm (sil sil sil sil sil sil  r3 r3  r4  r4  r9  r8   r7  r5  sil r1  r6  r10))
			     (sd       (r9  sil r2  sil sil r7   r4 r4  r5  sil r4  sil  r4  sil r9  r8  r5  r2))
			     (sm_one   (sil r10  sil sil r3  r2  r5 r5  r6  r5  sil sil  r6  r4  r4  sil sil r5)) 
			     (sm_two   (sil r5  sil r3  r5  r5   r6 r6  r7  r3  sil sil  r7  sil sil sil r3  r8)) 
			     (sm_three (sil sil r10 r7  sil r3   r7 r7  sil r2  sil sil  r8  r3  r6  r1  sil r6))
			     (sm_four  (sil sil r9  r1  r9  sil  r8 sil sil sil sil sil  r5  r8  sil sil r2  r3)))))
	 :snd-output-dir (get-sc-config 'default-dir)
	 :sndfile-palette `(((sg_1 ((psample)
			       (snare)
			       (sample1)
			       (sample2)
			       (sample6)
			       (sample5)
			       (piano_G6)
			       (p-1C)
			       (sample7)
			       (sample8)
			       (sample9)
			       (sample11)))
			     (sg_ps ((piano_G6))))
			    (,snd-file-dir)
			    ("wav"))
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
  (setf (staff-name (get-data-data 'sd (ensemble mini))) "Snare")
  (setf (staff-short-name (get-data-data 'sd (ensemble mini))) "Sd")
  (midi-play mini :midi-file "~/Documents/uni/sem 2/NRTS/Code/Pieces/Midi/Sub1.mid")
  (cmn-display mini :file "~/Documents/uni/sem 2/NRTS/Code/Pieces/Sub1/Score/Sub1.eps")
  (auto-slur mini '(pitch-sm) 
               :over-accents nil
               :rm-staccatos nil)
  (clm-play mini 1 nil 'sg_1 :rev-amt 0.05)
  (clm-play mini 1 nil 'sg_ps :rev-amt 0.05)
;  (clm-play mini 1 '(sd sm_one sm_two sm_three sm_four) 'sg_1 :rev-amt 0.05)
  (clm-play mini 1 '(pitch-sm) 'sg_ps)
  (write-lp-data-for-all mini :base-path "~/Documents/uni/sem 2/NRTS/Code/Pieces/Sub1/Score/"))
