{
  pkgs,
  lib,
  rocmSupport ? false,
  html_root,
  ...
}:
pkgs.stdenv.mkDerivation {
  name = "nova-sdr";

  src = pkgs.fetchFromGitHub {
    owner = "Steven9101";
    repo = "NovaSDR";
    rev = "09de1432b20703444c6d1ee09239efd77f814031";
    sha256 = "sha256-qn2GWS+sPw0SlALJaX9ctU3Qpzrcm0TB7KII1T4etXk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = with pkgs; [
    meson
    cmake
    ninja
    pkg-config
  ];

  buildInputs =
    with pkgs;
    [
      fftwFloat
      boost186 # Earlier version due to websocketpp compatibility
      glaze
      zstd
      flac
      zlib
      tomlplusplus
      curl
      liquid-dsp
      nlohmann_json
      websocketpp
    ]
    ++ lib.optional rocmSupport (with pkgs; [ rocmPackages.clr ]);

  postPatch = ''
    # Replace subproject usage with system dependency for websocketpp
    substituteInPlace meson.build \
      --replace-fail "websocketpp_dep = subproject('websocketpp').get_variable('websocketpp_dep')" \
                "websocketpp_dep = dependency('websocketpp')"

    # Fix missing cstdlib include in fft.h
    substituteInPlace src/fft.h \
      --replace-fail '#include <fftw3.h>' $'#include <fftw3.h>\n#include <cstdlib>'

    # Fix glz::write_json() returns std::expected in newer glaze versions
    # Fix events.cpp
    substituteInPlace src/events.cpp \
      --replace-fail 'return glz::write_json(info);' 'auto result = glz::write_json(info); return result.value_or("");'

    # Fix websocket.cpp
    substituteInPlace src/websocket.cpp \
      --replace-fail 'm_server.send(hdl, glz::write_json(json), websocketpp::frame::opcode::text);' \
                'auto json_str = glz::write_json(json); if (json_str) m_server.send(hdl, json_str.value(), websocketpp::frame::opcode::text);'

    # Fix spectrumserver.cpp
    substituteInPlace src/spectrumserver.cpp \
      --replace-fail 'std::string serialized_json = glz::write_json(json_data);' \
                'auto json_result = glz::write_json(json_data); std::string serialized_json = json_result.value_or("");' \
      --replace-fail 'm_docroot = config["server"]["html_root"].value_or("html/");' \
                'm_docroot = "${html_root}";'
  '';

  buildPhase = ''
    meson compile
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp spectrumserver $out/bin/nova-sdr
  '';

  meta = with lib; {
    description = "A modern, web-enabled SDR server with a fast Svelte frontend";
    homepage = "https://github.com/Steven9101/NovaSDR";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
