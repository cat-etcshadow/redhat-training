## Diagnose and correct broken file permissions

A junior admin misconfigured the web document root at **{{WEB_ROOT}}**, so the web server cannot serve files and users in group **{{WEB_GROUP}}** cannot manage content. Fix it so that **{{WEB_ROOT}}** itself is owned by root:{{WEB_GROUP}} with mode `2775` (SGID set), every subdirectory inside is owned by root:{{WEB_GROUP}} with mode `2775`, and every file inside is owned by root:{{WEB_GROUP}} with mode `0664`, such that users in **{{WEB_GROUP}}** can read and write files under **{{WEB_ROOT}}**.
