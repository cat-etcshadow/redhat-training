## Write a script using indexed arrays

Create an executable script at **{{SCRIPT_PATH}}** that reports low-stock
inventory items.

The script must define two parallel **indexed arrays** hardcoded exactly as
follows, in this order:

```
ITEMS=(widget gadget bolt gear valve)
QTYS=(45 8 120 3 60)
```

Requirements:

1. Accepts one argument: a quantity **threshold**.
   If no argument is provided, print usage to stderr and exit **1**.

2. Using a `for` loop over the array **indices** (not the values directly),
   print one line for every item whose quantity is below the threshold:
   `LOW: <item> (<qty>)`

3. After the loop, print: `Total low-stock items: <count>`

4. Exit **0** on success.
