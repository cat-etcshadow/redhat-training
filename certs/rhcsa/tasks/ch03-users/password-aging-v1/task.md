## Configure password aging policies

The users **{{USER1}}** and **{{USER2}}** already exist on the system.

Apply the following password aging policies:

**For {{USER1}}:**
- Minimum days between password changes: **{{MIN_AGE}}**
- Maximum days a password is valid: **{{MAX_AGE1}}**
- Warning period before expiry: **{{WARN_DAYS}}** days
- Account is locked **{{INACTIVE}}** days after the password expires without change

**For {{USER2}}:**
- Force a password change on next login (the password has already expired)
- Maximum days a password is valid: **{{MAX_AGE2}}**
