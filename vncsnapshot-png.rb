class VncsnapshotPng < Formula
  desc "Utility for taking snapshots of a vnc server in PNG format"
  homepage "https://github.com/ScoreUnder/vncsnapshot-png"
  head "https://github.com/ScoreUnder/vncsnapshot-png.git"

  depends_on "libpng"
  conflicts_with "vncsnapshot", :because => "this package also provides a vncsnapshot binary"

  def install
    system "make"
    bin.install "vncsnapshot"
    man1.mkpath
    system "install", "-m", "644", "vncsnapshot.man1", "#{man1}/vncsnapshot.1"
  end
end
