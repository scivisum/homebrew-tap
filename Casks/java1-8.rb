cask 'java1-8' do
  version '1.8.0_92-b14'
  sha256 '626c2d9478d07318e9e6b2c38707f73aeafc0f7a9ede575062749346a7d347ca'

  url "https://mac-repo.scivisum.co.uk/binaries/oracle-jdk/jdk-#{version.sub(%r{^\d+\.(\d+).*?_(\d+)-.*$}, '\1u\2')}-macosx-x64.dmg"
  name 'Java Standard Edition Development Kit'
  homepage "http://www.oracle.com/technetwork/java/javase/downloads/jdk#{version.split('.')[1]}-downloads-2133151.html"
  license :gratis

  pkg "JDK #{version.split('.')[1]} Update #{version.sub(%r{^.*?_(\d+)-.*$}, '\1')}.pkg"

  postflight do
    system '/usr/bin/sudo', '-E', '--',
           '/usr/libexec/PlistBuddy', '-c', 'Add :JavaVM:JVMCapabilities: string BundledApp', "/Library/Java/JavaVirtualMachines/jdk#{version.split('-')[0]}.jdk/Contents/Info.plist"
    system '/usr/bin/sudo', '-E', '--',
           '/usr/libexec/PlistBuddy', '-c', 'Add :JavaVM:JVMCapabilities: string JNI',        "/Library/Java/JavaVirtualMachines/jdk#{version.split('-')[0]}.jdk/Contents/Info.plist"
    system '/usr/bin/sudo', '-E', '--',
           '/usr/libexec/PlistBuddy', '-c', 'Add :JavaVM:JVMCapabilities: string WebStart',   "/Library/Java/JavaVirtualMachines/jdk#{version.split('-')[0]}.jdk/Contents/Info.plist"
    system '/usr/bin/sudo', '-E', '--',
           '/usr/libexec/PlistBuddy', '-c', 'Add :JavaVM:JVMCapabilities: string Applets',    "/Library/Java/JavaVirtualMachines/jdk#{version.split('-')[0]}.jdk/Contents/Info.plist"
    system '/usr/bin/sudo', '-E', '--',
           '/bin/ln', '-nsf', '--', "/Library/Java/JavaVirtualMachines/jdk#{version.split('-')[0]}.jdk/Contents/Home", '/Library/Java/Home'
    system '/usr/bin/sudo', '-E', '--',
           '/bin/mkdir', '-p', '--', "/Library/Java/JavaVirtualMachines/jdk#{version.split('-')[0]}.jdk/Contents/Home/bundle/Libraries"
    system '/usr/bin/sudo', '-E', '--',
           '/bin/ln', '-nsf', '--', "/Library/Java/JavaVirtualMachines/jdk#{version.split('-')[0]}.jdk/Contents/Home/jre/lib/server/libjvm.dylib", "/Library/Java/JavaVirtualMachines/jdk#{version.split('-')[0]}.jdk/Contents/Home/bundle/Libraries/libserver.dylib"
    if MacOS.version <= :mavericks
      system '/usr/bin/sudo', '-E', '--',
             '/bin/rm', '-rf', '--', '/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK'
      system '/usr/bin/sudo', '-E', '--',
             '/bin/ln', '-nsf', '--', "/Library/Java/JavaVirtualMachines/jdk#{version.split('-')[0]}.jdk/Contents", '/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK'
    end
  end

  uninstall pkgutil:   [
                         "com.oracle.jdk#{version.sub(%r{^\d+\.(\d+).*?_(\d+)-.*$}, '\1u\2')}",
                         'com.oracle.jre',
                       ],
            launchctl: [
                         'com.oracle.java.Helper-Tool',
                         'com.oracle.java.Java-Updater',
                       ],
            quit:      [
                         'com.oracle.java.Java-Updater',
                         'net.java.openjdk.cmd', # Java Control Panel
                       ],
            delete:    [
                         '/Library/Internet Plug-Ins/JavaAppletPlugin.plugin',
                         "/Library/Java/JavaVirtualMachines/jdk#{version.split('-')[0]}.jdk/Contents",
                         '/Library/PreferencePanes/JavaControlPanel.prefPane',
                         '/Library/Java/Home',
                         if MacOS.version <= :mavericks
                           [
                             '/usr/lib/java/libjdns_sd.jnilib',
                             '/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK',
                           ]
                         end,
                       ].keep_if { |v| !v.nil? }

  zap       delete: [
                      '~/Library/Application Support/Oracle/Java',
                      '~/Library/Caches/com.oracle.java.Java-Updater',
                      '~/Library/Caches/net.java.openjdk.cmd',
                    ],
            rmdir:  '~/Library/Application Support/Oracle/'

  caveats <<~EOS
    This Cask makes minor modifications to the JRE to prevent issues with
    packaged applications, as discussed here:

      https://bugs.eclipse.org/bugs/show_bug.cgi?id=411361

    If your Java application still asks for JRE installation, you might need
    to reboot or logout/login.

    Installing this Cask means you have AGREED to the Oracle Binary Code
    License Agreement for Java SE at

      http://www.oracle.com/technetwork/java/javase/terms/license/index.html
  EOS
end
