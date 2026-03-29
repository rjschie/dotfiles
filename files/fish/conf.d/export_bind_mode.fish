function rerender_on_bind_mode_change --on-variable fish_bind_mode
  if type -q omp_repaint_prompt
    if test "$fish_bind_mode" != "$FISH__BIND_MODE"
      set -gx FISH__BIND_MODE $fish_bind_mode
        omp_repaint_prompt
    end
  end
end
