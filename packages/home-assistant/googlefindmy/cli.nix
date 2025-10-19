{
  fetchFromGitHub,
  home-assistant,
  writeScriptBin,
  runCommand,
  writeShellScript,
  glib,
  nspr,
  nss,
  xorg,
}:
let
  src = fetchFromGitHub {
    owner = "leonboe1";
    repo = "GoogleFindMyTools";
    rev = "867214fe145587665dc8d8f6c5f94376da5acdf6";
    hash = "sha256-NZQZSgN5Vrv03PiFHJqLj8F6lrJ+m/kXJd9vu5k1cbA=";
  };

  flatpakChromiumWrapper = writeShellScript "flatpak-chromium-wrapper" ''
    flatpak run --file-forwarding io.github.ungoogled_software.ungoogled_chromium "$@"
  '';

  # Patch the source to use current directory instead of script directory
  patchedSrc = runCommand "googlefindmy-patched" { } ''
    cp -r ${src} $out
    chmod -R +w $out

    # Patch token_cache.py to use current directory
    substituteInPlace $out/Auth/token_cache.py \
      --replace-fail 'script_dir = os.path.dirname(os.path.abspath(__file__))' \
                     'script_dir = os.getcwd()'

    # Patch chrome_driver.py to support Flatpak Chromium via wrapper
    substituteInPlace $out/chrome_driver.py \
      --replace-fail '"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"' \
                     '"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
        "${flatpakChromiumWrapper}"'
  '';

  py = home-assistant.python.withPackages (
    ps: with ps; [
      beautifulsoup4
      httpx
      h2
      requests
      gpsoauth
      protobuf
      selenium
      undetected-chromedriver
      pyscrypt
      cryptography
      aiohttp
      pytz
      http-ece
      ecdsa
      pycryptodome
    ]
  );
in
writeScriptBin "googlefindmytools" ''
  #!/usr/bin/env bash
  export LD_LIBRARY_PATH="${glib.out}/lib:${nspr}/lib:${nss}/lib:${xorg.libxcb}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  exec ${py.interpreter} -c '
  import sys
  sys.path.insert(0, "${patchedSrc}")
  exec(open("${patchedSrc}/main.py").read())
  ' "$@"
''
