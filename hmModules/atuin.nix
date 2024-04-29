{ ... }: {
    programs.atuin = {
        enable = true;
        enableFishIntegration = true;

        settings = {
            style = "compact";
            show_help = false;
            inline_height = 13;

            # not working?
            ctrl_n_shortcuts = true;
        };
    };
}