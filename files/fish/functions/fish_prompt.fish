#    
#  
#  
#  󰌾
# 󰬃 󰫿 󰫻
#     󱡋

function fish_prompt
  set -l color_white '#ffffff'
  set -l color_grad_1 '#e42dc0'
  set -l color_grad_2 '#bd4bcb'
  set -l color_grad_3 '#9b65d4'
  set -l color_grad_4 '#7483df'
  set -l color_grad_5 '#509fe9'
  set -l color_grad_6 '#27bff4'
  set -l color_grad_7 '#00ddff'
  set -l color_red '#e73155'
  set -l color_cyan '#06ecf8'
  set -l color_magenta '#f913a9'
  set -l color_green '#06f8a6'
  set -l color_orange '#f8b606'

  set_color $color_white; set_color -b $color_grad_1; echo -n ""

  set_color normal; echo " \> "
end
