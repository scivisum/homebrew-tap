class ZabbixAgentd < Formula
    desc "zabbix agentd for osx"
    homepage "https://www.zabbix.org/"
    url "http://mac-repo.scivisum.co.uk/sources/zabbix_agentd/zabbix-3.4.7.tar.gz"
    sha256 "ae0f5c7da3886aa3184a1c39ba455e801cdc4356ba16bf68339aee0947366289"
    revision 1

    depends_on "libiconv"
    depends_on "pcre"

    def install
        iconv_prefix = Formula["libiconv"].opt_prefix
        pcre_prefix = Formula["pcre"].opt_prefix
        system *%W(./configure --enable-agent --prefix=#{prefix} --with-iconv=#{iconv_prefix} --with-pcre=#{pcre_prefix})
        system "make"
        sbin.install "src/zabbix_agent/zabbix_agentd"
    end
end
