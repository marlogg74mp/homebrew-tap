class Zipmount < Formula
  desc "Mount zip, 7z, tar and tar.gz archives read-only, without extracting"
  homepage "https://marlogg74mp.github.io/zipmount/"
  url "https://github.com/marlogg74mp/zipmount/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "a2b72315003f36eaa986fc73a39f7444c923b798a976a261a0c86abefeddb918"
  license "GPL-3.0-or-later"
  head "https://github.com/marlogg74mp/zipmount.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zipmount")
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
