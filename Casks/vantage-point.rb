cask "vantage-point" do
  version "0.34.0"
  sha256 "e414d5506d064bed7b0dd1e8a07f7fdfb0a0f5851ab20f1e6b9fe53c1199eeff"

  url "https://github.com/chronista-club/vantage-point/releases/download/v#{version}/VantagePoint-#{version}-arm64.dmg"
  name "Vantage Point"
  desc "AI-native development environment (Rust + WebView)"
  homepage "https://github.com/chronista-club/vantage-point"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :big_sur

  app "VantagePoint.app"
  # CLI (vp) は .app 内 (Contents/MacOS/vp) に同梱 → PATH へ symlink。
  binary "#{appdir}/VantagePoint.app/Contents/MacOS/vp"

  zap trash: [
    "~/.config/vp",
    "~/.local/share/vp",
    "~/.local/state/vp",
  ]
end
