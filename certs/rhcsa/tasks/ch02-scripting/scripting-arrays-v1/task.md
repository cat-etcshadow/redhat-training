## Write a script using indexed arrays

Create an executable script at **{{SCRIPT_PATH}}** that reports low-stock inventory items, defining two parallel indexed arrays hardcoded exactly as follows, in this order:

```
ITEMS=(widget gadget bolt gear valve)
QTYS=(45 8 120 3 60)
```

It must accept one argument, a quantity threshold — printing usage to stderr and exiting **1** if none is provided — then use a `for` loop to print one line for every item whose quantity is below the threshold, in the form `LOW: <item> (<qty>)`, followed by `Total low-stock items: <count>`, and exit **0** on success.
