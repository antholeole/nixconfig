{
  overlay = self: super: {
    gapp = super.writeShellApplication {
      runtimeInputs = with super; [ super.chromium ];
      name = "gapp";
      text = ''
        #!/usr/bin/env bash
        APP=""

        case $1 in
            mail)
                APP="gmail"
            ;;
            jamboard)
                APP="jamboard.google"
            ;;
            docs)
                APP="docs.google"
            ;;
            bard)
                APP="bard.google"
            ;;
            slides)
                APP="slides.google"
            ;;
            keep)
                APP="keep.google"
            ;;
            *)
                echo "Unknown Google App \"$1\""
                exit 1
            ;;
        esac

        ${super.chromium.outPath}/bin/chromium --new-window --app="https://$APP.com"
      '';
    };
  };
}
