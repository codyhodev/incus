export PULSE_RUNTIME_PATH="/tmp/run/user/$(id --user)/pulse"
          
export DISPLAY=:0
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
export XDG_RUNTIME_DIR="/run/user/$(id --user)"

export XDG_CURRENT_DESKTOP=gtk
export XDG_SESSION_DESKTOP=gtk
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export QT4_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
export INPUT_METHOD=fcitx
export NO_AT_BRIDGE=1