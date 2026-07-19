# Detect TTY vs GUI

if test "$TERM" = linux
    echo ""
else
    set -x STARSHIP_CONFIG ~/.config/starship/starship.toml
    starship init fish | source
end
