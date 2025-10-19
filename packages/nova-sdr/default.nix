{ self, moduleWithSystem, ... }:
{
  perSystem =
    { config, pkgs, ... }:
    {
      packages.nova-sdr_frontend = pkgs.callPackage ./frontend.nix { };
      packages.nova-sdr = pkgs.callPackage ./backend.nix {
        html_root = config.packages.nova-sdr_frontend;
      };

      # nix run .#checks.<system>.default.driverInteractive
      # > <node>.shell_interact()
      checks.nova-sdr = pkgs.testers.runNixOSTest {
        name = "nova-sdr";
        nodes = {
          server =
            { config, pkgs, ... }:
            {
              imports = [ self.nixosModules.nova-sdr ];
              services.nova-sdr = {
                enable = true;
                settings = {
                  server = {
                    port = 9002;
                    host = "127.0.0.1";
                    # html_root is automatically set to the package's frontend
                    otherusers = 1;
                    threads = 1;
                  };

                  websdr = {
                    register_online = false;
                    name = "My NovaSDR";
                    antenna = "A piece of wire";
                    grid_locator = "";
                    hostname = "";
                    operator = "MyCallsign";
                    email = "contact@example.com";
                    callsign_lookup_url = "https://www.qrz.com/db/";
                    chat_enabled = false;
                  };

                  limits = {
                    audio = 100;
                    waterfall = 200;
                    events = 200;
                  };

                  input = {
                    sps = 2048000;
                    frequency = 100900000;
                    signal = "real";
                    fft_size = 131072;
                    fft_threads = 1;
                    brightness_offset = 0;
                    audio_sps = 12000;
                    waterfall_size = 1024;
                    waterfall_compression = "zstd";
                    audio_compression = "flac";
                    accelerator = "none";
                    smeter_offset = 0;

                    driver = {
                      name = "stdin";
                      format = "u8";
                    };

                    defaults = {
                      frequency = 88300000;
                      modulation = "WBFM";
                    };
                  };
                };
              };
            };
        };

        testScript = ''
          server.wait_for_unit("nova-sdr")
          server.succeed("curl -f http://localhost:9002")
        '';
      };
    };

  flake.nixosModules.nova-sdr = moduleWithSystem (
    perSystem@{ config, ... }:
    {
      config,
      lib,
      pkgs,
      ...
    }:
    with lib;
    let
      cfg = config.services.nova-sdr;
      format = pkgs.formats.toml { };

      mergedSettings = recursiveUpdate {
        server.html_root = "${perSystem.config.packages.nova-sdr_frontend}";
      } cfg.settings;

      configFile = format.generate "config.toml" mergedSettings;
    in
    {
      options.services.nova-sdr = {
        enable = mkEnableOption "NovaSDR WebSDR server";

        package = mkOption {
          type = types.package;
          default = perSystem.config.packages.nova-sdr;
          defaultText = literalExpression "pkgs.nova-sdr";
          description = "The NovaSDR package to use.";
        };

        settings = mkOption {
          type = format.type;
          default = { };
          description = ''
            Configuration for NovaSDR. See the README for available options:
            <https://github.com/Steven9101/NovaSDR>

            Note: The html_root is automatically set to the frontend directory
            in the package unless explicitly overridden.
          '';
          example = literalExpression ''
            {
              server = {
                port = 9002;
                host = "0.0.0.0";
                otherusers = 1;
                threads = 1;
              };
              
              websdr = {
                register_online = false;
                name = "My NovaSDR";
                antenna = "Dipole";
                grid_locator = "JO32pc";
                hostname = "";
                operator = "MyCallsign";
                email = "contact@example.com";
                callsign_lookup_url = "https://www.qrz.com/db/";
                chat_enabled = true;
              };
              
              limits = {
                audio = 100;
                waterfall = 200;
                events = 200;
              };
              
              input = {
                sps = 2048000;
                frequency = 100900000;
                signal = "real";
                fft_size = 131072;
                fft_threads = 1;
                brightness_offset = 0;
                audio_sps = 12000;
                waterfall_size = 1024;
                waterfall_compression = "zstd";
                audio_compression = "flac";
                accelerator = "none";
                smeter_offset = 0;
                
                driver = {
                  name = "stdin";
                  format = "u8";
                };
                
                defaults = {
                  frequency = 88300000;
                  modulation = "WBFM";
                };
              };
            }
          '';
        };

        user = mkOption {
          type = types.str;
          default = "nova-sdr";
          description = "User account under which NovaSDR runs.";
        };

        group = mkOption {
          type = types.str;
          default = "nova-sdr";
          description = "Group under which NovaSDR runs.";
        };
      };

      config = mkIf cfg.enable {
        users.users.${cfg.user} = {
          isSystemUser = true;
          group = cfg.group;
          description = "NovaSDR service user";
        };

        users.groups.${cfg.group} = { };

        systemd.services.nova-sdr = {
          description = "NovaSDR WebSDR Server";
          after = [ "network.target" ];

          # Only auto-start if configured
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            Type = "simple";
            User = cfg.user;
            Group = cfg.group;

            Restart = "on-failure";
            RestartSec = "10s";
            TimeoutStopSec = "5s";

            RuntimeDirectory = "nova-sdr";
            StateDirectory = "nova-sdr";
            WorkingDirectory = "/var/lib/nova-sdr";

            # Security hardening
            NoNewPrivileges = true;
            PrivateTmp = true;
            ProtectSystem = "strict";
            ProtectHome = true;
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectControlGroups = true;
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            LockPersonality = true;

            ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.rtl-sdr} -g 48 -f 100900000 -s 2048000 - |${cfg.package}/bin/nova-sdr --config ${configFile}'";

            KillMode = "mixed";
            KillSignal = "SIGTERM";
          };
        };
      };
    }
  );
}
