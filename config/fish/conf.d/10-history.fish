# Fish 4 history settings
set -U fish_history_max_size 4096
set -U fish_history_save_on_exit 1
set -U fish_history_ignore_duplicates 1
set -U fish_history_ignore_space 1

# Commands to ignore in history
set -U fish_history_ignore_patterns ls cd pwd exit ll history ez eza export

# Function to check if command should be ignored
function __fish_should_ignore_history --on-event fish_preexec
    for pattern in $fish_history_ignore_patterns
        if string match -q "$pattern" $argv[1]
            set -g __fish_skip_history 1
            return
        end
    end
    set -e __fish_skip_history
end

# Erlang shell history
set -gx ERL_AFLAGS "-kernel shell_history enabled"
