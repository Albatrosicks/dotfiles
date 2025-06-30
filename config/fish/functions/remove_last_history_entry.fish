function remove_last_history_entry --description "Remove last N entries from fish history" --argument-names count
    set count (test -n "$count"; and echo $count; or echo 1)

    if not string match -qr '^\d+$' $count
        echo "Invalid argument. Please provide a number."
        return 1
    end

    for i in (seq $count)
        history delete --exact --case-sensitive (history | head -1)
    end

    echo "Removed last $count command(s) from history."
end
