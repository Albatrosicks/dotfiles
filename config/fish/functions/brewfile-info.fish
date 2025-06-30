function brewfile-info --description "Adds description and link to Brewfile"
    set output (brew bundle dump --describe --file=-)
    echo -n >Brewfile

    echo $output | while read -l line
        if string match -qr '^(brew|cask)' $line
            set packageName (echo $line | awk '{print $2}' | tr -d '"')
            set desc AUTO_GENERATE_DESCRIPTION_HERE
            set link AUTO_GENERATE_PACKAGE_WEB_LINK
        end
        echo $line >>Brewfile
    end
end
