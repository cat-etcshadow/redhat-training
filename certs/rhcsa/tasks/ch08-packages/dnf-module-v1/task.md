## Enable a DNF module stream and install from it

Application modules allow you to install specific versions of software
independent of the default AppStream version.

Your task:

1. List available `nodejs` module streams.
2. Enable the **nodejs:{{NODE_STREAM}}** stream.
3. Install the `nodejs` package from that stream.
4. Verify: `node --version` should report a **v{{NODE_STREAM}}.x** version,
   and stream **{{NODE_STREAM}}** should show as enabled.
