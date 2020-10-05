{ stdenv
, autoPatchelfHook
, dpkg
, fetchurl
, wrapQtAppsHook
, qtwebsockets
, qtvirtualkeyboard
, qtwebengine
, libthai
# , makeWrapper
}:

stdenv.mkDerivation rec {
  name = "insync";
  version = "3.2.8.40877";
  src = fetchurl {
    url = "https://d2t3ff60b2tol4.cloudfront.net/builds/insync_${version}-focal_amd64.deb";
    sha256 = "1964x01h9r7q5hwh81215lz5v9rqjiqzxj1xm0qvb3dwkd0qpbcd";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg wrapQtAppsHook ];
  buildInputs = [ qtwebsockets qtvirtualkeyboard qtwebengine libthai ];

  unpackPhase = "dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner";

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/share
    cp -R usr/* $out/
    rm $out/lib/insync/libGLX.so.0
    rm $out/lib/insync/libQt5*
    sed -i 's|/usr/lib/insync|/lib/insync|' "$out/bin/insync"
    wrapQtApp "$out/lib/insync/insync"
  '';

  postPatch = ''
    substituteInPlace usr/bin/insync --replace /usr/lib/insync $out/usr/lib/insync
  '';

  dontConfigure = true;
  dontBuild = true;

  meta = with stdenv.lib; {
    platforms = ["x86_64-linux"];
    license = stdenv.lib.licenses.unfree;
    maintainers = with maintainers; [  ];
    homepage = https://www.insynchq.com;
    description = "Google Drive sync and backup with multiple account support";
    longDescription = ''
     Insync is a commercial application that syncs your Drive files to your
     computer.  It has more advanced features than Google's official client
     such as multiple account support, Google Doc conversion, symlink support,
     and built in sharing.

     There is a 15-day free trial, and it is a paid application after that.
    '';
  };
}
