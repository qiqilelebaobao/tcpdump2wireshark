# tcpdump2wireshark

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Validation](https://github.com/qiqilelebaobao/tcpdump2wireshark/actions/workflows/validation.yml/badge.svg)](https://github.com/qiqilelebaobao/tcpdump2wireshark/actions/workflows/validation.yml)
[![GitHub stars](https://img.shields.io/github/stars/qiqilelebaobao/tcpdump2wireshark?style=social)](https://github.com/qiqilelebaobao/tcpdump2wireshark/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/qiqilelebaobao/tcpdump2wireshark)](https://github.com/qiqilelebaobao/tcpdump2wireshark/issues)
[![GitHub forks](https://img.shields.io/github/forks/qiqilelebaobao/tcpdump2wireshark?style=social)](https://github.com/qiqilelebaobao/tcpdump2wireshark/network)
[![Shell](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

> **Remote tcpdump → copy pcap → open in Wireshark (SSH helper script)**
> 
> **远程 tcpdump → 复制 pcap → 在 Wireshark 中打开（SSH 辅助脚本）**

A minimal, powerful helper script that streamlines network packet capture from remote hosts. Capture traffic over SSH, automatically copy to local machine, and open in Wireshark—all with a single command!

一个简洁而强大的辅助脚本，简化远程主机的网络抓包流程。通过 SSH 抓取流量，自动复制到本地机器，并在 Wireshark 中打开——只需一条命令！

---

## ⭐ Features / 特性

- 🚀 **One-Command Capture**: Single command to capture, transfer, and analyze / 单命令抓包：一条命令即可捕获、传输和分析
- 🔄 **Live Streaming Mode**: Real-time streaming to Wireshark without saving to disk / 实时流模式：实时传输到 Wireshark 而不保存到磁盘
- 🎯 **Flexible Filtering**: Filter by IP address or port number / 灵活过滤：按 IP 地址或端口号过滤
- ⏱️ **Time-based Capture**: Specify capture duration or run until Ctrl+C / 基于时间的抓包：指定抓包时长或运行直到 Ctrl+C
- 🖥️ **Cross-Platform**: Works on both Linux and macOS / 跨平台：在 Linux 和 macOS 上都能运行
- 🔒 **SSH-based**: Secure remote access using SSH / 基于 SSH：使用 SSH 进行安全的远程访问
- 📦 **Zero Dependencies**: Only requires standard tools (ssh, tcpdump, Wireshark) / 零依赖：仅需要标准工具（ssh、tcpdump、Wireshark）

---

## 📋 Table of Contents / 目录

- [Description](#description--简介)
- [About](#about--关于)
- [Features](#-features--特性)
- [Requirements](#requirements--依赖)
- [Installation](#-installation--安装)
- [Usage](#usage--用法)
- [Examples](#examples--示例)
- [Contributing](#contributing--致谢与贡献)
- [License](#-license--许可证)
- [Topics & Keywords](#-topics--keywords--主题和关键词)

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

## 📦 Installation / 安装

### Quick Start / 快速开始

1. Clone the repository / 克隆仓库：
```bash
git clone https://github.com/qiqilelebaobao/tcpdump2wireshark.git
cd tcpdump2wireshark
```

2. Make the script executable / 使脚本可执行：
```bash
chmod +x t2w.sh
```

3. Run it! / 运行：
```bash
./t2w.sh
```

### Optional: Add to PATH / 可选：添加到 PATH

For convenience, you can add the script to your PATH:

为方便使用，可以将脚本添加到 PATH：

```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$PATH:/path/to/tcpdump2wireshark"
```

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

---

## 🎬 Examples / 示例

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

## Contributing / 致谢与贡献

Contributions, bug reports, and enhancements are welcome! Please check out our [Contributing Guidelines](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md).

欢迎贡献、报告 bug 或提出改进！请查看我们的[贡献指南](CONTRIBUTING.md)和[行为准则](CODE_OF_CONDUCT.md)。

### How to Contribute / 如何贡献

1. ⭐ Star this repository / 给这个仓库加星
2. 🐛 Report bugs via [Issues](https://github.com/qiqilelebaobao/tcpdump2wireshark/issues) / 通过 [Issues](https://github.com/qiqilelebaobao/tcpdump2wireshark/issues) 报告错误
3. 💡 Suggest new features / 提出新功能建议
4. 🔧 Submit pull requests / 提交拉取请求
5. 📢 Share with others / 分享给他人

---

## 📄 License / 许可证

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件。

---

## 🏷️ Topics & Keywords / 主题和关键词

For better discoverability on GitHub, consider adding these topics to the repository:

为了在 GitHub 上更容易被发现，建议为仓库添加以下主题：

**Topics to add / 建议添加的主题：**
- `tcpdump`
- `wireshark`
- `packet-capture`
- `network-analysis`
- `ssh`
- `pcap`
- `network-monitoring`
- `devops`
- `sysadmin`
- `network-tools`
- `packet-analyzer`
- `remote-capture`
- `bash-script`
- `shell-script`
- `network-security`
- `troubleshooting`
- `network-debugging`

**How to add topics / 如何添加主题：**
1. Go to the repository page / 前往仓库页面
2. Click "⚙️ Settings" (or the gear icon next to "About") / 点击 "⚙️ Settings"（或 "About" 旁边的齿轮图标）
3. Add the topics in the "Topics" field / 在 "Topics" 字段中添加主题
4. Save changes / 保存更改

---

## 🌟 Why Use tcpdump2wireshark? / 为什么使用 tcpdump2wireshark？

### Common Use Cases / 常见使用场景

- 🔍 **Debugging Network Issues**: Quickly capture and analyze network traffic from production servers / 调试网络问题：快速从生产服务器捕获和分析网络流量
- 🛡️ **Security Analysis**: Investigate suspicious network activity / 安全分析：调查可疑的网络活动
- 📊 **Performance Monitoring**: Analyze network performance and latency / 性能监控：分析网络性能和延迟
- 🧪 **Testing**: Verify API calls, protocols, and network behavior / 测试：验证 API 调用、协议和网络行为
- 📚 **Learning**: Study network protocols and packet structures / 学习：研究网络协议和数据包结构

### Why This Tool? / 为什么选择这个工具？

Traditional workflow / 传统工作流程：
```bash
# 1. SSH to remote server
ssh user@remote-host

# 2. Run tcpdump (need to remember all flags)
sudo tcpdump -i any -w /tmp/capture.pcap host 10.0.0.5

# 3. Exit SSH
exit

# 4. Copy file back
scp user@remote-host:/tmp/capture.pcap /tmp/

# 5. Open in Wireshark
wireshark /tmp/capture.pcap

# 6. Clean up remote file
ssh user@remote-host "rm /tmp/capture.pcap"
```

**With tcpdump2wireshark / 使用 tcpdump2wireshark：**
```bash
./t2w.sh remote-host 10.0.0.5 60
```

That's it! Just one command. 🎉 / 就这样！只需一条命令。🎉

---

## 💬 Support / 支持

If you encounter any issues or have questions:

如果您遇到任何问题或有疑问：

- 📖 Check the documentation above / 查看上面的文档
- 🐛 [Open an issue](https://github.com/qiqilelebaobao/tcpdump2wireshark/issues/new) / [提交 issue](https://github.com/qiqilelebaobao/tcpdump2wireshark/issues/new)
- 💬 Start a [Discussion](https://github.com/qiqilelebaobao/tcpdump2wireshark/discussions) / 发起[讨论](https://github.com/qiqilelebaobao/tcpdump2wireshark/discussions)

---

## 🙏 Acknowledgments / 致谢

Thanks to all contributors and users who have helped improve this project!

感谢所有帮助改进此项目的贡献者和用户！

---

## ⚡ Quick Links / 快速链接

- [Report a Bug](https://github.com/qiqilelebaobao/tcpdump2wireshark/issues/new?template=bug_report.md) / [报告错误](https://github.com/qiqilelebaobao/tcpdump2wireshark/issues/new?template=bug_report.md)
- [Request a Feature](https://github.com/qiqilelebaobao/tcpdump2wireshark/issues/new?template=feature_request.md) / [请求功能](https://github.com/qiqilelebaobao/tcpdump2wireshark/issues/new?template=feature_request.md)
- [Contributing Guide](CONTRIBUTING.md) / [贡献指南](CONTRIBUTING.md)
- [Code of Conduct](CODE_OF_CONDUCT.md) / [行为准则](CODE_OF_CONDUCT.md)

---

<div align="center">

**If you find this project useful, please consider giving it a ⭐️!**

**如果您觉得这个项目有用，请考虑给它一个 ⭐️！**

Made with ❤️ for the networking community

为网络社区用 ❤️ 制作

</div>
