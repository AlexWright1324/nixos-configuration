{
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "pyvelop";
  version = "2025.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hEvAVh07cnBNVZ3QF0xKHBQGluDFl8XjOJ7SkQzmIRw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "pyvelop" ];
}
