function git_prompt_info
    set current_branch (git symbolic-ref --short HEAD 2>/dev/null)
    if test -n "$current_branch"
        echo " "(set_color -o green)"$current_branch"(set_color normal)
    end
end

function fish_prompt
    # Check if PS1 is already set (exported from environment)
    if not set -q PS1
        set_color -o blue
        echo -n (prompt_pwd)
        set_color normal

        # Add SSH connection info if present
        if set -q SSH_CONNECTION
            set_color -o green
            echo -n "$USER@"(hostname)":"
            set_color normal
        end

        echo -n (git_prompt_info)
        echo -n " "

        # Show # for root, % for regular user
        if test (id -u) -eq 0
            echo -n "# "
        else
            echo -n "% "
        end
    else
        echo -n "$PS1"
    end
end
