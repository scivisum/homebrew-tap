class CleanAllTheThings < Formula
  desc "SciVisum server temporary file cleanup tool"
  head "git@git:sysadmin", :using => :git
  url "http://mac-repo.scivisum.co.uk/sources/clean-all-the-things/clean-all-the-things-1.0.311.tar.xz"
  sha256 "4d19308353b51b6dc49d5bde5fb0df1e229d31d5a53025bae08a50d181f5d2b5"

  def install
    bin.install "scripts/cleanAllTheThings/bin/cleanAllTheThings"
  end
end
