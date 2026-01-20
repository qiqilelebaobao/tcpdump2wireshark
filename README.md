# tcpdump2wireshark

Remote tcpdump → copy pcap → open in Wireshark (SSH helper script)

远程 tcpdump → 复制 pcap → 在 Wireshark 中打开（SSH 辅助脚本）

---

## Description / 简介

A minimal helper script (t2w.sh) that runs tcpdump remotely over SSH, copies the captured .pcap back to /tmp on the local machine, and opens it with the system default pcap viewer (e.g., Wireshark). On macOS it uses `open`; on Linux it uses `xdg-open`.

一个简洁的辅助脚本（t2w.sh），通过 SSH 在远端运行 tcpdump，抓取到的 .pcap 会被复制到本地 /tmp，并用系统默认的 pcap 查看器（如 Wireshark）打开。macOS 使用 `open`，Linux 使用 `xdg-open`。

---

## About / 关于

Designed for quick remote captures and local inspection. It is intended as a convenience tool for administrators and engineers who need to fetch and inspect packet captures from remote hosts.

用于快速远程抓包并在本地检查。适合需要从远程主机获取并分析抓包的运维或工程人员。

---

## Requirements / 依赖

Remote host requirements:

- SSH access (`ssh` available)
- `tcpdump` installed and executable (may require root or capabilities)
- `timeout` (GNU coreutils) available if a capture duration is specified (optional)

远程主机要求：

- 可通过 SSH 访问（需安装 `ssh`）
- 安装并可执行 `tcpdump`（通常需 root 权限或相应能力）
- 若指定抓包时长，则需 `timeout`（GNU coreutils，可选）

Local machine requirements:

- `scp` to copy the remote pcap (not needed for live mode)
- A program to open pcap files (e.g., Wireshark)
  - macOS: `open` (for file mode)
  - Linux: `xdg-open` (for file mode)
  - Live mode: `wireshark` must be installed and in PATH

本地机要求：

- `scp` 用于复制远程 pcap（实时模式不需要）
- 可打开 pcap 文件的程序（例如 Wireshark）
  - macOS: `open`（文件模式）
  - Linux: `xdg-open`（文件模式）
  - 实时模式：必须安装 `wireshark` 并在 PATH 中

Shell notes / Shell 要点

The script performs minimal checks on the `SHELL` environment variable. Running under `/bin/bash` or `/bin/zsh` is recommended for best compatibility.

脚本仅对 `SHELL` 环境变量做简单判断。推荐在 `/bin/bash` 或 `/bin/zsh` 下运行以获得最佳兼容性。

---

## Usage / 用法

Basic syntax:

```bash
./t2w.sh [REMOTE_HOST] [TARGET_IP_OR_PORT] [CAPTURE_TIME_SECONDS] [OPEN_WAIT_SECONDS] [LIVE_MODE]
```

基本语法：

```bash
./t2w.sh [REMOTE_HOST] [TARGET_IP_OR_PORT] [CAPTURE_TIME_SECONDS] [OPEN_WAIT_SECONDS] [LIVE_MODE]
```

Parameters / 参数说明

- REMOTE_HOST: remote host address or hostname (optional, default `127.0.0.1`)
- TARGET_IP_OR_PORT: capture target; an IPv4 address or a port number (optional, default: capture all traffic)
- CAPTURE_TIME_SECONDS: capture duration in seconds. Use `0` to capture until stopped with Ctrl+C (optional, default `0`)
- OPEN_WAIT_SECONDS: seconds to wait before opening the file (optional, default `1`)
- LIVE_MODE: set to `live` to enable real-time streaming to Wireshark without saving to disk (optional, default `not_live`)

参数说明

- REMOTE_HOST：远程主机地址或主机名（可选，默认 `127.0.0.1`）
- TARGET_IP_OR_PORT：抓包目标，IPv4 地址或端口号（可选，默认：抓取所有流量）
- CAPTURE_TIME_SECONDS：抓包时长（秒）。使用 `0` 表示直到 Ctrl+C 停止（可选，默认 `0`）
- OPEN_WAIT_SECONDS：在打开文件前等待的秒数（可选，默认 `1`）
- LIVE_MODE：设置为 `live` 启用实时流式传输到 Wireshark，不保存到磁盘（可选，默认 `not_live`）

Examples / 示例

```bash
# Capture traffic for IP 10.0.0.5 on remote example.com for 60 seconds, then copy back and open
./t2w.sh example.com 10.0.0.5 60 3

# Capture port 443 traffic on remote 192.168.1.10 until manually stopped
./t2w.sh 192.168.1.10 443 0

# Local default host: capture localhost 127.0.0.1 until Ctrl+C
./t2w.sh

# Real-time streaming: stream port 80 traffic directly to Wireshark without saving
./t2w.sh example.com 80 0 1 live
```

```bash
# 在远程 example.com 上抓取目标 IP 10.0.0.5 的流量 60 秒，然后拷回并打开
./t2w.sh example.com 10.0.0.5 60 3

# 在远程 192.168.1.10 上抓取端口 443 的流量，直到手动停止
./t2w.sh 192.168.1.10 443 0

# 本地默认主机：抓取本机 127.0.0.1 的流量直到 Ctrl+C
./t2w.sh

# 实时流式传输：将端口 80 的流量直接流式传输到 Wireshark，不保存到磁盘
./t2w.sh example.com 80 0 1 live
```

---

## Similar Projects / 相似项目

Looking for alternatives or similar tools? Check out [SIMILAR_REPOSITORIES.md](SIMILAR_REPOSITORIES.md) for a curated list of repositories with similar functionality including remote packet capture, network analysis, and SSH-based tools.

想找替代工具或相似项目？查看 [SIMILAR_REPOSITORIES.md](SIMILAR_REPOSITORIES.md) 获取包括远程抓包、网络分析和基于 SSH 工具的精选仓库列表。

---

## Contributing / 致谢与贡献

Contributions, bug reports, and enhancements are welcome. Please open an issue before submitting a pull request to discuss major changes.

欢迎贡献、报告 bug 或提出改进。提交重大更改前请先在 issue 中讨论。
