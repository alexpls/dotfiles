function fish_jj_prompt --description 'Write out the jj prompt'
    # Is jj installed?
    if not command -sq jj
        return 1
    end

    # Are we in a jj repo?
    if not jj root --quiet &>/dev/null
        return 1
    end

    # Generate prompt
    jj log --ignore-working-copy --no-graph --color always -r @ -T '
        surround(
            " (",
            ")",
            separate(
                " ",
                bookmarks.join(", "),
                change_id.shortest(),
                if(conflict, "(conflict)"),
                if(empty, "(empty)"),
                if(divergent, "(divergent)"),
                if(hidden, "(hidden)"),
            )
        )
    '
end

