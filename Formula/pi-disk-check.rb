class PiDiskCheck < Formula
  desc "launchd disk sentinel: tiered cleanup reports when volume usage exceeds threshold, analyze-only"
  homepage "https://github.com/kelegele/pi-disk-check"
  url "https://github.com/kelegele/pi-disk-check/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "f13a12e9bd80ad090e0a8f3324348fe16c6e3add38cef3aa67ed0084e2849b87"
  version "0.1.5"

  def install
    bin.install "bin/pi-disk-check.sh" => "pi-disk-check"
  end

  service do
    run [opt_bin/"pi-disk-check", "run"]
    run_type :cron
    cron "0 10 * * *"
    environment_variables PI_DISK_CHECK_DATA: "#{HOMEBREW_PREFIX}/var/pi-disk-check"
  end

  def caveats
    <<~EOS
      数据与报告目录: #{HOMEBREW_PREFIX}/var/pi-disk-check
      启动定时检查:   brew services start pi-disk-check
      手动检查:       pi-disk-check run
      查看状态:       pi-disk-check status

      pi 可选：检测到 pi 时自动走智能分析（调 LLM 有 token 成本），否则降级纯 shell 扫描。
      阈值调整: PI_DISK_CHECK_THRESHOLD 环境变量（默认 85）。
    EOS
  end

  test do
    assert_match "run", shell_output("#{bin}/pi-disk-check badcmd", 2)
  end
end
