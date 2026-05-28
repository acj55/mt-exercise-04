

#!/bin/bash

scripts=$(dirname "$0")
base=$scripts/..
models=$base/models
data=$base/data

model_names=("tf_word_nl_en" "tf_bpe_2000_nl_en" "tf_bpe_4000_nl_en")

output_file=bleu_scores_detok.txt
rm -f "$output_file"

for model in "${model_names[@]}"
do
    echo "-------------------"
    echo "Model: $model"
    echo "-------------------"

    model_dir=$models/$model

    test_hyp=$(find "$model_dir" -type f -name "*.hyps.test" | sort | tail -n 1)
    dev_hyp=$(find "$model_dir" -type f -name "*.hyps.dev" | sort | tail -n 1)

    if [ -z "$test_hyp" ]; then
        echo "No test hypothesis file found for $model"
    else
        echo "Test file: $test_hyp"

        # # remove BPE markers if present
        # sed 's/@@ //g' "$test_hyp" > "$test_hyp.detok"
        sed 's/@@ //g' "$test_hyp" | sacremoses detokenize  > "$test_hyp.detok"

        echo "TEST BLEU:" | tee -a "$output_file"
        sacrebleu $data/test.en -i "$test_hyp.detok" | tee -a "$output_file"
    fi

    echo ""

done