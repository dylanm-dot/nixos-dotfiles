{config, pkgs, ...}:

let
    dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
    create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    configs = {
	
    };
in

{
    home.username = "dylan";
    home.homeDirectory = "/home/dylan";
    home.stateVersion = "26.05";
    
    programs.fish = {
        enable = true;
	shellAliases = {
	    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos";
	};
	interactiveShellInit = ''
	    set -g fish_greeting ""
	    fastfetch
	'';
    };

    xdg.configFile = builtins.mapAttrs
	(name: subpath: {
	    source = create_symlink "${dotfiles}/${subpath}";
	    recursive = true;
	})
	configs;

    home.packages = with pkgs; [
	neovim
	ripgrep
	nil
	nixpkgs-fmt
	nodejs
	gcc
    ];
}
