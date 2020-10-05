{ stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, wrapQtAppsHook
, pcsclite
, pkcs11helper
, qtbase
}:

let
  version = "3.1.0";
  debpkg = fetchurl {
    url = "https://www.eid.hr/sites/default/files/eidmiddleware_v${version}_amd64.deb";
    sha256 = "e92a3d9870b8d82831f89b6a70be7c16551ec2130168dc61f4f579997a3d02c3";
  };
in
stdenv.mkDerivation {
  pname = "eid";
  inherit version;

  nativeBuildInputs = [ autoPatchelfHook dpkg wrapQtAppsHook ];
  buildInputs = [ pcsclite ];

  dontConfigure = true;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    dpkg-deb -x ${debpkg} $out

    rm -rf $out/usr/lib/akd/eidmiddleware/lib/libQt5*
    rm -rf $out/usr/lib/akd/eidmiddleware/plugins
    ln -s -t $out/usr/lib/akd/eidmiddleware ${qtbase}/${qtbase.qtPluginPrefix}

    # rm -rf $out/usr/lib/akd/eidmiddleware/qt.conf
    # mkdir $out/usr/lib/akd/eidmiddleware/lib
    # ln -sf ${pkcs11helper} $out/usr/lib/akd/eidmiddleware/lib/a

  '';

  postFixup = ''
    wrapQtApp $out/usr/lib/akd/eidmiddleware/Client
    wrapQtApp $out/usr/lib/akd/eidmiddleware/Signer
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.eid.hr/";
    description = "";
    # license = licenses.unfree;
    platforms = platforms.linux;
    downloadPage = "https://www.eid.hr/hr/eoi/clanak/programski-paket-eid-middleware";
  };
}
