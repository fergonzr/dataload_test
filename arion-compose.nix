{ pkgs, ... }:
let
  package = pkgs.callPackage ./package.nix { };
in
{
  project.name = "dataload_test";
  services = {
    api = {
      image.name = "dataload_test_api";
      image.enableRecommendedContents = true;
      service.useHostStore = true;
      service.command = [
        "${package}/bin/dataload_test"
      ];
      service.ports = [
        "8000:8000"
      ];
      service.environment = {
        DB_DRIVER = "sqlite";
        DB_PASS = "secretpassword";
        DB_USER = "root";
        DB_NAME = "dataload_test";
        DB_PORT = "3306";
        DB_HOST = "database";
      };
      service.depends_on = {
        database = {
          condition = "service_healthy";
        };
      };
      service.networks = [ "dataload_api" ];
    };
    database = {
      service.name = "database";
      service.image = "mariadb:12.3.3-ubi";
      service.ports = [ "3306:3306" ];
      service.expose = [ "3306" ];
      service.environment = {
        MARIADB_ROOT_PASSWORD = "secretpassword";
        MARIADB_USER = "dataload_test";
        MARIADB_DATABASE = "dataload_test";
        TZ = "America/Bogota";
      };
      service.networks = [ "dataload_api" ];
      service.volumes = [
        "dataload_db:/var/lib/mysql:Z"
      ];
      service.healthcheck = {
        test = [
          "CMD"
          "healthcheck.sh"
          "--connect"
          "--innodb_initialized"
        ];
        interval = "10s";
        retries = 3;
        timeout = "5s";
        start_period = "10s";
      };
    };
  };
  networks.dataload_api = { };
  docker-compose.volumes = {
    dataload_db = { };
  };
}
