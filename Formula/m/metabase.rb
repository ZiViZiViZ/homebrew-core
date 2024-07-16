class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.50.13/metabase.jar"
  sha256 "57b54ebd2b60e8fc52ba332062d9130f60489aba33aa56b9e639d4ad450c815b"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "85815a9c01926de761eeac10831bb2a20847d00bdda05507b2ac1e7229f1e4ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85815a9c01926de761eeac10831bb2a20847d00bdda05507b2ac1e7229f1e4ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85815a9c01926de761eeac10831bb2a20847d00bdda05507b2ac1e7229f1e4ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "85815a9c01926de761eeac10831bb2a20847d00bdda05507b2ac1e7229f1e4ef"
    sha256 cellar: :any_skip_relocation, ventura:        "85815a9c01926de761eeac10831bb2a20847d00bdda05507b2ac1e7229f1e4ef"
    sha256 cellar: :any_skip_relocation, monterey:       "85815a9c01926de761eeac10831bb2a20847d00bdda05507b2ac1e7229f1e4ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13e936881ca8cc54ba86ec062cafb47288e206e1e98e3ddad4fdb67421815c23"
  end

  head do
    url "https://github.com/metabase/metabase.git", branch: "master"

    depends_on "leiningen" => :build
    depends_on "node" => :build
    depends_on "yarn" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "./bin/build"
      libexec.install "target/uberjar/metabase.jar"
    else
      libexec.install "metabase.jar"
    end

    bin.write_jar_script libexec/"metabase.jar", "metabase"
  end

  service do
    run opt_bin/"metabase"
    keep_alive true
    require_root true
    working_dir var/"metabase"
    log_path var/"metabase/server.log"
    error_log_path "/dev/null"
  end

  test do
    system bin/"metabase", "migrate", "up"
  end
end
