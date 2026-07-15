## Create a system service account with custom attributes

An application needs a dedicated **system** service account, not an interactive login user. Create the user **{{SVC_USER}}** with a system account UID (below 1000), the home directory field set to **{{SVC_HOME}}** without the directory itself being created (the application will create it separately), login shell set to `nologin`, and the comment (GECOS) field set to exactly `{{SVC_COMMENT}}`.
