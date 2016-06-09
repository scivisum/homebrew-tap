class Mtr < Formula
  desc "'traceroute' and 'ping' in a single tool"
  homepage "https://www.bitwizard.nl/mtr/"
  head "https://github.com/traviscross/mtr.git"

  stable do
    url "http://mac-repo.scivisum.co.uk/sources/mtr/v0.86.tar.xz"
    sha256 "28c2824fbfc1fcc070f343171bbbc76d23efb894ec089215cd2fc8d5a632f4ee"

    # Fix an issue where default shell colors were overridden by mtr.
    # https://github.com/Homebrew/homebrew/issues/43862
    patch do
      url "http://mac-repo.scivisum.co.uk/sources/mtr/63a1f1493bfbaf7e55eb7e20b3791fc8b14cf92d.patch"
      sha256 "67d682b29fca49d703f48bb2844e1c0e4b4635d0645d139a13352d9575336194"
    end
  end

  bottle do
    root_url "http://mac-repo.scivisum.co.uk/binaries/mtr"
    cellar :any_skip_relocation
    revision 2
    sha256 "ad6094cbb959df4de5e327d61f9b629112514eb03e0789938852e1c5b46b8da9" => :yosemite
    sha256 "60ef2b8456e306db3017fa69f0e85e8885284092e442d06bc80b65dbf1a0f44c" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+" => :optional
  depends_on "glib" => :optional

  def install
    # We need to add this because nameserver8_compat.h has been removed in Snow Leopard
    ENV["LIBS"] = "-lresolv"
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--without-gtk" if build.without? "gtk+"
    args << "--without-glib" if build.without? "glib"
    system "./bootstrap.sh"
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    mtr requires root privileges so you will need to run `sudo mtr`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end
end
