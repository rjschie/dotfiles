function skills
    set -lx XDG_STATE_HOME $DOTFILES/files/claude
    switch "$argv[1]"
        case add
            bunx skills add $argv[2..] -g --copy --agent 'claude-code'
        case ls list
            bunx skills list $argv[2..] -g
        case rm remove
            bunx skills remove $argv[2..] -g
        case update
            bunx skills update $argv[2..] -g
        case '--update'
            set -l old_version $(bunx skills --version)
            set -l new_version $(bunx skills@latest --version)
            if test "$new_version" = "$old_version"
              echo "No update"
            else
              echo "Updated to skills $new_version (from: $old_version)"
            end
        case '*'
            bunx skills $argv
    end
end
