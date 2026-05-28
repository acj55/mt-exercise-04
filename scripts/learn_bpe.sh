
#! /bin/bash

scripts=$(dirname "$0")
base=$scripts/..

tok=$base/data/tok
bpe=$base/data/bpe_2000
#shared_models=$base/shared_models

mkdir -p $bpe

bpe_num_ops=2000  # or 4000
src=nl
trg=en


# mkdir -p $shared_models/$bpe_num_ops

# learns bpe model on training data from the src and trg
subword-nmt learn-joint-bpe-and-vocab -i $tok/train.tok.$src $tok/train.tok.$trg \
	--write-vocabulary $bpe/vocab_$bpe_num_ops.$src $bpe/vocab_$bpe_num_ops.$trg \
	-s $bpe_num_ops --total-symbols -o $bpe/codes_$bpe_num_ops.bpe


# applies bpe to all splits
for split in train dev test
do
    subword-nmt apply-bpe \
        -c $bpe/codes_$bpe_num_ops.bpe \
        < $tok/$split.tok.$src \
        > $bpe/$split.bpe.$src

    subword-nmt apply-bpe \
        -c $bpe/codes_$bpe_num_ops.bpe \
        < $tok/$split.tok.$trg \
        > $bpe/$split.bpe.$trg
done

# creates shared vocabulary
cat $bpe/train.bpe.$src $bpe/train.bpe.$trg \
    > $bpe/train.union.bpe

subword-nmt get-vocab \
    --input $bpe/train.union.bpe \
    --output $bpe/joint-vocab.txt

# removes counts
cut -f1 -d' ' $bpe/joint-vocab.txt \
    > $bpe/joint-vocab.clean.txt

