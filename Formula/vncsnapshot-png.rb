class VncsnapshotPng < Formula
  desc "Utility for taking snapshots of a vnc server in PNG format"
  homepage "https://github.com/ScoreUnder/vncsnapshot-png"
  head "https://github.com/ScoreUnder/vncsnapshot-png.git"
  url "http://mac-repo.scivisum.co.uk/sources/vncsnapshot-png/vncsnapshot-png-1.3.tar.xz"
  sha256 "bad88eb750c9796a3685e7d29b3a6410556e93795defd760666c7dd11525aa72"

  depends_on "libpng"
  conflicts_with "vncsnapshot", :because => "this package also provides a vncsnapshot binary"

  bottle do
    root_url "http://mac-repo.scivisum.co.uk/binaries/vncsnapshot-png"
    cellar :any
    rebuild 1
    sha256 "66ca9b83972743d89af4b80a80af333bf83b503c102ff0f492f1dd4787d632a1" => :yosemite
    sha256 "27ae46cd3dc6577280e181582ea938067c2945615ee96785c0af5f375c38b4cc" => :mavericks
  end

  def install
    system "make"
    bin.install "vncsnapshot"
    man1.mkpath
    system "install", "-m", "644", "vncsnapshot.man1", "#{man1}/vncsnapshot.1"
  end
end
