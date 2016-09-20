class Tsproxy < Formula
    desc "Traffic shaping proxy"
    head "https://github.com/WPO-Foundation/tsproxy.git", :using => :git

    def install
        bin.install "tsproxy.py"
    end
end
