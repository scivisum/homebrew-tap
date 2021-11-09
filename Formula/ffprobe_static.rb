class FfprobeStatic < Formula
    desc "ffprobe static build"
    url "http://mac-repo.scivisum.co.uk/binaries/ffprobe_static/ffprobe-4.4.1.zip"
    sha256 "c0b506884064dec8cde87d0f0c447a2294d615f518cbde337d3345e6058e0160"
    def install
        bin.install "ffprobe"
    end
end

