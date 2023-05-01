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

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d6/37/3ff25b2ad0d51cfd752dc68ee0ad4387f058a5ceba4d89b47ac478de3f59/virtualenv-20.23.0.tar.gz"
    sha256 "a85caa554ced0c0afbd0d638e7e2d7b5f92d23478d05d17a76daeac8f279f924"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "off"
    (buildpath/"src/github.com/elastic/beats").install Dir["{*,.git,.gitignore}"]

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python#{xy}/site-packages"

    resource("virtualenv").stage do
      system "python3", *Language::Python.setup_install_args(buildpath/"vendor")
    end

    ENV.prepend_path "PATH", buildpath/"vendor/bin"

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

  plist_options :manual => "filebeat"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>Program</key>
          <string>#{opt_bin}/filebeat</string>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end
end
