class Dune3d < Formula
  desc "Parametric 3D CAD application with STEP import/export"
  homepage "https://dune3d.org"
  url "https://github.com/dune3d/dune3d/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "1465cd1d30ff00a82cadb0243065049af35149b0ed37679076ff805ffafd6d62"
  license "GPL-3.0-or-later"
  head "https://github.com/dune3d/dune3d.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3" => :build
  depends_on "pygobject3" => :build
  depends_on "librsvg" => :build

  depends_on "adwaita-icon-theme"
  depends_on "eigen"
  depends_on "glm"
  depends_on "gtk4"
  depends_on "gtkmm4"
  depends_on :macos
  depends_on "opencascade"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    llvm = Formula["llvm"]
    ENV["CC"] = llvm.opt_bin/"clang"
    ENV["CXX"] = llvm.opt_bin/"clang++"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  def caveats
    <<~EOS
      Dune3D macOS support is experimental upstream.
      If you encounter issues, check: https://github.com/dune3d/dune3d/issues
    EOS
  end

  test do
    assert_match "dune3d", shell_output("#{bin}/dune3d --help")
  end
end
