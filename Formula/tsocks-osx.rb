class TsocksOsx < Formula
    desc "Socks proxy wrapper"
    version "1.8"

    head do
        url "https://github.com/openroc/tsocks-macosx.git", :using => :git
        depends_on "autoconf" => :build
    end

    def install
        system "autoconf"
        system "./configure"
        system "make"

        bin.install "tsocks"
        lib.install "libtsocks.dylib.1.8"
        ln_s lib/"libtsocks.dylib.1.8", lib/"libtsocks.dylib"
        etc.install "tsocks.conf.simple.example"
    end
end
