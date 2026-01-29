{pkgs, ...}: {
  home.packages = [pkgs.rclone pkgs.fuse3];
  systemd.user.services.rclone-arc-mount = {
    Unit = {
      Description = "Rclone Mount for Arc Remote";
      After = ["network-online.target"];
    };
    Service = {
      Type = "simple";
      ExecStartPre = [
        "-/run/wrappers/bin/fusermount3 -uz %h/Arc"
        "${pkgs.coreutils}/bin/mkdir -p %h/Arc"
      ];
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount Arc: %h/Arc \
          --config=/etc/nixos/modules/desktop-environment/rclone.conf \
          --vfs-cache-mode full \
          --vfs-cache-max-age 24h \
          --vfs-cache-max-size 10G \
          --vfs-read-chunk-size 32M \
          --vfs-read-chunk-size-limit 1G \
          --buffer-size 64M \
          --dir-cache-time 1000h \
          --attr-timeout 1000h
      '';
      ExecStop = "/run/wrappers/bin/fusermount3 -u %h/Arc";
      Environment = "PATH=/run/wrappers/bin:$PATH";

      Restart = "on-failure";
      RestartSec = "10s";
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };
}
