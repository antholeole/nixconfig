{
  overlay = self: super: {
    shutter-save = super.writeShellApplication {
      runtimeInputs = with super; [ grim slurp ];
      name = "shutter-save";
      text = ''
        #!/usr/bin/env bash

        ${super.grim}/bin/grim -g "$(${super.slurp}/bin/slurp)" - > "$XDG_DOWNLOAD_DIR/screenshot_RAW.png"

        # rename it to have a random ending
        UNIQUE_OUT="$XDG_DOWNLOAD_DIR/screenshot_$RANDOM.png"

        mv "$XDG_DOWNLOAD_DIR/screenshot_RAW.png" "$UNIQUE_OUT"

        # ba dum tss
        notify-send "Screenshot Saved!" "$UNIQUE_OUT"
      '';
    };
  };
}
