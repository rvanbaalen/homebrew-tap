class Mdreader < Formula
  desc "A beautiful macOS markdown reader"
  homepage "https://github.com/rvanbaalen/mdreader"
  url "https://github.com/rvanbaalen/mdreader/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "e2fffc0c4c6c2183698d17d9461af0a63c96cb10592f255b9612b5cdac758092"
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
      # rm_rf can silently fail on a real .app directory (e.g. quarantine flags),
      # leaving ln_sf to create a symlink *inside* the directory instead of replacing it.
      # Use rm -rf + ln -sfn to guarantee the target is replaced.
      system "rm", "-rf", app_target
      system "ln", "-sfn", app_source, app_target
      ohai "mdreader.app installed to /Applications"
    else
      ohai "To install mdreader.app to Applications, run:"
      puts "  sudo ln -sfn #{app_source} #{app_target}"
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
