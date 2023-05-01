class FilebeatAT68 < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  # Hacked filebeat repo to remove x-pack (not open source licensed) and fix some build issues
  url "https://mac-repo.scivisum.co.uk/sources/filebeat/filebeat-noxpack-6.8.23.tar.zst"
  sha256 "a7adf48d66cb9d3d3cfec066dd9a648f3526ce6920a228c17addce1e326b5e31"
  revision 1

  depends_on "go" => :build
  depends_on "python@3.10" => :build
  depends_on "mage" => :build
  depends_on "virtualenv" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "off"
    (buildpath/"src/github.com/elastic/beats").install Dir["{*,.git,.gitignore}"]

    cd "src/github.com/elastic/beats/filebeat" do
      system "make"
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_COMMANDS=--no-binary :all", "python-env"
      system "make", "DEV_OS=darwin", "update"

      (etc/"filebeat").install Dir["filebeat.*", "fields.yml", "modules.d"]
      (etc/"filebeat"/"module").install Dir["_meta/module.generated/*"]
      (libexec/"bin").install "filebeat"
      prefix.install "_meta/kibana"
    end

    prefix.install_metafiles buildpath/"src/github.com/elastic/beats"

    (bin/"filebeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/filebeat \
        --path.config #{etc}/filebeat \
        --path.data #{var}/lib/filebeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/filebeat \
        "$@"
    EOS
  end

  service do
    run opt_bin/"filebeat"
    require_root true
  end
end
