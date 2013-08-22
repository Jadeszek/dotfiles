
#
# .zlogin
#

if [[ -f ~/.notes ]]
then
  echo "\nNotes:"
  cat ~/.notes
fi

# empty line after last login message
echo ""

# start ssh-agent and gpg-agent
if which keychain &>/dev/null
then
  eval `keychain -q --eval`
fi

if [[ -a $HOME/.zlogin.local ]]
then
  source $HOME/.zlogin.local
fi