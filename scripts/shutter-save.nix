{
  overlay = self: super: {
    shutter-save = super.writeShellApplication {
      runtimeInputs = with super; [ super.shutter ];
      name = "shutter-save";
      text = ''
        #!/usr/bin/env bash

        # get the output from shutter of the saved file name
        OUT=$(shutter -s -o "$XDG_DOWNLOAD_DIR/screenshot_RAW.png" -n -e -C \
        | grep "Saving file" \
        | awk '{print $3}' \
        | head -c -2)

        # rename it to have a random ending
        UNIQUE_OUT="$XDG_DOWNLOAD_DIR/screenshot_$RANDOM.png"
        mv "$OUT" "$UNIQUE_OUT"

        # ba dum tss
        notify-send "Screenshot Saved!" "$UNIQUE_OUT"
      '';
    };
  };
}
