# Dragon Cave Word Code Checker
An iOS app to check your Dragon Cave scroll for interesting words in dragon codes.

# Logic

1. Input the name of a (valid) Dragon Cave scroll.
2. Scrape each page of the scroll, mining dragon information - code, name etc
3. For each code produce a list of tokens of at least 3 characters in length.
* A token is a continuous substring of the code with a length no greater than the code itself.
* For example, if the code was `cats4`, the app  generates the tokens `cat`, `ats`, `at4`, `cats`, `ats4`, `cats4`
4. Check each token against a list of reference words. Reference words (so far) include:
* American English Scrabble words
* Common English first names
* Three letter country codes

# Prototype

![](https://user-images.githubusercontent.com/987146/30514905-6ac9df60-9b16-11e7-93f3-5f6779226577.gif)

# Wishlist

See [this GitHub issue](https://github.com/lukestringer90/DragonCaveWordCodeChecker/issues/2) for what I want to do next

# Disclaimer

In the current protoype the app uses the DragonCave logo as the app icon and in the tab bar. This image is owned by **Dragon Cave Copyright © 2006–2017 T.J. Lipscomb.** I will remove the image in future versions before launch. 
