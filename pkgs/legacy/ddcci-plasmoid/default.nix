# stolen from an unforunately not merged PR
# https://github.com/NixOS/nixpkgs/pull/283006
{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  # use this package instead of the one in python3Packages
  # because, well, that one isn't there
  ddcci-plasmoid-backend,
}:
stdenvNoCC.mkDerivation rec {
  pname = "ddcci-plasmoid";
  version = "0.1.10-kf6";

  src = fetchFromGitHub {
    owner = "davidhi7";
    repo = "ddcci-plasmoid";
    rev = "refs/tags/v${version}";
    hash = "sha256-/UTIflcUyPHMQ2CQG0d2R0MaKuXYmlvnYnLNQ+nMWvw=";
  };

  postPatch = ''
    substituteInPlace plasmoid/contents/config/main.xml \
      --replace "<default>python3 -m ddcci_plasmoid_backend</default>" \
                "<default>${ddcci-plasmoid-backend}/bin/ddcci_plasmoid_backend</default>"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plasma/plasmoids/de.davidhi.ddcci-brightness
    cp -r ./plasmoid/* $out/share/plasma/plasmoids/de.davidhi.ddcci-brightness/

    runHook postInstall
  '';

  meta = with lib; {
    description = "KDE Plasma Widget for external monitor brightness adjustment using ddcutil";
    homepage = "https://github.com/davidhi7/ddcci-plasmoid";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sund3RRR ];
  };
}
