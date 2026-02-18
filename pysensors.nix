{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  lm_sensors,
}:

buildPythonPackage rec {
  pname = "PySensors";
  version = "0.0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "beb0def410d29ee46fe196a7811124772abf84cbe3a0d8b01d80b81fba31dae5";
  };

  # sensors/__init__.py resolves libsensors at import time with
  # ctypes.util.find_library, which consults an ldconfig cache that does not
  # exist here, so point it at the library directly. The SENSORS_LIB override
  # the module already honours is left in front of it.
  postPatch = ''
    substituteInPlace sensors/__init__.py \
      --replace-fail "find_library('sensors')" \
                     "'${lm_sensors.out}/lib/libsensors.so'"
  '';

  nativeBuildInputs = [ setuptools ];

  buildInputs = [ lm_sensors ];

  pythonImportsCheck = [ "sensors" ];

  meta = {
    homepage = "https://github.com/paroj/sensors.py";
    description = "Python ctypes bindings for libsensors (lm-sensors)";
    license = lib.licenses.lgpl21Plus;
    longDescription = ''
      The binding SONiC's sonic_platform uses: it exposes SENSORS_LIB,
      SensorsException and iter_detected_chips. nixpkgs' python3Packages
      .pysensors is a different project (bastienleonard/pysensors) that
      happens to share the "sensors" import name.
    '';
  };
}
