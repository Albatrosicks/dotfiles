# install zinit if not installed
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
fi

# init zinit
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -U +X _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Customize Zinit message colors
ZINIT+=(
  col-pname   $'\e[1;4m\e[38;5;67m'               col-uname   $'\e[1;4m\e[38;5;140m' col-keyword $'\e[14m'
  col-note    $'\e[38;5;248m'                      col-error   $'\e[1m\e[38;5;174m'   col-p       $'\e[38;5;110m'
  col-info    $'\e[38;5;108m'                      col-info2   $'\e[38;5;179m'        col-profile $'\e[38;5;248m'
  col-uninst  $'\e[38;5;108m'                      col-info3   $'\e[1m\e[38;5;179m'   col-slight  $'\e[38;5;229m'
  col-failure $'\e[38;5;174m'                      col-happy   $'\e[1m\e[38;5;108m'   col-annex   $'\e[38;5;108m'
  col-id-as   $'\e[4;38;5;179m'                    col-version $'\e[3;38;5;116m'
  col-pre     $'\e[38;5;146m'                      col-msg     $'\e[0m'               col-msg2    $'\e[38;5;174m'
  col-obj     $'\e[38;5;110m'                      col-obj2    $'\e[38;5;108m'        col-file    $'\e[3;38;5;110m'
  col-dir     $'\e[3;38;5;108m'                    col-func    $'\e[38;5;182m'
  col-url     $'\e[38;5;110m'                      col-meta    $'\e[38;5;104m'        col-meta2   $'\e[38;5;146m'
  col-data    $'\e[38;5;108m'                      col-data2   $'\e[38;5;108m'        col-hi      $'\e[1m\e[38;5;108m'
  col-var     $'\e[38;5;110m'                      col-glob    $'\e[38;5;179m'        col-ehi     $'\e[1m\e[38;5;174m'
  col-cmd     $'\e[38;5;108m'                      col-ice     $'\e[38;5;74m'         col-nl      $'\n'
  col-txt     $'\e[38;5;108m'                      col-num     $'\e[3;38;5;151m'      col-term    $'\e[38;5;180m'
  col-warn    $'\e[38;5;174m'                      col-apo     $'\e[1;38;5;179m'      col-ok      $'\e[38;5;179m'
  col-faint   $'\e[38;5;246m'                      col-opt     $'\e[38;5;182m'        col-lhi     $'\e[38;5;110m'
  col-tab     $' \t '                              col-msg3    $'\e[38;5;246m'        col-b-lhi   $'\e[1m\e[38;5;110m'
  col-bar     $'\e[38;5;108m'                      col-th-bar  $'\e[38;5;108m'
  col-rst     $'\e[0m'                             col-b       $'\e[1m'               col-nb      $'\e[22m'
  col-u       $'\e[4m'                             col-it      $'\e[3m'               col-st      $'\e[9m'
  col-nu      $'\e[24m'                            col-nit     $'\e[23m'              col-nst     $'\e[29m'
  col-bspc    $'\b'                                col-b-warn  $'\e[1;38;5;174m'      col-u-warn  $'\e[4;38;5;174m'
  col-mdsh    $'\e[1;38;5;179m'"${${${(M)LANG:#*UTF-8*}:+–}:--}"$'\e[0m'
  col-mmdsh   $'\e[1;38;5;179m'"${${${(M)LANG:#*UTF-8*}:+――}:--}"$'\e[0m'
  col-↔       ${${${(M)LANG:#*UTF-8*}:+$'\e[38;5;108m↔\e[0m'}:-$'\e[38;5;108m«-»\e[0m'}
  col-…       "${${${(M)LANG:#*UTF-8*}:+…}:-...}"  col-ndsh    "${${${(M)LANG:#*UTF-8*}:+–}:-}"
  col--…      "${${${(M)LANG:#*UTF-8*}:+⋯⋯}:-···}" col-lr      "${${${(M)LANG:#*UTF-8*}:+↔}:-"«-»"}"
)

