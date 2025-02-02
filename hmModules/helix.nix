{pkgs, ...}: {
    programs.helix = {
        package = pkgs.helix;
        enable = true;
        defaultEditor = true;
        extraPackages = with pkgs; [
            alejandra
            nil
            metals
            gopls
        ];

       settings = {
            theme = "gruvbox";  

        keys = {
            normal = {
               ret = "goto_word";
            };
        };


        editor = {
            line-number = "relative";      
            rulers = [ 80 ];
            jump-label-alphabet = "hjklabcdefgimnopqrstuvwxyz";

            # TODO: add some clipboard providers

            lsp = {
                display-inlay-hints = true;
            };

            auto-save.after-delay.timeout = 3000;

            end-of-line-diagnostics = "hint"; 
            inline-diagnostics = {
                  cursor-line = "warning";
            };
        };
        
         };
        languages = {
            nil.formatting.command = "alejandra";
        };



};}

