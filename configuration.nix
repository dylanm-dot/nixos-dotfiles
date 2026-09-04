{ config, lib, pkgs, ... }:

{
    imports = [ ./hardware-configuration.nix ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_zen;

    networking.hostName = "nixos";
    networking.useDHCP = true;

    time.timeZone = "America/New_York";

    services.xserver.videoDrivers = ["nvidia"];
    services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
	wireplumber.enable = true;
    };

    security.polkit.enable = true;

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


    hardware.nvidia = {
	modesetting.enable = true;
	open = true;
	nvidiaSettings = true;
	package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    hardware.graphics.enable = true;

     environment.sessionVariables = {
	LIBVA_DRIVER_NAME = "nvidia";
	__GLX_VENDOR_LIBRARY_NAME = "nvidia";
	NVD_BACKEND = "direct";
	WLR_NO_HARDWARE_CURSORS = "1";
     };

    users.users.dylan = {
	isNormalUser = true;
	extraGroups = [ "wheel" "video" "seat" ];
	shell = pkgs.fish;
	packages = with pkgs; [
	    tree
	];
    };

    environment.systemPackages = with pkgs; [
	uwsm
	vim
	wget
	git
	egl-wayland
	alacritty
	fish
    ];

    programs.fish.enable = true;
    programs.niri.enable = true;
    programs.mango.enable = true;
    
    fonts.packages = with pkgs; [
	nerd-fonts.jetbrains-mono
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];

    system.stateVersion = "26.05";

}

