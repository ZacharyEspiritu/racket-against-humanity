# racket-against-humanity
A Racket program that generates cards in the style of Cards Against Humanity.

## Example Output

| White Card | Black Card | Black Card (Pick 2) | Black Card (Pick 3) |
|:----------:|:----------:|:-------------------:|:-------------------:|
|![white-5](https://user-images.githubusercontent.com/13021310/28506620-a13a1b24-6ffa-11e7-9476-dbd82dc032ad.png)|![black-3](https://user-images.githubusercontent.com/13021310/28506635-bff05420-6ffa-11e7-9235-3d1c455ba456.png)|![black-2](https://user-images.githubusercontent.com/13021310/28506634-bfef2b04-6ffa-11e7-832e-50121aa2b00d.png)|![black-1](https://user-images.githubusercontent.com/13021310/28506633-bfef3090-6ffa-11e7-9af3-0150b12eab6a.png)|

## Setup

Download and install [Racket](https://racket-lang.org/) on your computer. After that, install the required [Pollen](https://docs.racket-lang.org/pollen/Installation.html) package.

Open up your favorite command line, clone the Github repo to your computer, and start up the Racket environment:

```
$ git clone https://github.com/ZacharyEspiritu/racket-against-humanity.git
$ cd racket-against-humanity
$ racket
Welcome to Racket v.6.9.
>
```

Load the `racket-against-humanity.rkt` definitions into the Racket environment:

```
> (load "racket-against-humanity.rkt")
```

## Usage

You can specify which color cards you want to generate in the `make-cards` function using:

```
> (make-cards "white")       ; or you can use (make-cards "black")
```

This will start the process of generating your cards. All card captions should be placed in the `black.txt` and `white.txt` files, each separated by a newline. They will be saved to the `./black-cards` and `./white-cards` folders, respectively.

You can change the image that your captions are superimposed upon by swapping out the files in the `./template-images/blanks` for images with the exact same name _and_ dimensions. The required file names are:

* `front-white.png`
* `front-black.png`
* `front-black-pick2.png`
* `front-black-pick3.png`

You can specify a black card's caption to be generated as a "Pick 2" and "Pick 3" card by putting a `2` or a `3` immediately after the last character of your caption:

```
# black.txt

This is a normal card.
This is a Pick 2 card.2
This is a Pick 3 card.3
```

Captions with these modifiers will be superimposed on the `front-black-pick2.png` and `front-black-pick3.png` cards according to your specifications.

## License

**racket-against-humanity** is licensed under the GNU Affero General Public License Version 3. 

Please refer to the [LICENSE file](https://github.com/ZacharyEspiritu/racket-against-humanity/blob/master/LICENSE) or the [GNU's website](http://www.gnu.org/licenses/#AGPL) for more information.

```
racket-against-humanity: A Cards Against Humanity generator, in Racket
Copyright (C) 2017  Zachary Espiritu (http://zacharyespiritu.com)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```
