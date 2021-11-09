class FfmpegStatic < Formula
    desc "ffmpeg static build"
    url "http://mac-repo.scivisum.co.uk/binaries/ffmpeg_static/ffmpeg-4.4.1.zip"
    sha256 "d7f3ea44b6086834fac4198f2f0a82f93ac9fba587d94f6b086b16ed228fcdb3"
    def install
        bin.install "ffmpeg"
    end
end
