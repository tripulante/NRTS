;;; little Slippery Chicken template
;;; @author John Palma

;;; main slippery chicken function
;;; creates a sc object containing the information for the piece
(make-slippery-chicken
 ;;; global name for the sc object. an sc piece can be recalled outside the main function by using this name
 ;;; to generate scores or a midi file
 '<+sc object name+>
;;; piece title in double quotes e.g. "My Piece"
         :title <piece title (string)>
;;; instrument palette <palette definition>
	 ;;; defines a set of instruments to be used throughout the piece. new palettes and instruments can be created if needed
	 :instrument-palette <global instrument palette variable or create new instrument palette>
;;; declares a variable name for each instrument in the piece and defines it according to the instrument palette declared above
;;; the <instrument name> is the variable used to refer to that instrument in the sc object
;;; <instrument> refers to the instrument definition available in the instrument-palette
         :ensemble '(((<instrument 1 name> (<instrument> :midi-channel <midi channel number>))
                      (<instrument 2 name> (<instrument> :midi-channel <midi channel number>))
					; ...
                      (<instrument n name> (<instrument> :midi-channel <midi channel number>))))
;;; defines how many groups should be created and which instruments should be in it
;;; takes the ensemble instruments in order
	 :staff-groupings '(<instrument grouping numbers>)
;;; tempo-map ((<tempo map declaration>))
	 ;;; defines any tempo changes through the piece
	 ;;; tempo changes can be pointed to sections and specific sequences and bars within those
	 ;;; units are regular rhythm figures (e.g. e, q, etc.)
	 :tempo-map '((<measure> (<base unit> <tempo> <optional text description>))
		      ; and/or
		      ((<section id> <sequence id> <bar>) (<base unit> <tempo>)))
	 ;;; defines a tempo curve instead of a map
	 ;;; the frequency defines how often tempo changes will be printed (in bars)
	 ;;; the breakpoint pair defines a point curve and a bpm value. the curve adapts to sequences, not bars or notes
	 ;;; the first point in the curve should be 0
	 ;;; the bpm defines the tempo value at that point in the curve. here is an example:
	 ;;; :tempo-curve '(10 q (0 60 30 144 75 52 100 120))
	 :tempo-curve '(<frequency of tempo display> <base unit> (<breakpoint envelope - bpm pair>))
	 ;;; defines the note range for a particular instrument
	 ;;; an error happens if the instrument has no notes available between this range in the palette
;;; should use the same instrument name declared in the ensemble section
         :set-limits-high '((<instrument 1 name> (<initial % of piece> <note> <final piece %> <note>))
                            (<instrument 2 name> (<initial % of piece> <note> <final piece %> <note>))
					; ...
                            (<instrument n name> (<initial % of piece> <note> <final piece %> <note>)))
	 :set-limits-low '((<instrument 1 name> (<initial % of piece> <note> <final piece %> <note>))
                            (<instrument 2 name> (<initial % of piece> <note> <final piece %> <note>))
					; ...
                            (<instrument n name> (<initial % of piece> <note> <final piece %> <note>)))
;;; set-palette (<palette definition>)
;;; palette of pitch collections to be used in the piece.
	 :set-palette '((<set name> (<note list>))
			(<set name> (<note list>))
					; ...
			(<set n name> (<note list>)))
;;; set-map (<map definition>)
;;; uses the notes from the palettes defined earlier
;;; defines when the pitches are being used
;;; There must be the same number of sequences in each section of the set-map as there are sequences in each section of the rthm-seq-map.
;;; Each set applies to an entire rthm-seq, which may consist of multiple measures.
	 :set-map '((<section 1 id number> (<palette set combination>))
		    (<section 2 id number> (<palette set combination>)))
					; ...
;;; rhhm-set-palette (<rhythm set definiton>) <time signature> e.g. 2 4
	 ;;; defines a set of rhythm sequences to be used throughout the piece. these can be assigned to different instruments every time
	 ;;; and reused if needed
	 :rthm-seq-palette '((<rhythm seq 1 name> ((((<time signature>) <rhythm sequence>))
						   ;; pitch-set-palette ((<pitch linear contour>))
						   ;; defines contours for a particular rhythm sequence
						   ;; chords are defined in parenthesis e.g. 1 (4) 3 (3)
						   ;; default chords depend on the instrument and the chord function
						   ;; a pitch sequence can be assigned to a particular instrument and
						   ;; multiple pitch curves can be defined
						   :pitch-seq-palette ((<pitch sequence>))
						   ;; marks <mark sequence>
						   ;; define articulations and dynamics for a particular rhythm set
						   ;; They are defined as <single mark> <index of rhythm object>
						   ;; e.g. (a 5) -> put an accent on the 5th rhythm unit 
						   :marks (<marks sequence>)
						   ))
			     (<rhythm seq 2 name> ((((<time signature>) <rhythm sequence>))
						   :pitch-seq-palette ((<pitch sequence>))))
					; ...
			     (<rhythm seq n name> ((((<time signature>) <rhythm sequence>))
						   :pitch-seq-palette ((<pitch sequence>)))))
;;; rthm-seq-map (<map definition>)
;;; maps the different sections to the rhythm sequences created in rhtm-set-palette
	 ;;; it has to match the same number of sections defined in set-map and use the same ids
	 ;;; it has to have the same number of rhythm sequences as palette sequences defined in each of the maps
	 :rthm-seq-map '((<section 1 id number> ((<instrument 1 name> (<rhythm seq name sequence>))
					  (<instrument 2 name> (<rhythm seq name sequence>))
					  (<instrument n name> (<rhythm seq name sequence>))))
			 (<section 2 id number> ((<instrument name> (<rhythm seq name sequence>))))
					; ...
			 (<section n id number> ((<instrument name> (<rhythm name sequence>))))
			 )
;;; checks the output directory for soundfiles. has to be a double quoted string e.g. "\tmp\"
	 :snd-output-dir <output directory path>
	 ;;; determines a soundfile palette (a list of sound files to be used)
	 :sndfile-palette '(((<soundgroup 1 id> ((<filename 1> <optional properties>)
					       (<filename 2> <optional properties>)
					;;...
					       (<filename n> <optional properties>)))
			     (<soundgroup 2 id> ((<filename 1> <optional properties>)
					       (<filename 2> <optional properties>)
					;;...
						 (<filename n> <optional properties>)))
			     ;;...
			     (<soundgroup n id> ((<filename 1> <optional properties>)
					       (<filename 2> <optional properties>)
					;;...
						 (<filename n> <optional properties>))))
			    ;; can be multiple paths
			    ,(<path-to-soundfiles>)
			    )
	 ))

;;; extra functions
;;; outputs and plays a midi file
(midi-play <global or local sc object> :midi-file <path-to-file>)
;;; outputs the sc generated score
(cmn-display <global or local sc object> :file <path-to-eps-file>)
;;; outputs a sound file from the score using the events from the sc object as basis
;;; can generate multiple files depending on the players or the soundgroup used
;;; if nil is used instead of a player it will take information from all players
(clm-play <global or local sc object> 1 '(<players used as basis>) '<soundgroup id>)
;;; gets a particular note from the sc object to edit it
(get-note <global or local sc variable> <bar> <note> '<instrument id>)
;;; adds marks after processing
(add-mark-to-note <global or local sc variable> <bar> <event> '<instrument> '<mark>)
;;; writes the lilypond information. all lilypond files are created and stored on the defined directory
(write-lp-data-for-all <global or local sc object> :base-path <path-to-dir>)

