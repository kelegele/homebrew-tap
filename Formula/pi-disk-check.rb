class PiDiskCheck < Formula
  desc "launchd disk sentinel: tiered cleanup reports when volume usage exceeds threshold, analyze-only"
  homepage "https://github.com/kelegele/pi-disk-check"
  url "https://github.com/kelegele/pi-disk-check/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "40761db993aaddc256195bc034f81733ad2f6540ed28ab16224df43a4716dc8d"
  version "0.1.1"

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
