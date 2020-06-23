{ config, pkgs, ... }:

let
  keycodes = import ./keycodes.nix;
in
{
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      focus_follows_mouse = "autoraise";
      mouse_follows_focus = "off";
      window_placement = "second_child";
      window_opacity = "off";
      window_opacity_duration = "0.0";
      window_border = "on";
      window_border_placement = "inset";
      window_border_width = 3;
      window_border_radius = 10;
      active_window_border_topmost = "off";
      window_topmost = "on";
      window_shadow = "float";
      active_window_border_color = "0xccff00af";
      normal_window_border_color = "0xff505050";
      insert_window_border_color = "0xffd75f5f";
      active_window_opacity = "1.0";
      normal_window_opacity = "1.0";
      split_ratio = "0.50";
      auto_balance = "on";
      mouse_modifier = "fn";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      layout = "bsp";
      top_padding = 42;
      bottom_padding = 16;
      left_padding = 16;
      right_padding = 16;
      window_gap = 16;
    };

    extraConfig = ''
      # rules
      yabai -m rule --add app='System Preferences' manage=off

      # Any other arbitrary config here
      ## yabai -m config window_border on
      ## yabai -m config window_border_width 6
      ## yabai -m config normal_window_border_color 0xff555555
      ## yabai -m config active_window_border_color 0xff775799
    '';
  };

  services.spacebar.enable = true;
  services.spacebar.package = pkgs.spacebar;
  services.spacebar.config = {
    clock_format = "%R";
    space_icon_strip = "   ";
    text_font = ''"Helvetica Neue:Bold:16.0"'';
    icon_font = ''"FontAwesome:Regular:16.0"'';
    background_color = "0xff202020";
    foreground_color = "0xffa8a8a8";
    power_icon_strip = " ";
    space_icon = "";
    clock_icon = "";
  };

  services.skhd.enable = true;
  services.skhd.package = pkgs.skhd;
  services.skhd.skhdConfig = let
    ## modMask = "cmd";
    modMask = "alt";
    moveMask = "ctrl + cmd";
    myTerminal = "emacsclient -a '' -nc --eval '(peel/vterm)'";
    myEditor = "emacsclient -a '' -nc";
    myBrowser = "open /Applications/Firefox\ Developer\ Edition.app";
    noop = "/dev/null";
    prefix = "${pkgs.yabai}/bin/yabai -m";
    fstOrSnd = { fst, snd }: domain: "${prefix} ${domain} --focus ${fst} || ${prefix} ${domain} --focus ${snd}";
    nextOrFirst = fstOrSnd { fst = "next"; snd = "first"; };
    prevOrLast = fstOrSnd { fst = "prev"; snd = "last"; };
  in
    ''
      # windows ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
      # select
      ${modMask} + shift - j                            : ${prefix} window --focus next || ${prefix} window --focus "$((${prefix} query --spaces --display next || ${prefix} query --spaces --display first) |${pkgs.jq}/bin/jq -re '.[] | select(.visible == 1)."first-window"')" || ${prefix} display --focus next || ${prefix} display --focus first
      ${modMask} + shift - k                            : ${prefix} window --focus prev || ${prefix} window --focus "$((yabai -m query --spaces --display prev || ${prefix} query --spaces --display last) | ${pkgs.jq}/bin/jq -re '.[] | select(.visible == 1)."last-window"')" || ${prefix} display --focus prev || ${prefix} display --focus last
      # close
      ${modMask} + shift - ${keycodes.Delete}           : ${prefix} window --close
      # fullscreen
      ${modMask} + shift - return                            : ${prefix} window --toggle zoom-fullscreen
      # rotate
      ${modMask} + shift - r                            : ${prefix} space --rotate 180
      # increase region
      ${modMask} + shift - ${keycodes.LeftBracket}      : ${prefix} window --resize left:-20:0
      ${modMask} + shift - ${keycodes.RightBracket}     : ${prefix} window --resize right:-20:0
    
      ## # spaces ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
      ## # switch 
      ## ${modMask} + alt - j                      : ${prevOrLast "space"}
      ## ${modMask} + alt - k                      : ${nextOrFirst "space"}
      ## # send window 
      ## ${modMask} + ${moveMask} - j              : ${prefix} window --space prev
      ## ${modMask} + ${moveMask} - k              : ${prefix} window --space next
      ## # display  ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
      ## # focus 
      ## ${modMask} - left                         : ${prevOrLast "display"}
      ## ${modMask} - right                        : ${nextOrFirst "display"}
      ## # send window
      ## ${moveMask} - right                       : ${prefix} window --display prev
      ## ${moveMask} - left                        : ${prefix} window --display next
      ## # apps  ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
      ## ${modMask} - return                       : ${myTerminal} 
      ## ${modMask} + shift - return               : ${myEditor}
      ## ${modMask} - b                            : ${myBrowser}
      ## # reset  ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
      ## ${modMask} - q                            : pkill yabai; pkill skhd
    '';
}
