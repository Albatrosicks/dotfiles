function tree --description "Tree view using eza, fallback to tree command"
    if test (count $argv) -eq 0
        if command -q eza
            eza --tree --level=2 --all --ignore-glob=".git|.DS_Store" ./
        else
            command tree -L 2 -a -I ".git|.DS_Store" ./
        end
    else
        if command -q eza
            eza --tree $argv
        else
            command tree $argv
        end
    end
end
