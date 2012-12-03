# ------------------------------------------------------------------------
# Alexis GRIMALDI oh-my-zsh theme (inspired by Juan G. Hurtado)
# (Needs Git plugin for current_branch method)
# ------------------------------------------------------------------------

# Color shortcuts
RED=$fg[red]
YELLOW=$fg[yellow]
GREEN=$fg[green]
WHITE=$fg[white]
BLUE=$fg[blue]
MAGENTA=$fg[magenta]
RED_BOLD=$fg_bold[red]
YELLOW_BOLD=$fg_bold[yellow]
GREEN_BOLD=$fg_bold[green]
WHITE_BOLD=$fg_bold[white]
BLUE_BOLD=$fg_bold[blue]
RESET_COLOR=$reset_color

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$RESET_COLOR%})"

# Format for parse_git_dirty()
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$RED%}*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_UNMERGED=" %{$RED_BOLD%}U"
ZSH_THEME_GIT_PROMPT_DELETED=" %{$RED_BOLD%}D"
ZSH_THEME_GIT_PROMPT_RENAMED=" %{$YELLOW_BOLD%}R"
ZSH_THEME_GIT_PROMPT_MODIFIED=" %{$YELLOW_BOLD%}M"
ZSH_THEME_GIT_PROMPT_ADDED=" %{$GREEN_BOLD%}A"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$WHITE_BOLD%}u"

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$RED%}!"

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$GREEN_BOLD%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$YELLOW_BOLD%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$RED_BOLD%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$RESET_COLOR%}"

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function git_time_since_commit() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Only proceed if there is actually a commit.
        if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
            # Get the last commit.
            last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
            now=`date +%s`
            seconds_since_last_commit=$((now-last_commit))

            # Totals
            MINUTES=$((seconds_since_last_commit / 60))
            HOURS=$((seconds_since_last_commit/3600))

            # Sub-hours and sub-minutes
            DAYS=$((seconds_since_last_commit / 86400))
            SUB_HOURS=$((HOURS % 24))
            SUB_MINUTES=$((MINUTES % 60))

            if [[ -n $(git status -s 2> /dev/null) ]]; then
                if [ "$MINUTES" -gt 30 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
                elif [ "$MINUTES" -gt 10 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
                else
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
                fi
            else
                COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            fi

            if [ "$HOURS" -gt 24 ]; then
                echo "($COLOR${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m%{$reset_color%}|"
            elif [ "$MINUTES" -gt 60 ]; then
                echo "($COLOR${HOURS}h${SUB_MINUTES}m%{$reset_color%}|"
            else
                echo "($COLOR${MINUTES}m%{$reset_color%}|"
            fi
        else
            COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            echo "($COLOR~|"
        fi
    fi
}

function prompt_char() {
  git branch >/dev/null 2>/dev/null && echo "%{$fg[green]%}± %{$reset_color%}" && return
  echo "%{$FG[105]%}> %{$reset_color%}"
}

# display exitcode on the right when >0
return_code="%(?..%{$RED%}%? ↵%{$RESET_COLOR%})"

# Prompt format
PROMPT='
$FG[237]------------------------------------------------------------%{$reset_color%}
%{$FG[237]%}%m%{$RESET_COLOR%}:%{$FG[032]%}%~ %{$RESET_COLOR%}$(git_time_since_commit)%{$FG[105]%}$(git_prompt_info)%{$RESET_COLOR%}$(git_prompt_status)%{$RESET_COLOR%}
$(prompt_char)'
RPROMPT='${return_code}'
SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r?$reset_color (Yes, No, Abort, Edit) "
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S'
