class CleanAllTheThings < Formula
  desc "SciVisum server temporary file cleanup tool"
  head "git@git:sysadmin", :using => :git

  stable do
    url "http://mac-repo.scivisum.co.uk/sources/clean-all-the-things/clean-all-the-things-1.0.302.tar.xz"
    sha256 "149e231726882dc3764c775257665d5185139609e280783d0d5ea2ed5cb112f3"
  end

  def install
    bin.install "scripts/cleanAllTheThings/bin/cleanAllTheThings"
  end
end
