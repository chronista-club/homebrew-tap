cask "vantage-point" do
  version "0.48.0"
  sha256 "cdc2d2dc435659015bb12d9b153eeb44fc6af005fd56f563b424823b4966dae1"

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
  # 旧実装は `launchctl kickstart -k` を直叩きしていたが、これは launchd job 個体しか再起動
  # できない。 app auto-launch した daemon 個体が port を握り、launchd job は二重起動ガードで
  # 空回りしている「所有権分裂」状態では、kickstart は空回り個体を蹴るだけで実 daemon に届かず、
  # upgrade しても version が上がらなかった (2026-07-14 に根本原因を特定)。
  #
  # 代わりに #763 で入った ownership-agnostic な `vp daemon restart --if-running` を使う。
  # 実 port holder を /api/health で特定 → graceful stop → LaunchAgent 優先で新 binary 起動、
  # という所有権に依存しない再起動を行う。`--if-running` は daemon 不在なら no-op で抜けるので、
  # 手動起動派 / 未常駐の人を壊さない (`must_succeed: false` で失敗も握り潰す)。
  #
  # vp binary は差し替え済みの新 .app 同梱実体を絶対 path で叩く (symlink 更新順に依存しない)。
  # 注: daemon restart は同 process group の SP も入れ替わるため、daemon と SP の両方が新 binary
  #     に載る (upgrade では望ましい挙動)。
  postflight do
    vp = "#{appdir}/VantagePoint.app/Contents/MacOS/vp"

    system_command vp,
                   args:         ["daemon", "restart", "--if-running"],
                   must_succeed: false
  end

  zap trash: [
    "~/.config/vp",
    "~/.local/share/vp",
    "~/.local/state/vp",
    "~/Library/LaunchAgents/club.chronista.vantage-point.daemon.plist",
  ]
end
