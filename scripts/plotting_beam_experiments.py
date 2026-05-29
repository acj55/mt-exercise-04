

import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("beam_results/results.csv", header=None, names=["beam_size", "bleu", "time_sec"])

beam_sizes = list(range(1, 11))

# BLEU plot
plt.figure(figsize=(6,4))
plt.plot(df["beam_size"], df["bleu"], marker="o")
plt.xlabel("Beam Size")
plt.ylabel("BLEU Score")
plt.title("BLEU Score vs Beam Size")
plt.xticks(beam_sizes)
plt.grid(True)
plt.savefig("beam_results/bleu_vs_beam.png", bbox_inches="tight")

# runtime plot
plt.figure(figsize=(6,4))
plt.plot(df["beam_size"], df["time_sec"], marker="o")
plt.xlabel("Beam Size")
plt.ylabel("Runtime (seconds)")
plt.title("Runtime vs Beam Size")
plt.xticks(beam_sizes)
plt.grid(True)
plt.savefig("beam_results/runtime_vs_beam.png", bbox_inches="tight")


# scatter plot: runtime vs BLEU
plt.figure(figsize=(8,6))

scatter = plt.scatter(
    df["time_sec"],
    df["bleu"],
    c=df["beam_size"],
    cmap="viridis",
    s=80, 
    alpha=0.8
)

for _, row in df.iterrows():
     plt.annotate(
        str(int(row["beam_size"])),
        (row["time_sec"], row["bleu"]),
        textcoords="offset points",
        xytext=(6, 6),
        ha="left",
        fontsize=9,
        bbox=dict(
            boxstyle="round,pad=0.2",
            fc="white",
            ec="none",
            alpha=0.7
        )
    )

cbar = plt.colorbar(scatter)
cbar.set_label("Beam Size")
plt.xlabel("Runtime (seconds)")
plt.ylabel("BLEU Score")
plt.title("BLEU vs Runtime across Beam Sizes")
plt.grid(True)
plt.savefig("beam_results/bleu_vs_runtime.png", bbox_inches="tight")

print("Plots saved:")
print("beam_results/bleu_vs_beam.png")
print("beam_results/runtime_vs_beam.png")
print("beam_results/bleu_vs_runtime.png")