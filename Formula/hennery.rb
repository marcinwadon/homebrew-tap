class Hennery < Formula
  desc "Self-hosted cockpit for ACP coding agents"
  homepage "https://github.com/marcinwadon/hennery"
  version "0.3.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/marcinwadon/hennery/releases/download/v0.3.7/hennery-aarch64-apple-darwin.tar.xz"
      sha256 "55e63409e4ffc7ab695c9d06390357ce86b5129ff28c89cc56c65bb6c24dd453"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/marcinwadon/hennery/releases/download/v0.3.7/hennery-aarch64-unknown-linux-musl.tar.xz"
      sha256 "6c5430e15ed8b51615beffd8b3cfa86d5fa9124706d9b2ca377079fa50ee0a5e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/marcinwadon/hennery/releases/download/v0.3.7/hennery-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f2220af5dfaf0c67a89ff56eae4569a31ffb5d194100ef004ccb18db8f797262"
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
