#!/usr/bin/env python

import argparse
from getpass import getpass
import os
import sys

sys.path.append(os.path.join(os.path.dirname(__file__), ".."))
from onepassword import Keychain


DEFAULT_KEYCHAIN_PATH = "~/Dropbox/1Password.agilekeychain"


parser = argparse.ArgumentParser()
parser.add_argument("item", help="The name of the password to decrypt")
parser.add_argument(
    "--path",
    default=os.environ.get('ONEPASSWORD_KEYCHAIN', DEFAULT_KEYCHAIN_PATH),
    help="Path to your 1Password.agilekeychain file"
)
args = parser.parse_args()

keychain = Keychain(args.path)
while keychain.locked:
    try:
        keychain.unlock(getpass("Master password: "))
    except KeyboardInterrupt:
        print("")
        sys.exit(0)

item = keychain.item(args.item)
if item is not None:
    print(repr(item._data['notesPlain']))
else:
    sys.stderr.write("Could not find a item named '%s'\n" % args.item)
    sys.exit(1)
