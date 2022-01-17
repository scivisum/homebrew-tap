class ZabbixAgentd < Formula
    desc "zabbix agentd for osx"
    homepage "https://www.zabbix.org/"
    url "http://mac-repo.scivisum.co.uk/sources/zabbix_agentd/zabbix-3.4.7.tar.gz"
    sha256 "ae0f5c7da3886aa3184a1c39ba455e801cdc4356ba16bf68339aee0947366289"

    depends_on "libiconv"

    def install
        system "./configure", "--enable-agent", "--prefix=/usr/local/Cellar/zabbix_agentd"
        system "make"
        sbin.install "src/zabbix_agent/zabbix_agentd"
    end
end
