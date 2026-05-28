
from pathlib import Path

BASE = Path(__file__).resolve().parent.parent

WORD_HYP = BASE / "models/tf_word_nl_en/00019500.hyps.test.detok"
BPE_2000_HYP = BASE / "models/tf_bpe_2000_nl_en/00038500.hyps.test.detok"
BPE_4000_HYP = BASE / "models/tf_bpe_4000_nl_en/00033500.hyps.test.detok"

SRC = BASE / "data/test.nl"
REF = BASE / "data/test.en"

OUT = BASE / "analysis_translation_examples.txt"

N_EXAMPLES = 15
START_INDEX = 0 


def read_lines(path):
    with path.open(encoding="utf-8") as f:
        return [line.strip() for line in f]


def main():
    src = read_lines(SRC)
    ref = read_lines(REF)
    word = read_lines(WORD_HYP)
    bpe2000 = read_lines(BPE_2000_HYP)
    bpe4000 = read_lines(BPE_4000_HYP)

    n = min(len(ref), len(word), len(bpe2000), len(bpe4000))

    with OUT.open("w", encoding="utf-8") as f:
        f.write("Translation examples for manual analysis\n")
        f.write("=" * 50 + "\n\n")

        for i in range(START_INDEX, min(START_INDEX + N_EXAMPLES, n)):
            f.write(f"Example {i + 1}\n")
            f.write("-" * 50 + "\n")
            f.write(f"Source (NL):      {src[i]}\n")
            f.write(f"Reference (EN):   {ref[i]}\n")
            f.write(f"Word model:       {word[i]}\n")
            f.write(f"BPE 2000:         {bpe2000[i]}\n")
            f.write(f"BPE 4000:         {bpe4000[i]}\n")
            f.write("\n")

    print(f"Wrote {N_EXAMPLES} examples to {OUT}")


if __name__ == "__main__":
    main()