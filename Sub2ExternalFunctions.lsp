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
(defun get-simplified-chop-by-signature (ts simplified-palette)
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
  (loop for i in simplified-palette
     collect (list (first i)
		   (remove-duplicates
		    (loop for j in (second i)
		       collect (first (second j)))))))
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
