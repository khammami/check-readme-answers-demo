#!/bin/sh

# --batch to prevent interactive command
# --yes to assume "yes" for questions
gpg --quiet --batch --yes --decrypt --passphrase="$ANSWERS_SECRET_PASSPHRASE" \
--output answers.txt answers.txt.gpg