cask "vantage-point" do
  version "0.37.0"
  sha256 "46c29594d3ddda05cf56ab897a0c72061f3e1c61ca93fe3cd658ec93304ad643"

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
