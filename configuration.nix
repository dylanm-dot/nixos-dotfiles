{ config, lib, pkgs, ... }:

{
    imports = [./hardware-configuration.nix];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_zen;

    fileSystems."/mnt/NTFSmount" = {
	device = "/dev/disk/by-uuid/A84262A842627B48";
	fsType = "ntfs";
	options = [
	    "users"
	    "nofail"
	    "exec"
	];
    };

    fileSystems."/mnt/Ext4mount" = {
	device = "/dev/disk/by-uuid/72663076-e65e-4ad1-af41-dc4bdc508cac";
	fsType = "ext4";
	options = [
	    "users"
	    "nofail"
	    "exec"
	];
    };

    networking.hostName = "nixos";
    networking.useDHCP = true;

    programs.fish.enable = true;

    users.users.dylan = {
	isNormalUser = true;
	extraGroups = ["wheel" "video"];
	shell = pkgs.fish;
	packages = with pkgs; [
	    tree
	];
    };

    environment.systemPackages = with pkgs; [
	vim
	wget        
	unzip
	ntfs3g
	ntfsprogs
    ];

    fonts.packages = with pkgs; [
	nerd-fonts.jetbrains-mono
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];

    system.stateVersion = "26.05";
}

