# BEGIN ANSIBLE MANAGED BLOCK
#!/usr/bin/env bash
echo "Insert the new key to authenticate."
read -sp "Press 'Enter' to continue."
gpg-connect-agent "scd serialno" "learn --force" /bye
echo "Finished"
# END ANSIBLE MANAGED BLOCK
