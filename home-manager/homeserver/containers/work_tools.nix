{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  services.podman.containers = {
    vikunja = {
      image = "docker.io/vikunja/vikunja:latest";
      environment = {
        VIKUNJA_SERVICE_JWTSECRET = "<a super secure random secret>";
        VIKUNJA_SERVICE_PUBLICURL = "http://bulba.space/";
        # Note the default path is /app/vikunja/vikunja.db.
        # This config variable moves it to a different folder so you can use a volume and
        # store the database file outside the container so state is persisted even if the container is destroyed.
        VIKUNJA_DATABASE_PATH = "/db/vikunja.db";
      };
    };
  };
  # vikunja:
  #   image: vikunja/vikunja
  #   environment:
  #     VIKUNJA_SERVICE_JWTSECRET: <a super secure random secret>
  #     VIKUNJA_SERVICE_PUBLICURL: http://<your public frontend url with slash>/
  #     # Note the default path is /app/vikunja/vikunja.db.
  #     # This config variable moves it to a different folder so you can use a volume and
  #     # store the database file outside the container so state is persisted even if the container is destroyed.
  #     VIKUNJA_DATABASE_PATH: /db/vikunja.db
  #   ports:
  #     - 3456:3456
  #   volumes:
  #     - ./files:/app/vikunja/files
  #     - ./db:/db
  #   restart: unless-stopped
}
