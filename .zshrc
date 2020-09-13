export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export MY_BIN=$HOME/code/lfoot
export PATH=$PATH:$MY_BIN

#if [ -f $(brew --prefix)/etc/bash_completion ]; then
#  . $(brew --prefix)/etc/bash_completion
#fi

function start_proxy {
    export http_proxy='http://127.0.0.1:8001'
    export HTTPS_PROXY='http://127.0.0.1:8001'
}

function stop_proxy {
    export http_proxy=
    export HTTPS_PROXY=
}
#alias proxy='export all_proxy=socks5://127.0.0.1:1080'
alias proxy='export all_proxy=http://127.0.0.1:8001'
alias unproxy='unset all_proxy'

alias ls='ls -G'
alias ssh='ssh -o "ServerAliveInterval 60"'
export PATH="/usr/local/opt/gettext/bin:$PATH"
export PATH="/usr/local/eosio/bin:/usr/local/opt/gettext/bin:$PATH"
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
