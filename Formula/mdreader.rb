class Mdreader < Formula
  desc "A beautiful macOS markdown reader"
  homepage "https://github.com/rvanbaalen/mdreader"
  url "https://github.com/rvanbaalen/mdreader/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "7909fabed84d9e410ebf338a2e429a23ec88504b281665137947bb09508e2d10"
  license "MIT"

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
