class Hennery < Formula
  desc "Self-hosted cockpit for ACP coding agents"
  homepage "https://github.com/marcinwadon/hennery"
  version "0.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/marcinwadon/hennery/releases/download/v0.3.3/hennery-aarch64-apple-darwin.tar.xz"
      sha256 "20f9c517a2457004e2152d7da2e578d8ce1dcb58463f8b6d103395f85833531c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/marcinwadon/hennery/releases/download/v0.3.3/hennery-aarch64-unknown-linux-musl.tar.xz"
      sha256 "deffc1af4e824375337ce56f5967b8c1c78ace166cb1b5e795d8c1c2ca410bb7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/marcinwadon/hennery/releases/download/v0.3.3/hennery-x86_64-unknown-linux-musl.tar.xz"
      sha256 "616b98a62822a51bba62e0557f9e48a6ae5e27c4527c6f7ebb4263f03e1a94ea"
    end
  end
  license "AGPL-3.0-only"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static": {},
    "x86_64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    doc.install "CHANGELOG.md"
    doc.install "LICENSE"
    doc.install "README.md"
    if OS.mac? && Hardware::CPU.arm?
      bin.install "hennery"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "hennery"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "hennery"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
  test do
    assert_match version.to_s, shell_output("#{bin}/hennery --version")
    refute_match "hennery-web-ui-not-embedded", File.binread(bin/"hennery")
    assert_path_exists pkgshare/"THIRD-PARTY-NOTICES.txt"
    assert_path_exists doc/"CHANGELOG.md"
    assert_path_exists doc/"LICENSE"
    assert_path_exists doc/"README.md"
  end
end
