## Create a system service account with custom attributes

An application needs a dedicated **system** service account — not an
interactive login user.

Your task:

Create the user **{{SVC_USER}}** with:

1. A **system account** UID (below 1000).
2. Home directory field set to **{{SVC_HOME}}** — but do **not** create the
   directory itself (the application will create it separately).
3. Login shell set to `nologin`.
4. The comment (GECOS) field set to exactly: `{{SVC_COMMENT}}`
