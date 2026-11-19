function cx --description 'Clear the screen and scrollback, then start Claude Code'
    # 2J clears the visible screen, 3J clears the scrollback buffer and H homes the cursor: a harder
    # reset than `clear`, which leaves scrollback intact.
    printf '\e[2J\e[3J\e[H'
    claude --allow-dangerously-skip-permissions
end
