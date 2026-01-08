# tcpdump2wireshark

Remote tcpdump → copy pcap → open in Wireshark (simple SSH helper script)

远程 tcpdump → 复制 pcap → 在 Wireshark 中打开（简单的 SSH 辅助脚本）

A small helper script (t2w.sh) to remotely run tcpdump over SSH on a host, copy the resulting pcap to the local machine and open it with the default GUI packet viewer (e.g., Wireshark).

一个小型辅助脚本（t2w.sh），用于通过 SSH 在远程主机上运行 tcpdump，复制生成的 pcap 到本地机器并用默认的图形化抓包查看器（例如 Wireshark）打开。

---

## Description / 简介

`t2w.sh` runs tcpdump on a remote host over SSH, copies the generated .pcap to /tmp on your machine, and opens it with the system default pcap viewer (e.g., Wireshark). On macOS it uses `open`, on Linux `xdg-open`.

`t2w.sh` 通过 SSH 在远端主机上运行 tcpdump（抓包），将生成的 pcap 文件拷贝回本地 /tmp 并自动用系统默认的程序打开（macOS 使用 `open`，Linux 使用 `xdg-open`）。

About:
- t2w.sh is designed for quick remote captures and local inspection: it runs tcpdump remotely, copies the resulting .pcap back to /tmp, and opens it with the system pcap viewer (e.g., Wireshark).

关于：
- t2w.sh 用于快速远程抓包并在本地检查：它会在远端运行 tcpdump，将生成的 .pcap 复制回本地 /tmp，并用系统 pcap 查看器（例如 Wireshark）打开。

---

## Requirements / 依赖

Remote host requirements:
- SSH access (`ssh` available)
- `tcpdump` installed and executable (often requires root or appropriate capabilities)
- `timeout` (GNU coreutils) available (optional, only needed if a capture duration is specified)

远程主机需要：
- 支持通过 SSH 连接（`ssh` 可用）
- 有 `tcpdump` 可用并且可执行（通常需要 root 权限或为 tcpdump 配置了能力）
- 有 `timeout`（GNU coreutils）可用（可选，仅当指定抓包时长时需要）

Local machine requirements:
- `scp` to copy remote files
- A default application capable of opening pcaps (e.g., Wireshark) and:
  - macOS: `open` command
  - Linux: `xdg-open` command

本地机需要：
- 支持 `scp`（用于复制远程文件）
- 一个可以打开 pcap 的��认应用（Wireshark 等），以及：
  - macOS: `open` 命令
  - Linux: `xdg-open` 命令

Shell requirements:
- The script checks the `SHELL` environment variable lightly; running under `/bin/bash` or `/bin/zsh` is recommended for best compatibility.

Shell 要求：
- 脚本对 `SHELL` 环境变量有简要判断，推荐在 `/bin/bash` 或 `/bin/zsh` 下运行脚本以获得最佳兼容性。

---

## Usage / 用法

Basic syntax:
```
./t2w.sh [REMOTE_HOST] [TARGET_IP_OR_PORT] [CAPTURE_TIME_SECONDS] [OPEN_WAIT_SECONDS]
```

基本语法：
```
./t2w.sh [REMOTE_HOST] [TARGET_IP_OR_PORT] [CAPTURE_TIME_SECONDS] [OPEN_WAIT_SECONDS]
```

Parameters:
- REMOTE_HOST: remote host address or hostname (optional, default `127.0.0.1`)
- TARGET_IP_OR_PORT: capture target, can be an IPv4 address or a port number (optional, default `127.0.0.1`)
- CAPTURE_TIME_SECONDS: capture duration in seconds. Use `0` to capture until you stop with Ctrl+C (optional, default `0`)
- OPEN_WAIT_SECONDS: seconds to wait before opening the file. The script currently validates this as an integer but does not use it in the flow (reserved for future use) (optional, default `3`)

参数说明：
- REMOTE_HOST: 远程主机地址或主机名（可选，默认 `127.0.0.1`）
- TARGET_IP_OR_PORT: 抓包目标，可传 IPv4 地址或端口号（可选，默认 `127.0.0.1`）
- CAPTURE_TIME_SECONDS: 抓包持续时间（秒）。传 `0` 表示持续抓包直到你在终端按 `Ctrl+C` 停止（可选，默认 `0`）
- OPEN_WAIT_SECONDS: 打开文件前的等待时间（秒）。当前脚本会校验该值为整数，但本版本并未在流程中使用（保留位，用于未来扩展）（可选，默认 `3`）

Examples:
```
# Capture traffic for IP 10.0.0.5 on remote example.com for 60 seconds, then copy back and open
./t2w.sh example.com 10.0.0.5 60 3

# Capture port 443 traffic on remote 192.168.1.10 until manually stopped
./t2w.sh 192.168.1.10 443 0

# Local default host, capture localhost 127.0.0.1 until Ctrl+C
./t2w.sh
```

举例：
```
# 在远程 example.com 上抓取目标 IP 10.0.0.5 的流量，持续 60 秒，然后把 /tmp/remote_...pcap 拷回并打开
./t2w.sh example.com 10.0.0.5 60 3

# 在远程 192.168.1.10 上抓取端口 443 的流量，直到手动停止
./t2w.sh 192.168.1.10 443 0

# 在本地(默认)抓取目标 IP 127.0.0.1，持续抓取直到 Ctrl+C
./t2w.sh
```

---

## Security & Recommendations / 安全与建议

The script uses timestamped filenames which may include colons (`:`). These can be incompatible on some filesystems or environments (e.g., Windows). For cross-platform compatibility consider using a timestamp format without colons.

- 当前脚本使用带时间戳的文件名，文件名中包含冒号（`:`），在某些文件系统或环境（Windows）可能不兼容。若需要跨平台兼容，可改用不含冒号的格式。

---

## Examples (quick reference) / 示例（快速参考）

```
# Connect to remote example.com and capture traffic for 10.0.0.5 for 30 seconds
./t2w.sh example.com 10.0.0.5 30

# Connect to 192.168.0.5 and capture port 22 (SSH) until manually stopped
./t2w.sh 192.168.0.5 22 0

# Local default host, capture local 127.0.0.1 traffic and open
./t2w.sh
```

```
# 连到远程 example.com，抓取 10.0.0.5 的流量 30 秒
./t2w.sh example.com 10.0.0.5 30

# 连到 192.168.0.5，抓取端口 22（SSH）的流量，直到手动停止
./t2w.sh 192.168.0.5 22 0

# 本地默认主机，抓取本机 127.0.0.1 的流量并打开
./t2w.sh
```

---

## Acknowledgements / 致谢 & Contributing

If you want to improve the script, please open a PR or discuss it in an issue.

如需改进脚本, 欢迎提交 PR 或在 issue 中讨论。
