cask "vantage-point" do
  version "0.20.0"
  sha256 "705402e15f68ab0b6b1ca6ae07731031894180f5ccc7c19000d07ca15615cf74"

  url "https://github.com/chronista-club/vantage-point/releases/download/v#{version}/VantagePoint-#{version}-arm64.dmg"
  name "Vantage Point"
  desc "AI-native development environment (Rust + WebView)"
  homepage "https://github.com/chronista-club/vantage-point"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: ">= :big_sur"

  app "VantagePoint.app"
  # CLI (vp) は .app 内 (Contents/MacOS/vp) に同梱 → PATH へ symlink。
  binary "#{appdir}/VantagePoint.app/Contents/MacOS/vp"

  zap trash: [
    "~/.config/vp",
    "~/.local/share/vp",
    "~/.local/state/vp",
  ]
end
