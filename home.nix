{config, pkgs, ...}:

let
    dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
    create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    configs = {
	mango = "mango";
	nvim = "nvim";
	foot = "foot";
	equibop = "equibop";
	waybar = "waybar";
	colors = "colors";
	mpv = "mpv";
	fastfetch = "fastfetch";
	wofi = "wofi";
    };
in

{
    home.username = "dylan";
    home.homeDirectory = "/home/dylan";
    home.stateVersion = "26.05";
    
    programs.git = {
	enable = true;
	settings.user.name = "dylanm-dot";
	settings.user.email = "figment_lawless.2a@icloud.com";
    };
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
	equibop
	ripgrep
	wofi
	nil
	swaybg
	waybar
	nixpkgs-fmt
	nodejs
	gcc
	yazi
	librewolf
	spotify
	steam
	playerctl
	fastfetch
	cliphist
	wl-clipboard
	slurp
	mpv
	grim
	git
	fish
	wayfreeze
    ];
}
