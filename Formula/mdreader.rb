class Mdreader < Formula
  desc "A beautiful macOS markdown reader"
  homepage "https://github.com/rvanbaalen/mdreader"
  url "https://github.com/rvanbaalen/mdreader/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "18c8cb5c2a760284870205515a5fee9bc888b87926e79c32ee9649a4d43570ae"
  license "MIT"

  depends_on "node" => :build
  depends_on :macos => :sonoma

  def install
    system "bash", "build.sh"
    prefix.install "mdreader.app"
    bin.install_symlink prefix/"mdreader.app/Contents/MacOS/mdreader"

    system "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister", "#{prefix}/mdreader.app"
  end

  def post_install
    app_source = "#{prefix}/mdreader.app"
    app_target = "/Applications/mdreader.app"

    if File.writable?("/Applications")
      FileUtils.rm_rf(app_target)
      FileUtils.ln_sf(app_source, app_target)
      ohai "mdreader.app installed to /Applications"
    else
      ohai "To install mdreader.app to Applications, run:"
      puts "  sudo ln -sf #{app_source} #{app_target}"
    end
  end

  def caveats
    unless File.symlink?("/Applications/mdreader.app")
      <<~EOS
        To add mdreader to your Applications folder:
          sudo ln -sf #{prefix}/mdreader.app /Applications/mdreader.app

        Usage:
          mdreader README.md
          open -a mdreader README.md
      EOS
    end
  end

  test do
    assert_predicate prefix/"mdreader.app", :exist?
    assert_predicate prefix/"mdreader.app/Contents/MacOS/mdreader", :executable?
  end
end
