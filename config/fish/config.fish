if not status --is-interactive
    # Problem: Scripts are slow because my configuration in this file is slow.
    # Solution: Skip the configuration if not running interactively.
    #
    # Unlike files like `~/.bashrc` (which runs only for interactive shells)
    # shells, `config.fish` is run for *every* fish shell, including
    # non-interactive shells. This was surprising to me.
    #
    # By skipping it, I speed up things like:
    #
    # * scripts that run with `#!/usr/bin/env fish`
    # * fzf, surprisingly: $FZF_DEFAULT_COMMAND is run with $SHELL, approximately
    #   equivalent to doing `fish -c $FZF_DEFAULT_COMMAND`
    #
    # As a rough benchmark, skipping my configuration saves ~130ms on `fzf`
    # initialization.
    if not set -q I_REALLY_WANT_TO_RUN_FISH_CONFIG_FOR_FIND_LOCATION_OF
        # This escape hatch means that things below can run in a non-interactive
        # shell, so there are more checks below for `status --is-interactive`.
        return 0
    end
end

# Load custom executable functions
for function_file in ~/.config/fish/functions/*
    if test -f $function_file
        source $function_file
    end
end

# Load settings from ~/.config/fish/conf.d with pre, main, and post order
function _load_settings
    set _dir $argv[1]
    if test -d $_dir
        # Load pre config.d
        if test -d $_dir/pre
            for config in $_dir/pre/**/*
                if test -f $config; and not string match -q "*.zwc" $config
                    source $config
                end
            end
        end

        # Load main config.d (excluding pre, post directories and .zwc files)
        for config in $_dir/**/*
            if test -f $config
                set config_basename (basename $config)
                set config_parent (basename (dirname $config))
                if not string match -q -r "(pre|post)" $config_parent; and not string match -q "*.zwc" $config
                    source $config
                end
            end
        end

        # Load post conf.d
        if test -d $_dir/post
            for config in $_dir/post/**/*
                if test -f $config; and not string match -q "*.zwc" $config
                    source $config
                end
            end
        end
    end
end

_load_settings "$HOME/.config/fish/config.d"

# Local config
if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end

# Aliases
if test -f ~/.config/fish/aliases.fish
    source ~/.config/fish/aliases.fish
end
