{ ... }: {
    programs.atuin = {
        enable = true;
        enableFishIntegration = true;

        settings = {
            style = "compact";
            show_help = false;
            inline_height = 10;
            ctrl_n_shortcuts = true;
        };
    };
}