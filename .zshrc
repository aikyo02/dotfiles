alias arst='asdf'
alias be='bundle exec'
alias bi='bundle install'
alias bu='bundle update'
alias c='git checkout `git branch | peco | sed -e "s/\* //g" | awk "{print \$1}"`'
alias cb='git rev-parse --abbrev-ref HEAD | tr -d "\n" | pbcopy'
alias co='git checkout'
alias com='git checkout master'
alias cof='git branch -D "\$1"; git checkout -b "\$1"'
alias cl='clear'
alias g='ctags -R -f ./.tags'
alias h='git lfhas | head'
alias l='less'
alias la='ls -a'
alias ll='ls -l'
alias mo='git fetch && git merge origin/`git rev-parse --abbrev-ref HEAD`'
alias p='peco'
alias pong='perl -nle '\''print "display notification \"$_\" with title \"Terminal\""'\'' | osascript'
alias rb='ruby'
alias rs='rustc'
alias rso='git fetch && git reset --hard origin/`git rev-parse --abbrev-ref HEAD`'
alias sl='ls'
alias st='git status'
alias t='hub'
alias ta='tig --all'
alias tbr='git browse-remote'
alias ter='terminal-notifier'
alias vi="vim"

# pecoでブランチを取得する
alias -g b='`git branch | peco | sed -e "s/^\*[ ]*//g"`'

# Fetch PR
function fp() {
  git fetch origin pull/$1/head:pr$1
}

# 特定のcommitが含まれるPRを探す find pull request. usage: fpr commit_hash [branch]
function fpr() {
  local parent=$2||'master'
  git log $1..$2 --merges --ancestry-path --reverse --oneline | head
}

function find-pr-open() {
  local pr="$(fpr $1 $2 | awk '{print substr($5, 2)}')"
  local repo="$(git config --get remote.origin.url | sed 's/git@github.com://' | sed 's/\.git$//')"
  open "https://github.com/${repo}/pull/${pr}"
}

function r() {
  hub browse -- commit/$1
  git checkout $1
}

# 自分用のコマンド
export PATH=$PATH:~/bin

### lsをカラー表示する
export CLICOLOR=1
export LSCOLORS=DxGxcxdxCxegedabagacad
export PATH=/Users/AikyoHiroshi/Documents/android/platform-tools:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Users/AikyoHiroshi/bin:/Applications/eclipse/android/platform-tools

export PATH=$HOME/.rbenv/shims:$PATH
eval "$(rbenv init -)"

# 履歴
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
autoload -Uz compinit compinit
fpath=(/usr/local/share/zsh-completions $fpath)
setopt share_history
setopt hist_ignore_all_dups

# ディレクトリ移動
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups


# プロンプト
parse-git-branch()
{
  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "${branch}" ]; then
    [ "${branch}" = "HEAD" ] && local branch=$(git rev-parse --short HEAD 2>/dev/null)
    local statusis="$(git status --porcelain 2>/dev/null)"
    echo -n " on %F{6}${branch}%f"
    [ -n "${statusis}" ] && echo -n "%F{3}*%f"
  fi
}

PROMPT="%F{6}%n%f at %F{6}%m%f in %F{6}%c%f$(parse-git-branch)
%# "

autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null
function rprompt-git-current-branch {
  local name st color gitdir action
  if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
    return
  fi

  name=`git rev-parse --abbrev-ref=loose HEAD 2> /dev/null`
  if [[ -z $name ]]; then
    return
  fi

  gitdir=`git rev-parse --git-dir 2> /dev/null`
  action=`VCS_INFO_git_getaction "$gitdir"` && action="($action)"

  if [[ -e "$gitdir/rprompt-nostatus" ]]; then
    echo "$name$action "
    return
  fi

  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    color=%F{green}
  elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
    color=%F{yellow}
  elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
    color=%B%F{red}
  else
    color=%F{red}
  fi

  echo "$color$name$action%f%b "
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst
RPROMPT='[`rprompt-git-current-branch`%~]'

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"


eval "$(direnv hook zsh)"

if which pyenv > /dev/null; then
  export PYENV_ROOT="${HOME}/.pyenv"
  export PATH=${PYENV_ROOT}/shims:${PATH}
  eval "$(pyenv init -)";
fi

# cd で移動した後に ls してほしい
function cd {
  builtin cd $argv
  ls
}

# peco
# bottom-up にしておくと目線の移動が少ない
function peco {
  command peco --layout=bottom-up $argv
}

function peco-execute-history() {
  local item
  item=$(builtin history -n -r 1 | peco)
  if [[ -z "$item" ]]; then
    return 1
  fi
  BUFFER="$item"
  zle accept-line
}
zle -N peco-execute-history
bindkey '^r' peco-execute-history

function peco-put-history() {
  local item
  item=$(builtin history -n -r 1 | peco)
  if [[ -z "$item" ]]; then
    return 1
  fi
  BUFFER="$item"
  CURSOR=$#BUFFER
}
zle -N peco-put-history
bindkey '^f' peco-put-history

# 補完
fpath=($(brew --prefix)/share/zsh/site-functions $fpath)

autoload -U compinit
compinit -u

# brew install
export PATH="/usr/local/Cellar/git/2.2.0:$PATH"

# oracle
export ORACLE_HOME=${HOME}/opt/oracle
export PATH=${ORACLE_HOME}/bin:$PATH
export DYLD_LIBRARY_PATH=${ORACLE_HOME}/lib

# shell キーバインド
bindkey "^[[3~" delete-char

# npm
export PATH="/usr/local/share/npm/bin:$PATH"

# rust_src_path for racer
export RUST_SRC_PATH="/Users/aikyo/gr/rust/src"
# asdf
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

