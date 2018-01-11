with import <nixpkgs>{};

rec {
  dbb = stdenv.mkDerivation rec {
    name = "gdb-play-001.env";
    src = ./.;
    version = "0.1.0";

    buildInputs = [
    ] ++ gccPkgs ++ utilPkgs;

    gccPkgs = [
      autoconf
      automake
      gcc49
      gdb
    ];

    utilPkgs = [
      file
      git
      less
      strace
      which
    ];

    hardeningDisable = [
      #"all"
      "format"
    ];

    fhsEnv = buildFHSUserEnv {
      inherit name;
    };

    introText = ''
      Source:
        - Title: Give me 15 minutes and I'll change your view of GDB
          Author: Greg Law
          URL: https://youtu.be/PorfLSr3DDI
    '';

    shellHook = ''
      export PS1="\e[1;33m$ \e[0m";
      echo "$introText"
      echo ""
      echo "Run \`fhs\` to drop into FHS env from which the install/bin/dbb-app should be executable"
      alias fhs="${fhsEnv}/bin/${name}"
    '';
  };
}
