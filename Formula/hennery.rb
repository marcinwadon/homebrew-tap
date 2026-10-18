class Hennery < Formula
  desc "Self-hosted cockpit for ACP coding agents"
  homepage "https://github.com/marcinwadon/hennery"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/marcinwadon/hennery/releases/download/v0.1.1/hennery-aarch64-apple-darwin.tar.xz"
      sha256 "cdc616b126c0cf33e94106e9edb6efac770086c8c08813563d3c40809fde2732"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/marcinwadon/hennery/releases/download/v0.1.1/hennery-aarch64-unknown-linux-musl.tar.xz"
      sha256 "9913215cc9dfe5ff206508a3307d748baea8f3e61573e71adafa4548d8293778"
    end
    if Hardware::CPU.intel?
      url "https://github.com/marcinwadon/hennery/releases/download/v0.1.1/hennery-x86_64-unknown-linux-musl.tar.xz"
      sha256 "898a053dcc856c2a8e30a2f610ae2e94292f803353d53b246b2d611338efe5bd"
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
