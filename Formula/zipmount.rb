class Zipmount < Formula
  desc "Mount zip, 7z, tar and tar.gz archives read-only, without extracting"
  homepage "https://marlogg74mp.github.io/zipmount/"
  license "GPL-3.0-or-later"

  # The latest master, built from source: that one does need Rust.
  head do
    url "https://github.com/marlogg74mp/zipmount.git", branch: "master"
    depends_on "rust" => :build
  end

  # The binaries built by the release workflow, attested there: no Rust to
  # install, nothing to compile. `gh attestation verify` checks any of them.
  on_macos do
    # Released for Apple Silicon only.
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/marlogg74mp/zipmount/releases/download/v0.3.0/zipmount-0.3.0-macos-arm64.tar.gz"
      sha256 "a9f7cc1ed4b8a4a6ee8fc4f9fe78a8fbaa28582de399f7bd42e7c8eac1eac140"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/marlogg74mp/zipmount/releases/download/v0.3.0/zipmount-0.3.0-linux-x86_64.tar.gz"
      sha256 "83e6de80d2addb6477b08775f584cabcc02e901ee5981288c2525bf2003fde3b"
    end
    on_arm do
      url "https://github.com/marlogg74mp/zipmount/releases/download/v0.3.0/zipmount-0.3.0-linux-arm64.tar.gz"
      sha256 "bf1972d6b3b783d8a3a2365ecb34da0f4837f1c537dcfbf9318ec53341683223"
    end
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args(path: "crates/zipmount")
    else
      bin.install "zipmount"
      doc.install "README.md", "THIRD-PARTY-NOTICES.md"
      prefix.install "LICENSE"
    end
  end

  def caveats
    on_macos do
      <<~EOS
        Mounting uses the NFS client built into macOS: no macFUSE, no kernel
        extension. To add "Mount with ZipMount" to Finder's Quick Actions:
          zipmount shell-install
      EOS
    end
    on_linux do
      <<~EOS
        Mounting needs FUSE (the fuse3 package of your distribution).
        To add "Mount with ZipMount" to the file manager:
          zipmount shell-install
      EOS
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zipmount --version")
    # An archive to look into: a plain tar of one file.
    (testpath/"hello.txt").write "hello from the archive\n"
    system "tar", "-cf", testpath/"test.tar", "-C", testpath, "hello.txt"
    assert_match "hello.txt", shell_output("#{bin}/zipmount ls #{testpath}/test.tar")
    assert_match "hello from the archive",
                 shell_output("#{bin}/zipmount grep #{testpath}/test.tar archive")
  end
end
