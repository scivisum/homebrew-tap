class VncsnapshotPng < Formula
  desc "Utility for taking snapshots of a vnc server in PNG format"
  homepage "https://github.com/ScoreUnder/vncsnapshot-png"
  head "https://github.com/ScoreUnder/vncsnapshot-png.git"
  url "http://mac-repo.scivisum.co.uk/sources/vncsnapshot-png-1.3.tar.xz"
  sha256 "bad88eb750c9796a3685e7d29b3a6410556e93795defd760666c7dd11525aa72"

  depends_on "libpng"
  conflicts_with "vncsnapshot", :because => "this package also provides a vncsnapshot binary"

  def install
    system "make"
    bin.install "vncsnapshot"
    man1.mkpath
    system "install", "-m", "644", "vncsnapshot.man1", "#{man1}/vncsnapshot.1"
  end
end
