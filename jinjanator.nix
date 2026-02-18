{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  attrs,
  jinja2,
  jinjanator-plugins,
  python-dotenv,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "jinjanator";
  version = "25.3.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cdf48a654748b79a6fea8789e520a97343b665bb74ca4179cead88ab4cd1c5a7";
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
    jinja2
    python-dotenv
    pyyaml
    jinjanator-plugins
  ];

  meta = {
    homepage = "https://github.com/kpfleming/jinjanator";
    description = "Jinja2 Command-Line Tool";
    mainProgram = "j2";
    license = lib.licenses.asl20;
    longDescription = ''
      J2Cli is a command-line tool for templating in shell-scripts,
      leveraging the Jinja2 library.
    '';
    maintainers = with lib.maintainers; [
      abuibrahim
    ];
  };
}
