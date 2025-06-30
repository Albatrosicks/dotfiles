set LESSPIPE (which src-hilite-lesspipe.sh)
if test -n "$LESSPIPE"
    set -gx LESSOPEN "| $LESSPIPE %s"
end
set -gx LESS -R
