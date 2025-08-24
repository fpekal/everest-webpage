{
  inputs = { nixpkgs.url = "github:nixos/nixpkgs"; };

  outputs = { nixpkgs, self }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      lib = {
        buildNodePackage = { name, version, src, nodeModulesHash }@args:
          let
            nodeModules = pkgs.stdenv.mkDerivation {
              name = "node-modules";

              outputHash = nodeModulesHash;
              outputHashMode = "recursive";

              buildInputs = [ pkgs.nodejs ];
              nativeBuildInputs = [ pkgs.nodejs ];

              builder = pkgs.writeText "node-modules" ''
                export NODE_EXTRA_CA_CERTS=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
                export HOME=$(mktemp -d)
                cp -r ${src}/* .

                npm ci --logs-max=0

                cp -r node_modules $out
              '';
            };
          in pkgs.stdenv.mkDerivation {
            inherit name version src;

            HOME = "$(mktemp -d)";
            buildInputs = [ pkgs.nodejs ];
            nativeBuildInputs = [ pkgs.nodejs ];

            patchPhase =
              "cp -r ${nodeModules} node_modules; chmod +w node_modules; patchShebangs .";
            buildPhase = "ls -la; npm run build";
            installPhase = "cp -r dist $out";
          };
      };

      packages.${system} = {
        webpage = self.lib.buildNodePackage {
          name = "webpage";
          version = "1.0.0";

          src = ./.;

          nodeModulesHash =
            "sha256-5crFYd5gwk03bFnYLMeY7UT/JcT0tIXD+6ziBQkgP0Q=";
        };

        default = self.packages.${system}.webpage;
      };
    };
}
