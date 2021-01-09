{ lib, appimageTools, fetchurl, makeDesktopItem }:
let
  pname = "ytmdesktop";
  version = "1.13.0";
  name = "${pname}-${version}";

  src = builtins.fetchurl {
    url = "https://github.com/ytmdesktop/ytmdesktop/releases/download/v${version}/YouTube-Music-Desktop-App-${version}.AppImage";
    sha256 = "0f5l7hra3m3q9zd0ngc9dj4mh1lk0rgicvh9idpd27wr808vy28v";
    name="${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in appimageTools.wrapType2 {
  inherit name src;

  multiPkgs = null;
  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/youtube-music-desktop-app.desktop \
      $out/share/applications/youtube-music-desktop-app.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/0x0/apps/youtube-music-desktop-app.png \
      $out/share/icons/hicolor/0x0/apps/youtube-music-desktop-app.png
    substituteInPlace $out/share/applications/youtube-music-desktop-app.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Desktop Youtube Music Player App";
    homepage = https://github.com/ytmdesktop/ytmdesktop;
    license = licenses.cc0;
    platforms = [ "x86_64-linux" ];
  };
}
