## Write a script using parameter-expansion defaults and string tests

Create an executable script at **{{SCRIPT_PATH}}** that prints a deployment
summary.

Requirements:

1. Reads the environment variable **APP_ENV**. If it is unset or empty,
   default to `development` — using **parameter expansion**
   (`${VAR:-default}`), not a separate `if` check.

2. Reads its first positional argument as the deployment target. If not
   provided, default to `localhost` — again using parameter expansion.

3. Using a string comparison test (`[[ ... ]]`), verify **APP_ENV** is one
   of `production`, `staging`, or `development`. If it is none of these,
   print an error to stderr and exit non-zero.

4. On success, print exactly: `Deploying to <target> in <env> mode`
   and exit **0**.
