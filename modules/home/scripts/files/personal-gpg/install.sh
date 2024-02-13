# BEGIN ANSIBLE MANAGED BLOCK
#!/usr/bin/env bash

if gpg -K --keyid-format LONG | grep -iq 9F30DA1A16D74EA7 ; then
  exit 0
fi
gpg --receive-keys 185B6FE0AC2034D0EB2F0ADD11B0F08E0A4D904B 2>&1 > /dev/null
echo -e "5\ny\n" | gpg --command-fd 0 --expert --edit-key 11B0F08E0A4D904B trust;
echo "If you don't have your GPG Card, the next phase will error out."
echo "If that happens, run gpg --card-status once your have your card connected."
read -sp "Please insert your GPG Card and press a key to continue..."
gpg --card-status 2>&1 > /dev/null

echo "Finished!"
# END ANSIBLE MANAGED BLOCK
