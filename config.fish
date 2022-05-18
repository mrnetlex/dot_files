if status is-interactive
    # Commands to run in interactive sessions can go here

    #Remove welcome message
    set fish_greeting

    # Set settings for https://github.com/franciscolourenco/done
    set -U __done_min_cmd_duration 10000
    set -U __done_notification_urgency_level low
    
    ## Useful aliases

    # Replace ls with exa
    alias ls='exa -al --color=always --group-directories-first --icons' # preferred listing
    alias la='exa -a --color=always --group-directories-first --icons'  # all files and dirs
    alias ll='exa -l --color=always --group-directories-first --icons'  # long format
    alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
    alias l.="exa -a | egrep '^\.'"                                     # show only dotfiles
    alias ip="ip -color"
    
    # Replace some more things with better alternatives
    alias cat='bat --style header --style rules --style snip --style changes --style header'
    [ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'
 
    # Common use
    alias grubup="sudo update-grub"
    alias fixpacman="sudo rm /var/lib/pacman/db.lck"
    alias tarnow='tar -acf '
    alias untar='tar -xvf '
    alias wget='wget -c '
    alias rmpkg="sudo pacman -Rdd"
    alias psmem='ps auxf | sort -nr -k 4'
    alias psmem10='ps auxf | sort -nr -k 4 | head -10'
    alias upd='/usr/bin/update'
    alias ..='cd ..'
    alias ...='cd ../..'
    alias ....='cd ../../..'
    alias .....='cd ../../../..'
    alias ......='cd ../../../../..'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias hw='hwinfo --short'                                   # Hardware Info
    alias big="expac -H M '%m\t%n' | sort -h | nl"              # Sort installed packages according to size in MB
    alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'			# List amount of -git packages

    # Get fastest mirrors
    alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
    alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
    alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
    alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"
    
    
    ## Functions
        # Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
        function __history_previous_command
          switch (commandline -t)
          case "!"
            commandline -t $history[1]; commandline -f repaint
          case "*"
            commandline -i !
          end
        end
        
        function __history_previous_command_arguments
          switch (commandline -t)
          case "!"
            commandline -t ""
            commandline -f history-token-search-backward
          case "*"
            commandline -i '$'
          end
        end
        
        if [ "$fish_key_bindings" = fish_vi_key_bindings ];
          bind -Minsert ! __history_previous_command
          bind -Minsert '$' __history_previous_command_arguments
        else
          bind ! __history_previous_command
          bind '$' __history_previous_command_arguments
        end
        
        # Fish command history
        function history
            builtin history --show-time='%F %T '
        end
        
        function backup --argument filename
            cp $filename $filename.bak
        end

           #zoxide 
        zoxide init fish | source

        #navi
        navi widget fish | source
        
        #micro custom  colorscheme
        export MICRO_TRUECOLOR=1
    
    #run pfetch
pfetch

    #some starship stuff - command prompt
starship init fish | source
end
