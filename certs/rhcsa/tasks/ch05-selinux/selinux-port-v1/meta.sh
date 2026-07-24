POINTS=12
TOPIC="selinux"
CHAPTER=5
TITLE="Allow httpd on a non-standard port via SELinux"
DIFFICULTY="medium"
RHEL_VERSIONS="8 9 10"
# Requires a modified Listen line in /etc/httpd/conf/httpd.conf as the final
# graded state; ch08-packages/dnf-reinstall-v1 requires that same file to
# exactly match the pristine package-provided version — mutually exclusive.
CONFLICTS=("ch08-packages/dnf-reinstall-v1")
