## TODO
#
# [x] autocomplete '.' command
# [ ] autocomplete top-level commands
# [ ] shorten command to all just top-level with auto-complete
# [ ] Remove `n new` commands and just create if non exists

## ---------------------------
##          LAYOUTS
## ---------------------------

## ---------------------------
##      HELPER FUNCTIONS
## ---------------------------
function __myfish_debug               ; return; set_color green; echo "  [DEBUG] [$argv[1]]: $argv[2]"; set_color normal; end
function __myfish_throwerr            ; set_color red; echo "[ERROR] [$argv[1]]: $argv[2]"; set_color normal; end
function __myfish_get_curr_session  -S
  set -l session (tmux list-sessions -F "#{session_name}" -f "#{session_attached}")
  if test -z "$session"
    cat $STATE_DIR/curr_session
  else
    echo -n $session
  end
end
function __myfish_get_prev_session  -S; cat $STATE_DIR/prev_session; end
function __myfish_get_all_sessions  -S; tmux list-sessions -F "#{session_name}"; end
function __myfish_save_curr_session -S
  if test ! $argv[1]
    __myfish_throwerr "save_curr_session" "No session name given"
    return
  end
  __myfish_debug "save_curr_session" "Saving current session as $argv[1]"
  echo $argv[1] > $STATE_DIR/curr_session
end
function __myfish_save_prev_session -S
  if test ! $argv[1]
    __myfish_throwerr "save_prev_session" "No session name given"
    return
  end
  __myfish_debug "save_prev_session" "Saving prev session as $argv[1]"
  echo $argv[1] > $STATE_DIR/prev_session
end

function __myfish_tm_init -S
  if test ! -d $STATE_DIR
    mkdir -p $STATE_DIR
  end

  if test ! -f $STATE_DIR/README
    echo "My TMUX Session manager" > $STATE_DIR/README
  end

  touch $STATE_DIR/curr_session
  touch $STATE_DIR/prev_session
end

function __myfish_new_session -S
  __myfish_debug "new_session" "Creating new session named: $argv[1]"
  tmux new -s $argv[1] -d >/dev/null 2>&1
end

function __myfish_switch_session -S
  set -l target $argv[1]
  if ! tmux has-session -t $target
    __myfish_throwerr "switch_session" "Session ($target) does not exist"
    return
  end

  if test $TMUX
    __myfish_save_prev_session (__myfish_get_curr_session)
  end
  __myfish_save_curr_session $target

  if test $TMUX
    __myfish_debug "switch_session" "Switching to session: $target"
    tmux switch -t $target
  else
    __myfish_debug "switch_session" "Attaching to session: $target"
    tmux attach -t $target
  end
end

function __myfish_tmux_layout -S
  set -l layout_mac "37a5,220x69,0,0[220x64,0,0{110x64,0,0,7,109x64,111,0,9},220x4,0,65,8]"

  switch $argv[1]
  case mac
    tmux split-window
    tmux split-window
    tmux select-pane -D
    tmux select-layout "$layout_mac"
    clear
  end
end

## ---------------------------
##          MAIN
## ---------------------------
function tm -d "tmux management"
  set -f STATE_DIR $HOME/.local/state/tm
  set -f command $argv[1]
  # set -f target_session $argv[2]

  __myfish_tm_init

  switch $command
  case d detach
    tmux detach

  case at attach
    tmux attach

  case l ls
    __myfish_get_all_sessions

  case layout
    __myfish_tmux_layout $argv[2]

  case -
    set -l prev (__myfish_get_prev_session)

    if test -z "$prev"
      __myfish_throwerr "main" "No previous session"
    else
      __myfish_switch_session $prev
    end

  case __
    set -l tmux_session (tmux list-sessions -F "#{session_name}" -f "#{session_attached}")
    echo "ARGV: $argv"
    echo "get_curr_session: $(__myfish_get_curr_session)"
    echo "get_prev_session: $(__myfish_get_prev_session)"
    echo "tmux current session: $tmux_session"
    echo "current session file: $(cat $STATE_DIR/curr_session)"
    echo "prev session file: $(cat $STATE_DIR/prev_session)"

  case '*'
    __myfish_debug "main" "target: $target"
    set -l target $argv[1]
    if test -z "$target"
      __myfish_throwerr "main" "No target specified"
    else
      set -l all_targets $argv
      for t in $all_targets
        __myfish_debug "main" "Creating new session: $t"
        __myfish_new_session $t
      end
      __myfish_debug "main" "Switching to session $target"
      __myfish_switch_session $target
    end

  end
end

