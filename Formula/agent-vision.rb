class AgentVision < Formula
  desc "Give AI agents eyes on your screen"
  homepage "https://github.com/rvanbaalen/agent-vision"
  url "https://github.com/rvanbaalen/agent-vision/releases/download/v0.6.4/agent-vision-arm64.tar.gz"
  version "0.6.4"
  sha256 "70d067e17021f1b01b27eab9a5ba1e424a8a26400d3197357fcbd1b25eeb81bc"
  license "MIT"

  depends_on :macos => :sonoma
  depends_on arch: :arm64

  def install
    app_bundle = prefix/"Agent Vision.app"
    (app_bundle).mkpath
    cp_r Dir["Agent Vision.app/*"], app_bundle

    system "xattr", "-cr", app_bundle.to_s

    bin.install_symlink app_bundle/"Contents/MacOS/agent-vision"
  end

  def caveats
    <<~EOS
      Agent Vision requires macOS permissions:
        - Screen Recording (System Settings > Privacy & Security > Screen Recording)
        - Accessibility (System Settings > Privacy & Security > Accessibility)
    EOS
  end

  test do
    assert_match "agent-vision", shell_output("#{bin}/agent-vision --help")
  end
end
