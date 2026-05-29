# MT Exercise 4: Byte Pair Encoding, Beam Search

This repository is a starting point for the 4th and final exercise.

---

## Requirements

- Python 3.10 must be installed. The command `python3` (or `python` on Windows) should be available from your terminal or command prompt.
- `virtualenv` must be installed. Install it with:

  ```bash
  pip install virtualenv

macOS/Linux users: No special setup needed; shell scripts should run normally.

Windows users: Either use Windows Subsystem for Linux (WSL) or a Unix-compatible shell like Git Bash.
If you're using PowerShell or Command Prompt, manual setup is required.

### Setup Instructions

## For macOS / Linux / WSL / Git Bash users

Clone your fork of the repository + Create a virtual environment:
   ```
   git clone https://github.com/[your-username]/mt-exercise-4
   cd mt-exercise-4 

   ```
    ./scripts/make_virtualenv.sh

Important: Then activate the env by executing the source command that is output by the shell script above.

Install required dependencies.

Download data:

       python ./scripts/download_huggingface_data.py --src nl --trg en --out data

I have chosen the direction `nl-en`.

At first, I could not download it with the provided script. I adapted this slightly by changing "IWSLT/iwslt2017" to "iwslt2017". This then worked.

## Preprocessing

### Tokenisation

Tokenisation on the word-level was performed using `moses` tokenisation.

Script:

       ./scripts/preprocessing.sh

- output directory:
       - data/tok/
- generated files:
       - train.tok.nl
       - train.tok.en 
       - dev.tok.nl 
       - dev.tok.en 
       - test.tok.nl 
       - test.tok.en

### BPE learning

BPE preprocessing was performed using `subword-nmt`.

Script:

       ./scripts/learn_bpe.sh

This does the following:
- Learn joint BPE codes
-  Apply BPE to train/dev/test
- Build shared vocabulary

Done with 2000 and 4000 numbers of operations. Is stored in the corresponding output directory:
- data/bpe_2000/
- data/bpe_4000/

## Model Configurations
Config scripts:

`configs/tf_word_nl_en.yaml`
`configs/tf_bpe_2000_nl_en.yaml`
`configs/tf_bpe_4000_nl_en.yaml`

## Model Training

Train the model:

       ./scripts/train.sh

The model names must be changed accordingly. Selection: tf_word_nl_en, tf_bpe_2000_nl_en or tf_bpe_4000_nl_en

*the training process can be interrupted at any time. The best checkpoint will always be saved automatically.*

output directories:
`models/tf_word_nl_en/`
`models/tf_bpe_2000_nl_en/`
`models/tf_bpe_4000_nl_en/`

## BLEU evaluation

*Note: Unfortunately, I was a bit over-eager and have overseen that the evaluate.sh script was already provided. Therefore, I have created a script for the evaluation myself instead. The functionality remains the same. It is also provided in this directory and can be replicated.*

Evaluation script:
      
       ./scripts/compute_bleu.sh

Does the following: 
- remove BPE continuation markers (@@)
- detokenise output using Sacremoses
- compute BLEU with SacreBLEU

Output: `bleu_scores_detok.txt`

## Beam Size experiments

The best-performing model `tf_bpe_4000_nl_en` was used for beam-size experiments. I tested beamsizes 1 to 10.

Script:

       ./scripts/beam_experiments.sh


Does the following: 
- automatically creates beam-size configs 
- translates the test set
- measures runtime
- computes BLEU
- stores results in CSV format

- Results directory: 
       - beam_results/
- Outputs:
       - results.csv
       - translations
       - BLEU score files

### Plotting of beam-Size results

Script:

       python scripts/plotting_beam_experiments.py

Generated plots:
- bleu_vs_beam.png
- runtime_vs_beam.png
- bleu_vs_runtime.png

## Translation Analysis & Comparison

I extracted translation examples for manual comparison. The resulting file aligns Dutch source sentence, English reference, word-level output, BPE-2000 output and BPE-4000 output. 

Script:

       python scripts/translation_comparison.py

Output:
- analysis_translation_examples.txt

## Findings
The findings are analysed in the PDF submitted to OLAT.

