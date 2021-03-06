#!/bin/sh
# http://wiki.apertium.org/wiki/Asturian#Calculating_coverage


# Example use:
# zcat corpa/en.crp.txt.gz | sh corpus-stat.sh


#CMD="cat corpa/en.crp.txt"
CMD="cat $1"

F=$2

# Calculate the number of tokenised words in the corpus:
# for some reason putting the newline in directly doesn't work, so two seds
$CMD | apertium-destxt | lt-proc ht-en.automorf.bin |apertium-retxt | sed 's/\$[^^]*\^/$^/g' | sed 's/\$\^/$\
^/g' > $F

NUMWORDS=`cat $F | wc -l`
echo "Number of tokenised words in the corpus: $NUMWORDS"



# Calculate the number of words that are not unknown

NUMKNOWNWORDS=`cat $F | grep -v '\*' | wc -l`
echo "Number of known words in the corpus: $NUMKNOWNWORDS"


# Calculate the coverage

COVERAGE=`calc "round($NUMKNOWNWORDS/$NUMWORDS*1000)/10"`
echo "Coverage: $COVERAGE %"


# Show the top-ten unknown words.

echo "Top unknown words in the corpus:"
cat $F | grep '\*' | sort -f | uniq -c | sort -gr | head -10


