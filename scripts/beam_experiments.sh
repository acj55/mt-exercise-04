
#!/bin/bash

num_threads=4

scripts=$(dirname "$0")
base=$scripts/..
#models=$base/models
data=$base/data

base_config=$base/configs/tf_bpe_4000_nl_en.yaml
beam_config_dir=$base/configs/cfgs_beam_experiments
results_dir=$base/beam_results

translations=$results_dir/translations
bleu_scores=$results_dir/bleu_scores

mkdir -p "$beam_config_dir"
mkdir -p "$results_dir"
mkdir -p "$translations"
mkdir -p "$bleu_scores"

src=nl
trg=en
model_name=tf_bpe_4000

for beam in 1 2 3 4 5 6 7 8 9 10
do
    beam_config=$beam_config_dir/$model_name.beam_${beam}.yaml

    python - <<PY
import yaml

with open("$base_config", "r") as f:
    cfg = yaml.safe_load(f)

cfg["testing"]["beam_size"] = $beam
cfg["name"] = f"tf_bpe_4000_beam_${beam}"

with open("$beam_config", "w") as f:
    yaml.safe_dump(cfg, f, sort_keys=False)
PY

    echo "Created config: $beam_config"

    SECONDS=0

    OMP_NUM_THREADS=$num_threads python -m joeynmt translate "$beam_config"  < $data/tok/test.tok.$src  > "$translations/test.beam_$beam.$trg"

    runtime=$SECONDS

    sed 's/@@ //g' "$translations/test.beam_$beam.$trg" | sacremoses detokenize  > "$translations/test.beam_$beam.$trg.detok"

    sacrebleu $data/test.$trg -i $translations/test.beam_$beam.$trg.detok > $bleu_scores/bleu.beam_$beam.json

    bleu=$(sacrebleu "$data/test.$trg" -i "$translations/test.beam_$beam.$trg.detok" --score-only)

    echo "$beam,$bleu,$runtime" >> "$results_dir/results.csv"


done

