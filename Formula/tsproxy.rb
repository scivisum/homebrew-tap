class Tsproxy < Formula
    desc "Traffic shaping proxy"
    url "https://mac-repo.scivisum.co.uk/sources/tsproxy/tsproxy-0.0.26.tar.xz"
    sha256 "2c5e05e5bb03ee75b2859c284afa33c755336f15cc307179744b105b45a8fa68"
    head "https://github.com/WPO-Foundation/tsproxy.git", :using => :git

    def install
        bin.install "tsproxy.py"
    end
end
