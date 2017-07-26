;; 
;; racket-against-humanity: A Cards Against Humanity generator, in Racket
;; Copyright (C) 2017  Zachary Espiritu (http://zacharyespiritu.com)
;; 
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU Affero General Public License as published
;; by the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Affero General Public License for more details.
;; 
;; You should have received a copy of the GNU Affero General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;

#lang racket/gui
(require 2htdp/image)
(require pollen/unstable/typography)

; Data Definitions
 
; A ZebraColor is one of: 
; – "white"
; – "black"
; interpretation a String that is either "white" or "black"

; A List-of-strings is one of: 
; – '()
; – (cons String List-of-strings)
; interpretation a list of Strings

; Mutables

(define (card-color) "white")
(define (text-color) "black")

; Functions

; make-cards :: ZebraColor ->
; Generates Cards Against Humanity for the specified color. Captions
; must be specified in a .txt file of the color's name: "white.txt" or
; "black.txt". Cards will be exported to the ./white-cards or
; ./black-cards directory. Template images must be included in the
; ./template-images directory.
(define (make-cards color)
  (set! card-color color)
  (cond
    [(equal? card-color "white")
      (set! text-color "black")]
    [else
      (set! card-color "black")
      (set! text-color "white")])
  (display-welcome-message)
  (captions-to-cards (open-and-read-caption-input))
  (display-ending-message))

; open-and-read-caption-input :: -> Path
; Retrieves the caption input text file for the specified card-color.
(define (open-and-read-caption-input)
  (file->lines (build-path (current-directory)
                           (string-append card-color ".txt"))))

; generate-cards :: List-of-strings -> Boolean
; Generates Cards Against Humanity from the List-of-strings captions.
(define (captions-to-cards captions)
  (cond
    [(empty? captions) #true]
    [(cons? captions)
       (displayln (card-count-output captions))
       (save-image (card-against-humanity (first captions))
                   (build-path (current-directory)
                               (string-append card-color "-cards")
                               (string-append card-color
                                              "-"
                                              (~a (length captions))
                                              ".png")))
       (captions-to-cards (rest captions))]))

; card-against-humanity :: String -> Image
; Generates a Card Against Humanity from the given String string.
(define (card-against-humanity caption)
  (set! string-holder (list ""))
  (overlay/align/offset "left" "top"
                        (text-wrapped-paragraph-bitmap caption)
                        -114 -126
                        (bitmap-card-backing-for-color caption)))

; parse-modifier :: String -> String
; Removes the Pick 2 or Pick 3 modifier from a String if it exists
(define (parse-pick-many-modifier string)
  (cond
    [(equal? #\2 (string-last-char string))
     (substring string 0 (sub1 (string-length string)))]
    [(equal? #\3 (string-last-char string))
     (substring string 0 (sub1 (string-length string)))]
    [else
     string]))

; card-back-bitmap :: String -> Image
; Returns the correct card backing for the specified caption; used in
; tandem with parse-modifier
(define (bitmap-card-backing-for-color string)
  (read-bitmap
   (build-path (current-directory)
               "template-images"
               "blanks"
               (string-parse-to-card-file-name string))))

; text-wrapped-paragraph-bitmap :: String -> Image
; Consumes a caption and returns a bitmap image of the text wrapped
; in paragraph fashion with line breaks every 16 characters.
(define (text-wrapped-paragraph-bitmap caption)
  (strings-to-paragraph-image
   (text-wrap (regexp-split #px" "
                            (smart-quotes (parse-pick-many-modifier
                                           caption)))
              16)))

; card-text :: List-of-strings -> Image
; Consumes the lines in the List-of-strings and outputs them stacked
; vertically in a single bitmap image
(define (strings-to-paragraph-image lines)
  (cond
    [(empty? lines) (rectangle 0 0 "solid" card-color)]
    [(cons? lines)
     (above/align "left"
                  (bold-text-bitmap (first lines))
                  (rectangle 0 15 "solid" card-color)
                  (strings-to-paragraph-image (rest lines)))]))

; text-wrap :: List-of-strings Integer -> List-of-strings
; Consumes a List-of-strings words and outputs a List-of-strings
; containing all of the input words with each element not being longer
; than the specified Integer width.
(define (text-wrap words width)
  (cond
    [(empty? words) #false]
    [(cons? words)
     (for ([word words])
       (cond
         [(and (> (+ (string-length word)
                     (string-length (first string-holder)))
                  width)
               (> (apply + (map string-length string-holder))
                  0))
          (set! string-holder
                (cons "" string-holder))])
       (set! string-holder
             (cons (string-append (first string-holder) " " word)
                   (rest string-holder))))
     (reverse (map string-trim string-holder))]))

; bold-text-bitmap :: String ZebraColor -> Image
; Generates a bitmap image of the String string in bold, Helvetica font.
(define (bold-text-bitmap string)
  (text/font string
             72
             text-color
             "Helvetica"
             "default"
             "normal"
             "bold"
             #f))

; string-last-char :: String -> Char
; Returns the last character of a string.
(define (string-last-char string)
  (string-ref string
              (sub1 (string-length string))))

; card-count-output :: List-of-strings -> String
; Returns a string containing the number of remaining captions along with
; the color of the card currently being generated.
(define (card-count-output captions)
  (string-append "  "
                 (~a (length captions))
                 " "
                 card-color
                 " cards to go..."))

; string-parse-to-card-file-name :: String -> String
; Parses the given String caption and returns the correct card backing. To
; be used for generating Pick 2 and Pick 3 cards.
(define (string-parse-to-card-file-name caption)
  (string-append "front-"
                 card-color
                 (cond
                   [(equal? #\2 (string-last-char caption))
                    "-pick2.png"]
                   [(equal? #\3 (string-last-char caption))
                    "-pick3.png"]
                   [else
                    ".png"])))

; string-holder :: -> List-of-strings
; Not meant to be called. Used to hold strings in certain functions.
(define string-holder (list ""))

; display-welcome-message :: ->
; Displays a welcome message in the output stream.
(define (display-welcome-message)
  (displayln "")
  (displayln "Thanks for using racket-against-humanity!")
  (displayln "Starting card generation process now...")
  (displayln ""))

; display-ending-message :: ->
; Displays a ending message in the output stream.
(define (display-ending-message)
  (displayln "")
  (displayln (string-append "All cards have been saved to ./"
                            card-color
                            "-cards!"))
  (displayln ""))

; Runtime

(cond
  [(and (equal? (vector-length (current-command-line-arguments)) 1)
        (or (equal? "white" (vector-ref (current-command-line-arguments) 0))
            (equal? "black" (vector-ref (current-command-line-arguments) 0))))
   (make-cards (vector-ref (current-command-line-arguments) 0))]
  [else
    (displayln "")
    (displayln "Thanks for using racket-against-humanity!")
    (displayln "racket-against-humanity accepts a single argument: <\"white\"|\"black\">")
    (displayln "")
    (displayln "Example usage:")
    (displayln "    racket \"racket-against-humanity.rkt\" \"white\"  ; generates white cards from white.txt")
    (displayln "    racket \"racket-against-humanity.rkt\" \"black\"  ; generates black cards from black.txt")
    (displayln "")])

