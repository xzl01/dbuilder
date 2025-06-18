-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.0
Source: wayland
Binary: libwayland-client0, libwayland-egl1, libwayland-server0, libwayland-cursor0, libwayland-dev, libwayland-egl-backend-dev, libwayland-doc, libwayland-bin
Architecture: any all
Version: 1.23.1-3
Maintainer: Debian X Strike Force <debian-x@lists.debian.org>
Uploaders: Emilio Pozuelo Monfort <pochu@debian.org>, Héctor Orón Martínez <zumbi@debian.org>, Marius Gripsgard <mariogrip@debian.org>, Dylan Aïssi <daissi@debian.org>
Homepage: https://wayland.freedesktop.org/
Standards-Version: 4.7.0
Vcs-Browser: https://salsa.debian.org/xorg-team/wayland/wayland
Vcs-Git: https://salsa.debian.org/xorg-team/wayland/wayland.git
Build-Depends: debhelper-compat (= 13), quilt, pkgconf, libexpat1-dev, libffi-dev, libxml2-dev, libwayland-bin <cross>, meson
Build-Depends-Indep: doxygen, graphviz, xmlto, xsltproc, docbook-xsl
Package-List:
 libwayland-bin deb libdevel optional arch=any
 libwayland-client0 deb libs optional arch=any
 libwayland-cursor0 deb libs optional arch=any
 libwayland-dev deb libdevel optional arch=any
 libwayland-doc deb doc optional arch=all
 libwayland-egl-backend-dev deb libdevel optional arch=any
 libwayland-egl1 deb libs optional arch=any
 libwayland-server0 deb libs optional arch=any
Checksums-Sha1:
 56a55eb419f3ecf8a7ebdc726db43d2d734e5632 370199 wayland_1.23.1.orig.tar.gz
 c43221b9d7f88cfd072a84c2c54252b6149d711b 16437 wayland_1.23.1-3.diff.gz
Checksums-Sha256:
 158ec49af498f2558c7fbf7e8b070d010d4e270cc6076003a18a6c813f87e244 370199 wayland_1.23.1.orig.tar.gz
 f48a224e6d744d33ab00378b7a7f2b3ab6461706e30b722e320d047d880e70c8 16437 wayland_1.23.1-3.diff.gz
Files:
 8f703ce7e26d4ab990e807721d3e9f3f 370199 wayland_1.23.1.orig.tar.gz
 887a8b3d4c34a283957a091664104545 16437 wayland_1.23.1-3.diff.gz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEmjwHvQbeL0FugTpdYS7xYT4FD1QFAme2RAkACgkQYS7xYT4F
D1SbCA/9E4dESdWbP+HTGh/UvD0nAFeZWTBYz9VJjg6k39c3mTTMkxphYSkOhbxh
mm6PsgwGUIpXJ7un8Re26xdt6TZIsT3uHIr58bgBaCNa0enEeDBbykzHC0C5EHi9
9L3uu8qVaS6pjZwGAJlVrAI/47Syh9VPDHTrwjrps1PqdWtyNlUMaU7CrLRLQPr/
dArFOtKxCNVbf0LWSNxh/FwHDGSf8MlKqRvni91csO7+PU/m2clzXCNeUnzBH6HW
Ac1Ohj917JuRBCXvkDX6lB3MWRdl/DF9I7fUbfEu7y5CA1tj9+IWl9EMMdsqEeLI
xcHWuuGtrdPeVbtaFr1QocY7Tsq+zXVoqUl5larp18WjMkKi1WW8a85EryTbNlfb
oa9nA5axJJzVqtfR1OoeouyCGeXlczudmN3rKmetAxrXw55Bwy5txpurY+0XuHj1
QczYRPk72s3gpKBo9MI1yH3zWWyzxsyad2xp/3HHxkeipiKTfaFOvTXHlzMYwAEu
vF+ovxvxnqMVrkL0CnJsp4Kqxwd3+2ykjxz99Wx/u+ny2TPJns4nI+1Ff1K/Ox+d
t5fLNfMzDcQ8Vj1vGzWyY883/kGCOyOVoM199CcvrX7Hq05a+b94vlselNqtMsjF
O6wexZ0uzuyi4xmZNQK9yXDYOqbZYNhVkK5bR8rXpo7Qbvzp8Eo=
=tKgG
-----END PGP SIGNATURE-----
