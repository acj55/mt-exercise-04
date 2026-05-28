# Tokenisation of data

#!/bin/bash

mkdir -p data/tok

for SPLIT in train dev test
do
    sacremoses tokenize --language nl < data/${SPLIT}.nl > data/tok/${SPLIT}.tok.nl
    sacremoses tokenize --language en < data/${SPLIT}.en > data/tok/${SPLIT}.tok.en
done