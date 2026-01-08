# tcpdump2wireshark

Remote tcpdump → copy pcap → open in Wireshark (SSH helper script)

远程 tcpdump → 复制 pcap → 在 Wireshark 中打开（SSH 辅助脚本）

Description / 简介

A minimal helper script (t2w.sh) that runs tcpdump remotely over SSH, copies the captured .pcap back to /tmp on the local machine, and opens it with the system default pcap viewer (e.g., Wireshark). On macOS it uses `open`; on Linux it uses `xdg-open`.

一个简洁的辅助脚本（t2w.sh），通过 SSH 在远端运行 tcpdump，抓取到的 .pcap 会被复制到本地 /tmp，并用系统默认的 pcap 查看器（如 Wireshark）打开。macOS 使用 `open`，Linux 使用 `xdg-open`。

About / 关于

Designed for quick remote captures and local inspection. It is intended as a convenience tool for administrators and engineers who need to fetch and inspect packet captures from remote hosts.

用于快速远程抓包并在本地检查。适合需要从远程主机获取并分析抓包的运维或工程人员。

Requirements / 依赖

Remote host requirements:
- SSH access (`ssh` available)
- `tcpdump` installed and executable (may require root or capabilities)
- `timeout` (GNU coreutils) available if a capture duration is specified (optional)

远程主机要求：
- 可通过 SSH 访问（需安装 `ssh`）
- 安装并可执行 `tcpdump`（通常需 root 权限或相应能力）
- 若指定抓包时长，则需 `timeout`（GNU coreutils，可选）

Local machine requirements:
- `scp` to copy the remote pcap
- A program to open pcap files (e.g., Wireshark)
  - macOS: `open`
  - Linux: `xdg-open`

本地机要求：
- `scp` 用于复制远程 pcap
- 可打开 pcap 文件的程序（例如 Wireshark）
  - macOS: `open`
  - Linux: `xdg-open`

Shell notes / Shell 要点

The script performs minimal checks on the `SHELL` environment variable. Running under `/bin/bash` or `/bin/zsh` is recommended for best compatibility.

脚本仅对 `SHELL` 环境变量做简单判断。推荐在 `/bin/bash` 或 `/bin/zsh` 下运行以获得最佳兼容性。

Usage / 用法

Basic syntax:
```
./t2w.sh [REMOTE_HOST] [TARGET_IP_OR_PORT] [CAPTURE_TIME_SECONDS] [OPEN_WAIT_SECONDS]
```

基本语法：
```
./t2w.sh [REMOTE_HOST] [TARGET_IP_OR_PORT] [CAPTURE_TIME_SECONDS] [OPEN_WAIT_SECONDS]
```

Parameters / 参数说明
- REMOTE_HOST: remote host address or hostname (optional, default `127.0.0.1`)
- TARGET_IP_OR_PORT: capture target; an IPv4 address or a port number (optional, default `127.0.0.1`)
- CAPTURE_TIME_SECONDS: capture duration in seconds. Use `0` to capture until stopped with Ctrl+C (optional, default `0`)
- OPEN_WAIT_SECONDS: seconds to wait before opening the file. Currently validated but not actively used (reserved for future use) (optional, default `3`)

参数说明
- REMOTE_HOST：远程主机地址或主机名（可选，默认 `127.0.0.1`）
- TARGET_IP_OR_PORT：抓包目标，IPv4 地址或端口号（可选，默认 `127.0.0.1`）
- CAPTURE_TIME_SECONDS：抓包时长（秒）。使用 `0` 表示直到 Ctrl+C 停止（可选，默认 `0`）
- OPEN_WAIT_SECONDS：在打开文件前等待的秒数。当前会校验为整数，但流程中未使用（保留以备将来扩展）（可选，默认 `3`）

Examples / 示例
```
# Capture traffic for IP 10.0.0.5 on remote example.com for 60 seconds, then copy back and open
./t2w.sh example.com 10.0.0.5 60 3

# Capture port 443 traffic on remote 192.168.1.10 until manually stopped
./t2w.sh 192.168.1.10 443 0

# Local default host: capture localhost 127.0.0.1 until Ctrl+C
./t2w.sh
```

```
# 在远程 example.com 上抓取目标 IP 10.0.0.5 的流量 60 秒，然后拷回并打开
./t2w.sh example.com 10.0.0.5 60 3

# 在远程 192.168.1.10 上抓取端口 443 的流量，直到手动停止
./t2w.sh 192.168.1.10 443 0

# 本地默认主机：抓取本机 127.0.0.1 的流量直到 Ctrl+C
./t2w.sh
```

Security & Recommendations / 安全与建议

The script uses timestamped filenames which may include colons (`:`). These characters can be incompatible with some filesystems (e.g., Windows). For cross-platform compatibility, consider using a timestamp format without colons.

脚本使用带时间戳的文件名，可能包含冒号（`:`）。某些文件系统（如 Windows）不兼容冒号。若需跨平台兼容，建议使用不含冒号的时间戳格式。

Contributing / 致谢与贡献

Contributions, bug reports, and enhancements are welcome. Please open an issue before submitting a pull request to discuss major changes.

欢迎贡献、报告 bug 或提出改进。提交重大更改前请先在 issue 中讨论。

---

If you want, I can also: refine wording further, split content into separate sections for advanced options, or create a dedicated man page / usage help. Let me know which you prefer.

如果需要，我还可以进一步润色措辞、将内容扩展为高级选项单独章节，或创建独立的 man 页面／使用帮助。请告诉我你的偏好。
