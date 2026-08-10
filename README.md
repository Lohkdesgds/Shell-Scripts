# Lohk's Scripts!

Now completely revamped, with custom profiles, prompts and much more!

## How to install

1. Download via `git clone` (preferred) or by `zip`. Put it somewhere. Copy the path to it.
2. Add to your `.bashrc` the command: `trap 'source PATH/TO/SCRIPT/newcustom.sh; trap - RETURN' RETURN`
3. You're done!

## Why trap source instead of just source?

This script changes exports in `.bashrc` directly. With new variables added to the bottom, the source **must be** the last task on the `.bashrc` to get them on a new terminal.
The `trap` command allows the source to always happen at the end, no matter what, so this is the solution.

## Where is the help?

It's WIP! Soon there will be a help command and better readme! WIP!!!