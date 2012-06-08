colorface_strip () {
  local subst='s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g'
  print -P "$1" | sed -r "$subst"
}

setprompt () {
  local state="%{%(?|%(!.$fg_no_bold[yellow].$fg_no_bold[green])|$fg_no_bold[red])%}"
  local priv="%{%(!|$fg_bold[red]|$fg_bold[cyan])%}"
  local header="${priv}%n%{$fg_no_bold[white]%}@%{$fg_no_bold[blue]%}%m"
  local pr1h="┌──────[ "
  local pr1c="${header}${state} : %{$fg_bold[yellow]%}"
  local pr1cs="`colorface_strip \"$pr1c\"`"
  local pr1t=" ]"
  local pr1len="$(( ${#pr1h} + ${#pr1cs} + ${#pr1t} ))"
  local face="%(?|%(!|c.c|^_^)|>_<)"

  ZSH_THEME_GIT_PROMPT_PREFIX="$state on %{$fg_bold[magenta]%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX=""
  ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}*"
  ZSH_THEME_GIT_PROMPT_CLEAN=""

  local wdexpn='${ZSH_THEME_COLORFACE_PWD}'
  local gpexpn='${ZSH_THEME_COLORFACE_GITPART}'
  local gpsexpn='${ZSH_THEME_COLORFACE_GITPART_STRIPPED}'

  local endl=$'\r\n'
  local pr2="└($face)─%(!.#.$) %{$reset_color%}"

  ZSH_THEME_COLORFACE_LINELEN="$pr1len"

  #ZSH_THEME_TERM_TAB_TITLE_IDLE="%15<..<$wdexpn%<<"
  #ZSH_THEME_TERM_TITLE_IDLE="$pr1cs$wdexpn$gpsexpn"

  PS1="$state$pr1h$pr1c$wdexpn$gpexpn$state$pr1t$endl$pr2"
  RPROMPT=""
}

precmd () {
  local gp="$(git_prompt_info)"
  local gps="`colorface_strip \"$gp\"`"
  local pr1len="$(( ${ZSH_THEME_COLORFACE_LINELEN} + ${#gps} ))"

  local wd="${PWD/#$HOME/~}"
  local wdlen="${#wd}"

  local wdsize=""

  if [[ "$pr1len + $wdlen" -gt (($COLUMNS - 1)) ]]; then
      ((wdsize=$COLUMNS - 1 - $pr1len))
  fi

  local wdtrunc="%$wdsize<...<$wd%<<"

  ZSH_THEME_COLORFACE_PWD="$wdtrunc"
  ZSH_THEME_COLORFACE_GITPART="$gp"
  ZSH_THEME_COLORFACE_GITPART_STRIPPED="$gps"
}

setprompt
