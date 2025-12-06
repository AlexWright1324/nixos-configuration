{
  fetchFromGitHub,
  buildHomeAssistantComponent,
  pyvelop,
}:
buildHomeAssistantComponent rec {
  owner = "uvjim";
  domain = "linksys_velop";
  version = "2025.5.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    rev = version;
    sha256 = "sha256-cW6qO/XnZQJhYT3Ds1ZcK6ApSepPXnV8jof+sXPyP0s=";
  };

  dependencies = [
    pyvelop
  ];
}
