{
  cell,
  inputs,
}: {
  bee = rec {
    pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        permittedInsecurePackages = ["openssl-1.1.1w"];
      };
    };
    system = "x86_64-linux";
  };
}
