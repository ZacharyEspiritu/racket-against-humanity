# racket-against-humanity
A Racket program that generates cards in the style of Cards Against Humanity.

## Example Output

| White Card | Black Card | Black Card (Pick 2) | Black Card (Pick 3) |
|:----------:|:----------:|:-------------------:|:-------------------:|
|![white-5](https://user-images.githubusercontent.com/13021310/28507422-9fd30c40-7000-11e7-8872-b054e4b34bbe.png)|![black-3](https://user-images.githubusercontent.com/13021310/28507424-a3839eae-7000-11e7-9841-bdff85dc352a.png)|![black-2](https://user-images.githubusercontent.com/13021310/28507425-a48ef56e-7000-11e7-9f90-86670601160d.png)|![black-1](https://user-images.githubusercontent.com/13021310/28507426-a5cf05fe-7000-11e7-92cc-103f7893f912.png)|

## Setup

Download and install [Racket](https://racket-lang.org/) on your computer. After that, install the required [Pollen](https://docs.racket-lang.org/pollen/Installation.html) package.

Open up your favorite command line and clone the Github repo to your computer:

```
$ git clone https://github.com/ZacharyEspiritu/racket-against-humanity.git
$ cd racket-against-humanity
```

## Usage

racket-against-humanity uses the `racket` command to load its function definitions. Along with the definition file path, the command takes a single parameter, `"white"` or `"black"`:

```
$ racket "racket-against-humanity.rkt" "white"  ; generates white cards from white.txt
$ racket "racket-against-humanity.rkt" "black"  ; generates black cards from black.txt
```

This will start the process of generating your cards. All card captions should be placed in the `black.txt` and `white.txt` files, each separated by a newline. They will be saved to the `./black-cards` and `./white-cards` folders, respectively.

### Changing Template Images

You can change the image that your captions are superimposed upon by swapping out the files in the `./template-images/blanks` for images with the exact same name _and_ dimensions. The required file names are:

* `front-white.png`
* `front-black.png`
* `front-black-pick2.png`
* `front-black-pick3.png`

### Pick 2 and Pick 3 Cards

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
