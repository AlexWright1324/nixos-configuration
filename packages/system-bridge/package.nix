{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
}:
let
  pname = "system-bridge";
  version = "5.1.2";
  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge";
    rev = "${version}";
    sha256 = "sha256-YFwOdoiLTh6XDBMgUjtEcLwSajJaE/nZn90mE1zvYYU=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  postPatch = ''
    # Remove 'bun install' from line 41 of Makefile
    substituteInPlace Makefile \
      --replace-fail 'cd web-client && bun install && $(BUN_BUILD) && bun run verify-build' \
                     'cd web-client && bun install --force --frozen-lockfile --no-progress && $(BUN_BUILD) && bun run verify-build'
  '';

  nativeBuildInputs = [
    bun
  ];

  buildInputs = [ ];

  buildPhase = ''
    runHook preBuild

    make build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    cp -r ./system-bridge $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    description = "A bridge for your systems.";
    homepage = "https://github.com/timmo001/system-bridge";
    license = licenses.asl20;
    maintainers = with maintainers; [
      AlexWright1324
      timmo001
    ];
    platforms = platforms.all;
  };

  outputHash = "";
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
}
