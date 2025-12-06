{
  system.activationScripts.updateLibinputQuirks = {
    text = ''
      mkdir -p /etc/libinput
      QUIRKS_FILE="/etc/libinput/local-overrides.quirks"
      if [ -f "$QUIRKS_FILE" ]; then
        rm "$QUIRKS_FILE"
      fi
      cat <<EOF > "$QUIRKS_FILE"
      [Framework Laptop 16 Keyboard Module]
      MatchName=Framework Laptop 16 Keyboard Module*
      MatchUdevType=keyboard
      MatchDMIModalias=dmi:*svnFramework:pnLaptop16*
      AttrKeyboardIntegration=external
      EOF
    '';
  };
  services.libinput = {
    enable = true;
    touchpad.disableWhileTyping = false; # may need lib.mkForce
  };
}
