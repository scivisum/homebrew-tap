class CleanAllTheThings < Formula
  desc "SciVisum server temporary file cleanup tool"
  head "git@git:sysadmin", :using => :git
  url "http://mac-repo.scivisum.co.uk/sources/clean-all-the-things/clean-all-the-things-1.0.331.tar.xz"
  sha256 "a64ca7a2ab8e3d18f5dc2ee44d223117127137078fc4a6a3e7f758c937f3194f"

  def install
    bin.install "scripts/cleanAllTheThings/bin/cleanAllTheThings"
  end
end
