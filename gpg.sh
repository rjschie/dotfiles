if [ ! -x /usr/local/bin/gpg ]; then
  brew install gpg
fi

gpg --full-generate-key