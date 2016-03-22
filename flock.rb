require 'formula'

class Flock < Formula
  homepage 'https://github.com/discoteq/flock'
  version '0.2.3'
  url "http://mac-repo.scivisum.co.uk/sources/flock/flock-#{version}.tar.xz"
  sha256 '3233658199683c807c21b0ef0fc32246e420f2a6e48f7044d2ccb763ff320c70'

  bottle do
    root_url "http://mac-repo.scivisum.co.uk/binaries/flock"
    cellar :any_skip_relocation
    sha256 "e5d83dad3618e5f39bb88004f578b5ecdad9d926aac2a5f9b36e7d5bd9b3e07f" => :yosemite
    sha256 "343c50e795706dd117fe4767318bdc7b970fe835a634f2436c040195d64e5e0f" => :mavericks
  end

  def install
    system './configure', '--disable-debug',
                          '--disable-dependency-tracking',
                          '--disable-silent-rules',
                          "--prefix=#{prefix}"
    system 'make', 'install'
  end

  test do
    system "#{bin}/flock", 'tmpfile', 'true'
  end
end
