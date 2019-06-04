class Collectd < Formula
  desc "Statistics collection and monitoring daemon"
  homepage "https://collectd.org/"

  stable do
    url "https://collectd.org/files/collectd-5.6.0.tar.bz2"
    mirror "http://pkgs.fedoraproject.org/repo/pkgs/collectd/collectd-5.5.2.tar.bz2/40b83343f72089e0330f53965f1140bd/collectd-5.5.2.tar.bz2"
    sha256 "f0ffbbd91fac3682bd324a74b9b4c9eabe781394b303b5cfd457c4cfbe748623"
  end

  bottle do
    root_url "https://mac-repo.scivisum.co.uk/binaries/collectd"
    cellar :any
    rebuild 1
    sha256 "500eb1d9ad2851796f792df5aa77723b51cc2f6afdd1f2878e21c5af01c0c1a7" => :yosemite
  end

  head do
    url "https://github.com/collectd/collectd.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  option "with-java", "Enable Java support"
  option "with-protobuf-c", "Enable write_riemann via protobuf-c support"
  option "with-debug", "Enable debug support"

  deprecated_option "java" => "with-java"
  deprecated_option "debug" => "with-debug"

  depends_on "pkg-config" => :build
  depends_on "protobuf-c" => :optional
  depends_on :java => :optional
  depends_on "net-snmp"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
    ]

    args << "--disable-embedded-perl" if MacOS.version <= :leopard
    args << "--disable-java" if build.without? "java"
    args << "--enable-write_riemann" if build.with? "protobuf-c"
    args << "--enable-debug" if build.with? "debug"

    system "./build.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/sbin/collectd -f -C #{HOMEBREW_PREFIX}/etc/collectd.conf"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/collectd</string>
          <string>-f</string>
          <string>-C</string>
          <string>#{etc}/collectd.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/collectd.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/collectd.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    begin
      pid = fork { exec sbin/"collectd", "-f" }
      assert shell_output("nc -u -w 2 127.0.0.1 25826", 0)
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
