# homebrew-tap

[Vantage Point](https://github.com/chronista-club/vantage-point) (`vp`) の Homebrew tap。

## Install

```bash
brew tap chronista-club/tap
brew install --cask vantage-point
```

notarized `.dmg`（Developer ID 署名 + Apple notarization 済、 arm64）を配布します。
GUI (`Vantage Point.app`) と CLI (`vp`) が同梱されます。

## 更新

cask は vantage-point repo の `release:cask` task（`mise run release:cask`）で
release 後に自動更新されます（version / sha256 / url を反映して push）。

## License

MIT OR Apache-2.0（本体に準拠）
