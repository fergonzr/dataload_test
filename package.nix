{
  python314Packages,
}:
python314Packages.buildPythonApplication {
  pname = "dataload_test";
  version = "0.1.0";
  src = ./src;
  pyproject = true;
  build-system = [ python314Packages.setuptools ];

  propagatedBuildInputs = with python314Packages; [
    sqlmodel
    fastapi
    uvicorn
    pymysql
  ];
  postInstall = ''
    cp $out/bin/run.py $out/bin/dataload_test
  '';
}
