{ config, pkgs, ... }:

let
    dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
    create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    configs = {
	equibop = "equibop";
	nvim = "nvim";
	theme = "theme";
	mpv = "mpv";
	fastfetch = "fastfetch";
	niri = "niri";
	mango = "mango";
	waybar = "waybar";
	swaybg = "swaybg";
	wofi = "wofi";
	alacritty = "alacritty";
    };
in

{
    home.username = "dylan";
    home.homeDirectory = "/home/dylan";
    home.stateVersion = "26.05";

    programs.git.enable = true;

    programs.fish = {
	enable = true;
	shellAliases = {
	    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos";
	};
	interactiveShellInit = ''
	    set fish_greeting
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
	gnumake
	mpv
	librewolf
	equibop
	waybar
	swaybg
	fastfetch
	wl-clipboard
	grim
	slurp
	wayfreeze
	yazi
	wofi
	playerctl
    ];
}
