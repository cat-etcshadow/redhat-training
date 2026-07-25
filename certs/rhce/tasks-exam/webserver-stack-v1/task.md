## Deploy and Harden a Company Web Server

The **prod** environment (`node3`, `node4`) needs a production-ready web server.
Write a single playbook, **{{PLAYBOOK_FILE}}**, targeting only the **prod**
group, that brings both hosts to the following end state:

1. A web server package is installed, running, and enabled at boot on both
   hosts.

2. Content is served from **{{WEB_ROOT}}** — not the software's default
   location. The home page displays the text "{{BANNER_TEXT}}" followed by
   the host's own hostname; each host must show *its own* hostname, not a
   value copied from the other.

3. **{{WEB_ROOT}}** and its contents carry the correct SELinux label for
   served web content, persistently enough to survive a full recursive
   relabel of the filesystem.

4. Other hosts on the network can reach the web server on its standard port,
   right now and after the next reboot.

5. Updating the home page content and re-running the playbook is enough on
   its own to make the web server pick up the new content — no manual
   restart step by the candidate.

Grading applies your playbook for real against both hosts and checks the
resulting state — it does not inspect your playbook's source.
