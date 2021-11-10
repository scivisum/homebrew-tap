class FfmpegStatic < Formula
    desc "ffmpeg static build"
    url "http://mac-repo.scivisum.co.uk/binaries/ffmpeg_static/ffmpeg_static.tar.gz"
    sha256 "5a7484449cc4d813fd0c5535eab6d3addc86884c3b2ccfcf2e71547655721a0e"
    version "4.4.1"
    def install
        bin.install "ffmpeg"
	bin.install "ffprobe"
    end
end
