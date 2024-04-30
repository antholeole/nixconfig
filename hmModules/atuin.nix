{ ... }: {
    programs.atuin = {
        enable = true;
        enableFishIntegration = true;

        flags = [
          "--disable-up-arrow"
        ];

        settings = {
            style = "compact";
            show_help = false;
            inline_height = 13;
            invert = true;
            enter_accept = true;

            # not working?
            ctrl_n_shortcuts = true;
        };
    };
}