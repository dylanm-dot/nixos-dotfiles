{ config, lib, pkgs, ... }:

{
    imports = [./hardware-configuration.nix];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_zen;

    systemd.user.services.cliphist-wipe-on-exit = {
	description = "Wipe cliphist history on shutdown";
	wantedBy = [ "default.target" ];
	serviceConfig = {
	    Type = "oneshot";
	    RemainAfterExit = true;
	    ExecStart = "${pkgs.coreutils}/bin/true";
	    ExecStop = "${pkgs.cliphist}/bin/cliphist wipe";
	};
    };

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

    services.displayManager.sddm = {
	enable = true;
	wayland.enable = true;
    };
    services.xserver.videoDrivers = ["nvidia"];
    services.flatpak.enable = true;

    hardware.nvidia = {
	modesetting.enable = true;
	open = true;
	nvidiaSettings = true;
	package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    environment.sessionVariables = {
	LIBVA_DRIVER_NAME = "nvidia";
	__GLX_VENDOR_LIBRARY_NAME = "nvidia";
	NVD_BACKEND = "direct";
	WLR_NO_HARDWARE_CURSORS = "1";
    };

    time.timeZone = "America/New_York";

    programs.mangowc.enable = true;
    programs.steam.enable = true;
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
        wofi
        yazi
	unzip
	foot
	ntfs3g
        egl-wayland
	ntfsprogs
	flatpak
    ];

    fonts.packages = with pkgs; [
	nerd-fonts.jetbrains-mono
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];

    system.stateVersion = "26.05";
}

