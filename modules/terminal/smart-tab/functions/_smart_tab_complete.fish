function _smart_tab_complete
    set -l token (commandline -ct)
    set -l buffer (commandline -b)

    # If the buffer is completely empty, default to normal completion
    if test -z "$buffer"
        commandline -f complete
        return
    end

    # Priority 1: Check for file/directory matches using native globbing
    set -l has_files 0
    if test -n "$token"
        for f in $token*
            if test -e "$f"
                set has_files 1
                break
            end
        end
    end

    if test $has_files -eq 1
        # Match found: invoke Fish's native completion pager for visual selection
        commandline -f complete
    else
        # Priority 2: History Search based on the entire buffer
        set -l hist_match (history search --prefix "$buffer" | head -n 1)
        
        if test -n "$hist_match"
            # History match found: replace buffer and move cursor to the end
            commandline -r "$hist_match"
            commandline -f end-of-line
        else
            # Fallback: if no files AND no history, default to normal completion
            commandline -f complete
        end
    end
end
