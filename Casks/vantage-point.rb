cask "vantage-point" do
  version "0.43.1"
  sha256 "486e0f3f5de74e42849d6bf20c31ef04db5f70ea5be2a7c838e76fffef0c5ae0"

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

  # brew upgrade 後に、常駐している TheWorld daemon を新 binary で起こし直す。
  #
  # daemon (`vp world`) の常駐は `vp daemon install` が作る LaunchAgent が担い、この cask は
  # その lifecycle を所有しない。 upgrade で .app は差し替わるが、稼働中の daemon は旧 image の
  # まま走り続けるため、明示的に再起動しないと新版が効かない (従来は手動で `vp daemon stop` が必要
  # だった)。
  #
  # `kickstart -k` は job を落として起こし直す (KeepAlive と競合しない)。 LaunchAgent 未登録の
  # 環境では `print` が失敗して何もしない — 手動起動派 / 未常駐の人を壊さない。
  #
  # 注: launchd job の再起動は同 process group の SP も reap するため、daemon と SP の両方が
  #     新 binary に載る (upgrade では望ましい挙動)。
  postflight do
    label  = "club.chronista.vantage-point.daemon"
    target = "gui/#{Process.uid}/#{label}"

    loaded = system_command("/bin/launchctl",
                            args:         ["print", target],
                            must_succeed: false).exit_status.zero?
    next unless loaded

    system_command "/bin/launchctl",
                   args:         ["kickstart", "-k", target],
                   must_succeed: false
  end

  zap trash: [
    "~/.config/vp",
    "~/.local/share/vp",
    "~/.local/state/vp",
    "~/Library/LaunchAgents/club.chronista.vantage-point.daemon.plist",
  ]
end
