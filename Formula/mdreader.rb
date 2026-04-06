class Mdreader < Formula
  desc "A beautiful macOS markdown reader"
  homepage "https://github.com/rvanbaalen/mdreader"
  url "https://github.com/rvanbaalen/mdreader/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "74b7bbd1b82a32b594f4f8747f8b176560360f9e2aa84a1378c5e35b1bab82f9"
  license "MIT"

  depends_on "node" => :build
  depends_on :macos => :sonoma

  def install
    system "bash", "build.sh"
    prefix.install "mdreader.app"
    system "xattr", "-cr", "#{prefix}/mdreader.app"
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
          sudo rm -rf /Applications/mdreader.app && ln -sfn #{prefix}/mdreader.app /Applications/mdreader.app

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
