function change-extension --description "Change file extensions recursively" --argument-names old_ext new_ext
    if test (count $argv) -ne 2
        echo "Usage: change-extension OLD_EXT NEW_EXT"
        return 1
    end

    for f in **/*.$old_ext
        if test -f $f
            mv $f (string replace -r "\.$old_ext\$" ".$new_ext" $f)
        end
    end
end
