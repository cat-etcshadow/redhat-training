## Undo a package transaction with dnf history

A single package transaction installed **{{PKG_A}}** and **{{PKG_B}}**
together, by mistake.

Your task:

1. Use `dnf history` to find the transaction that installed both
   **{{PKG_A}}** and **{{PKG_B}}**.

2. Undo that **entire transaction** — do not remove the packages
   individually — so that both are uninstalled.
