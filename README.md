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

Currently the app can perform most of the logic detailed above (the scroll scraper doesn't properly terminate on the last page of a scroll) and can displayed results in one of two ways.

1. **Word list** - A list of all the valid words from all the dragon codes in the scroll.
2. **Dragon List** - A list of dragons that have at least one word in it's code.

## Word List

![](https://user-images.githubusercontent.com/987146/28723461-b72e0582-73ae-11e7-8780-6589fd23f88d.gif)

## Dragon List

![](https://user-images.githubusercontent.com/987146/28723462-b7538b18-73ae-11e7-8895-917874a1b47d.gif)
