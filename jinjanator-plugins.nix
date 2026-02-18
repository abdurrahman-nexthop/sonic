{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  attrs,
  pluggy,
}:

buildPythonPackage rec {
  pname = "jinjanator_plugins";
  version = "25.1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "46fdc53dc375bd6f460b2095f3073579a7a7a115487418156e9611ca5c8a96a8";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'hatchling<1.27' 'hatchling'
  '';

  nativeBuildInputs = [
    hatchling
    hatch-fancy-pypi-readme
    hatch-vcs
  ];

  propagatedBuildInputs = [
    attrs
    pluggy
  ];

  meta = {
    homepage = "https://github.com/kpfleming/jinjanator-plugins";
    description = "API package for jinjanator plugins";
    longDescription = ''
      Package which provides the plugin API for the jinjanator tool.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      abuibrahim
    ];
  };
}
