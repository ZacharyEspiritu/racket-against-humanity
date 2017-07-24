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
; interpretation a list of strings

; Mutables

(define (card-color) "white")
(define (text-color) "black")

; Functions

; racket-cah :: ZebraColor -> Boolean
; Generates Cards Against Humanity for the specified color. Captions
; must be specified in a .txt file of the color's name: "white.txt" or
; "black.txt". Cards will be exported to the ./white-cards or
; ./black-cards directory. Template images must be included in the
; ./template-images directory.
(define (racket-cah color)
  (set! card-color color)
  (cond
    [(equal? card-color "white")
      (set! text-color "black")]
    [else
      (set! card-color "black")
      (set! text-color "white")])
  (generate-cards
   (file->lines
    (build-path (current-directory)
                (string-append card-color
                               ".txt"))))
  (displayln
   (string-append "All cards have been saved to ./" card-color "-cards!")))

; generate-cards :: List-of-strings -> Boolean
; Generates Cards Against Humanity from the List-of-strings captions.
(define (generate-cards captions)
  (cond
    [(empty? captions) #true]
    [(cons? captions)
       (displayln
        (string-append "Creating " card-color " card #" (~a (length captions)) "..."))
       (save-image (card-against-humanity (first captions))
                   (build-path (current-directory)
                               (string-append card-color "-cards")
                               (string-append card-color
                                              "-"
                                              (~a (length captions))
                                              ".png")))
       (generate-cards (rest captions))]))

; card-against-humanity :: String -> Image
; Generates a Card Against Humanity from the given String string.
(define (card-against-humanity string)
  (set! string-holder (list ""))
  (overlay/align/offset "left" "top"
                        (card-text
                         (text-wrap
                          (regexp-split #px" "
                                        (smart-quotes
                                         (parse-modifier
                                          string)))
                          16))
                        -114 -126
                        (card-back-bitmap string)))

; parse-modifier :: String -> String
; Removes the Pick 2 or Pick 3 modifier from a String if it exists
(define (parse-modifier string)
  (cond
    [(equal? #\2 (last-char string))
     (substring string 0 (sub1 (string-length string)))]
    [(equal? #\3 (last-char string))
     (substring string 0 (sub1 (string-length string)))]
    [else
     string]))

; card-back-bitmap :: String -> Image
; Returns the correct card backing for the specified caption; used in
; tandem with parse-modifier
(define (card-back-bitmap string)
  (read-bitmap
   (build-path (current-directory)
               "template-images"
               "blanks"
               (string-append "front-"
                              card-color
                              (cond
                                [(equal? #\2 (last-char string))
                                 "-pick2.png"]
                                [(equal? #\3 (last-char string))
                                 "-pick3.png"]
                                [else
                                 ".png"])))))

; card-text :: List-of-strings -> Image
; Consumes the lines in the List-of-strings and outputs them stacked
; vertically in a single bitmap image
(define (card-text lines)
  (cond
    [(empty? lines) (rectangle 0 0 "solid" card-color)]
    [(cons? lines)
     (above/align "left"
                  (bold-text (first lines))
                  (rectangle 0 15 "solid" card-color)
                  (card-text (rest lines)))]))

; word-row :: List-of-strings -> Image
; Generates a single bitmap image of the strings in the List-of-strings,
; concatenated. Meant for use to generate a single line of bitmap words
(define (word-row strings)
  (cond
    [(empty? strings) (rectangle 0 0 "solid" card-color)]
    [(cons? strings) (beside/align "baseline"
                                   (bold-text (first strings))
                                   (bold-text " ")
                                   (word-row (rest strings)))]))

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
         [(> (+ (string-length word)
                (string-length (first string-holder)))
             width)
          (cond
            [(> (apply + (map string-length string-holder))
                0)
             (set! string-holder
                   (cons "" string-holder))])])
       (set! string-holder
             (cons (string-append (first string-holder)
                                  " "
                                  word)
                   (rest string-holder))))
     (reverse (map string-trim string-holder))]))

; bold-text :: String ZebraColor -> Image
; Generates a bitmap image of the String string in bold, Helvetica font.
(define (bold-text string)
  (text/font string
             72
             text-color
             "Helvetica"
             "default"
             "normal"
             "bold"
             #f))

(define (last-char string)
  (string-ref string
              (sub1 (string-length string))))

; string-holder :: -> List-of-strings
; Not meant to be called. Used to hold strings in certain functions.
(define string-holder (list ""))
