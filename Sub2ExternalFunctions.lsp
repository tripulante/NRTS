;;auxiliary functions created to deal with chop results
;; based on a chopped rs palette creates a simplified version
(defun chop-simplified (chopped-rsp)
  (loop for rsps in (data chopped-rsp)
     collect
       (list (id rsps)
	     (loop for rseq in (data (data rsps))
		collect
		  (list (id rseq)
			(loop for bar in (bars rseq)
			   append (list
				   (data (get-time-sig bar))
				   (not (all-rests? bar)))))))))
;; function created to sort the palettes
(defun compare-time-sig (a b)
  (cond ((= (second (first (second a)))
	    (second (first (second b))))
	 (< (first (first (second a)))
	    (first (first (second b)))))
	(t (< (second (first (second a)))
	      (second (first (second b)))))))
;; sorts the simplified palette by time signature
;; returns a list in the simplified palette format
(defun sort-simplified-chop (simplified-palette)
  (loop for i in simplified-palette
     collect (list (first i) (sort (second i) #'compare-time-sig))))
;; gets the non empty chops from a simplified palette
;; returns a list in the simplified palette format
(defun get-non-empty-seqs (simplified-palette)
  (loop for i in simplified-palette
     collect
       (list (first i)
	     (remove nil
		     (loop for j in (second i)
			collect
			  (cond
			    ((not (null (second (second j))))
			     j)))))))
;; returns a list in the simplified palette format with empty rs
(defun get-empty-seqs (simplified-palette)
  (loop for i in simplified-palette
     collect
       (list (first i)
	     (remove nil
		     (loop for j in (second i)
			collect (cond
				  ((null (second (second j)))
				   j)))))))
;; takes a simple palette and returns it as a list of
;; (original-sequence-name chop-id) pairs
(defun get-chop-pairs (simplified-palette)
  (loop for i in simplified-palette 
     append (loop for j in (second i)
	       collect (list (first i) (first j)))))
;; takes a simple palette and returns the ones with time signature ts
;; ts is a two item list e.g. (1 4)
(defun get-chops-by-ts (ts simplified-palette)
  (loop for i in simplified-palette
     collect (list (first i)
		   (remove nil
			   (loop for j in (second i) 
			      collect
				(cond ((equal ts
					      (first (second j))) j)))))))
;; returns a list with the time sequences in a simple palette
;; ((original-sequence-id (time-signatures)))
(defun ts-in-chop (simplified-palette)
  (remove-duplicates
   (loop for i in simplified-palette
     append 
	(loop for j in (second i)
	   collect (first (second j))))))
;; returns the k-combinations of a list. k <= (length l)
(defun k-combinations (l k)
  (reverse (loop for i in
		(remove-duplicates
		 (list-permutations l k)
		 :test
		 #'(lambda (l1 l2)
		     (= (length l1) (length l2)
			(length (intersection l1 l2)))))
	      collect (reverse i))))
;; rotates a list according to the direction given
;; dir = 0 means clockwise, anything else is counter-clockwise
(defun rotate-list (l dir wrap)
  (cond ((not dir) (wrap-list l (mod wrap (length l))))
	(t (wrap-list (reverse l) (mod wrap (length l))))))
;; this function implements a logistic map
;; https://en.wikipedia.org/wiki/Logistic_map
(defun logistic-map (x r)
  (* x r (- 1 x)))
;; this function scales values like the Max object scale
(defun scale-value (value oldMin oldMax newMin newMax)
  (+ (/ (* (- value oldMin)
	   (- newMax newMin)) (- oldMax oldMin)) newMin))
;; Runs the logistic map n times, starting from an initial x0
;; value and then scales it to (min max) values
;; no error checking
(defun logistic-curve (x0 r n min max)
  (loop repeat n
     for x = (logistic-map x0 r)
     then (logistic-map x r)
     collect (round (scale-value x 0 1 min max))))
;; returns a set of curves for a chopped palette
(defun chop-curves (chopped-palette)
    (loop for rsps in (data chopped-palette)
       for id-rsps = (id rsps)
       append
	 (loop for rseq in (data (data rsps))
	    for id-seq = (id rseq)
	    collect (list (list id-rsps id-seq)
			  (loop for pal
			     in (data (pitch-seq-palette rseq))
			     for curve = (data pal)
			     collect curve)))))

