# 相似功能的仓库 / Similar Repositories

本文档列出了与 tcpdump2wireshark 具有相似功能的 GitHub 仓库。这些仓库专注于远程抓包、网络流量分析、SSH 辅助工具等相关功能。

This document lists GitHub repositories with similar functionality to tcpdump2wireshark. These repositories focus on remote packet capture, network traffic analysis, SSH helper tools, and related functions.

---

## 🎯 直接相似的工具 / Directly Similar Tools

这些仓库提供几乎相同的功能：通过 SSH 远程运行 tcpdump 并在本地 Wireshark 中查看。

These repositories provide almost identical functionality: running tcpdump remotely via SSH and viewing in local Wireshark.

### 1. **wireshark_remote** ⭐ 8 stars
- **仓库 / Repository**: [fetzerch/wireshark_remote](https://github.com/fetzerch/wireshark_remote)
- **语言 / Language**: Python
- **描述 / Description**: Initiate wireshark remote capture (SSH or AVM FRITZ!Box)
- **功能 / Features**: 
  - 支持 SSH 远程抓包 / Supports SSH remote capture
  - 支持 AVM FRITZ!Box 设备 / Supports AVM FRITZ!Box devices
  - Python 实现 / Python implementation
- **适用场景 / Use Cases**: 系统管理员、网络流量分析 / System administrators, traffic analysis

### 2. **remoteShark**
- **仓库 / Repository**: [Arcopix/remoteShark](https://github.com/Arcopix/remoteShark)
- **语言 / Language**: Python
- **描述 / Description**: A set of utilities allowing the user to automate collection of packet captures on a remote system which supports SSH and tcpdump
- **主题 / Topics**: tcpdump, tcpdump-capture, tcpdump-download, wireshark
- **功能 / Features**:
  - 自动化抓包收集 / Automated packet capture collection
  - 支持大多数 Unix/Linux 系统 / Supports most Unix/Linux systems
  - Python 工具集 / Python utilities

### 3. **Remote-Packet-Capture-with-Wirehsark**
- **仓库 / Repository**: [wilson18/Remote-Packet-Capture-with-Wirehsark](https://github.com/wilson18/Remote-Packet-Capture-with-Wirehsark)
- **语言 / Language**: Shell
- **描述 / Description**: A bash script to capture packets remotely with Wireshark over SSH using TCPDump
- **功能 / Features**:
  - Bash 脚本实现 / Bash script implementation
  - 简单直接的远程抓包 / Simple and direct remote capture

### 4. **SSHWireshark**
- **仓库 / Repository**: [pv2b/SSHWireshark](https://github.com/pv2b/SSHWireshark)
- **语言 / Language**: PowerShell
- **描述 / Description**: Packet capture on remote hosts through SSH, view packets live in wireshark!
- **功能 / Features**:
  - 实时查看数据包 / Live packet viewing
  - PowerShell 实现（适用于 Windows）/ PowerShell implementation (suitable for Windows)

### 5. **RemoteCapture**
- **仓库 / Repository**: [decastromonteiro/RemoteCapture](https://github.com/decastromonteiro/RemoteCapture)
- **语言 / Language**: Python
- **描述 / Description**: A simple Python Script to help capture packets from remote server using local wireshark
- **功能 / Features**:
  - Python 实现 / Python implementation
  - 简单易用 / Simple and easy to use

### 6. **wireshark_remote_sudo_ssh**
- **仓库 / Repository**: [LinuxExplore/wireshark_remote_sudo_ssh](https://github.com/LinuxExplore/wireshark_remote_sudo_ssh)
- **语言 / Language**: Batchfile
- **描述 / Description**: Script to Capture Network Packets of remote Linux system
- **功能 / Features**:
  - 专为 Linux 系统设计 / Designed for Linux systems
  - 批处理脚本 / Batch script

---

## 🔧 网络抓包与分析工具 / Network Capture & Analysis Tools

这些工具提供更高级的网络抓包、分析和监控功能。

These tools provide more advanced network capture, analysis, and monitoring features.

### 7. **tproxy** ⭐ 3,650 stars
- **仓库 / Repository**: [kevwan/tproxy](https://github.com/kevwan/tproxy)
- **语言 / Language**: Go
- **描述 / Description**: A cli tool to proxy and analyze TCP connections
- **主题 / Topics**: charles, connection, grpc, monitoring-tool, proxy, tcp, tcpdump, wireshark
- **功能 / Features**:
  - TCP 连接代理和分析 / TCP connection proxy and analysis
  - 支持 gRPC 监控 / Supports gRPC monitoring
  - 高性能 Go 实现 / High-performance Go implementation

### 8. **BruteShark** ⭐ 3,320 stars
- **仓库 / Repository**: [odedshimon/BruteShark](https://github.com/odedshimon/BruteShark)
- **语言 / Language**: C#
- **描述 / Description**: Network Analysis Tool
- **主题 / Topics**: pcap, pcap-files, pcapng, sniffer, sniffing, network-analysis, cybersecurity
- **功能 / Features**:
  - 强大的网络分析功能 / Powerful network analysis capabilities
  - 支持多种协议 / Supports multiple protocols
  - 适合安全研究 / Suitable for security research

### 9. **Malcolm** ⭐ 2,319 stars
- **仓库 / Repository**: [cisagov/Malcolm](https://github.com/cisagov/Malcolm)
- **语言 / Language**: Python
- **描述 / Description**: Malcolm is a powerful, easily deployable network traffic analysis tool suite for full packet capture artifacts (PCAP files), Zeek logs and Suricata alerts
- **主题 / Topics**: zeek, suricata, opensearch, pcap, network-traffic-analysis
- **功能 / Features**:
  - 完整的网络流量分析套件 / Complete network traffic analysis suite
  - 集成 Zeek 和 Suricata / Integrates Zeek and Suricata
  - 强大的可视化界面 / Powerful visualization interface
  - 适合企业级部署 / Suitable for enterprise deployment

### 10. **webshark** ⭐ 272 stars
- **仓库 / Repository**: [QXIP/webshark](https://github.com/QXIP/webshark)
- **语言 / Language**: HTML
- **描述 / Description**: webShark: Wireshark & PCAPs in your browser, 100% Open-Source Cloudshark alternative based on sharkd
- **主题 / Topics**: browser, wireshark, pcap, cloudshark, sharkd
- **功能 / Features**:
  - 浏览器中使用 Wireshark / Use Wireshark in browser
  - CloudShark 的开源替代品 / Open-source CloudShark alternative
  - 基于 sharkd / Based on sharkd

### 11. **hotwire** ⭐ 241 stars
- **仓库 / Repository**: [emmanueltouzery/hotwire](https://github.com/emmanueltouzery/hotwire)
- **语言 / Language**: Rust
- **描述 / Description**: Hotwire allows you to study network traffic of a few popular protocols in a simple way
- **主题 / Topics**: packet-capture, pcap, tcpdump, tshark, wireshark
- **功能 / Features**:
  - 简化的网络流量研究 / Simplified network traffic study
  - 支持常用协议 / Supports popular protocols
  - Rust 实现，高性能 / Rust implementation, high performance

### 12. **dumpy** ⭐ 81 stars
- **仓库 / Repository**: [larryTheSlap/dumpy](https://github.com/larryTheSlap/dumpy)
- **语言 / Language**: Go
- **描述 / Description**: kubectl plugin that performs tpcdump network captures on resources inside kubernetes cluster
- **主题 / Topics**: kubectl, kubernetes, tcpdump, wireshark
- **功能 / Features**:
  - Kubernetes 集群内抓包 / Packet capture inside Kubernetes cluster
  - kubectl 插件 / kubectl plugin
  - 专为容器化环境设计 / Designed for containerized environments

---

## 📊 PCAP 文件处理工具 / PCAP File Processing Tools

这些工具专注于 PCAP 文件的处理、分析和转换。

These tools focus on processing, analyzing, and converting PCAP files.

### 13. **pkappa2** ⭐ 113 stars
- **仓库 / Repository**: [spq/pkappa2](https://github.com/spq/pkappa2)
- **语言 / Language**: Go
- **描述 / Description**: Network traffic analysis tool for Attack & Defense CTF's
- **主题 / Topics**: pcap, pcap-analyzer, ctf, attack-defense
- **功能 / Features**:
  - CTF 比赛专用工具 / Tool for CTF competitions
  - 攻防分析 / Attack & Defense analysis
  - PCAP 分析器 / PCAP analyzer

### 14. **wiresham** ⭐ 69 stars
- **仓库 / Repository**: [abstracta/wiresham](https://github.com/abstracta/wiresham)
- **语言 / Language**: Java
- **描述 / Description**: Simple TCP service mocking tool for replaying Wireshark and tcpdump captured service traffic
- **主题 / Topics**: mock, pcap, tcp, testing, wireshark
- **功能 / Features**:
  - TCP 服务模拟 / TCP service mocking
  - 重放抓包流量 / Replay captured traffic
  - 测试工具 / Testing tool

### 15. **pcap-splitter** ⭐ 67 stars
- **仓库 / Repository**: [shramos/pcap-splitter](https://github.com/shramos/pcap-splitter)
- **语言 / Language**: Python
- **描述 / Description**: Pcap-splitter allows you to split a pcap file into subsets based on sessions, flows, ip addresses, number of bytes, number of network packets
- **主题 / Topics**: pcap, split, flow, session, tcpdump, wireshark
- **功能 / Features**:
  - 按会话、流、IP 分割 PCAP / Split PCAP by session, flow, IP
  - 多种分割标准 / Multiple splitting criteria
  - 流量管理 / Traffic management

### 16. **fluere** ⭐ 60 stars
- **仓库 / Repository**: [SkuldNorniern/fluere](https://github.com/SkuldNorniern/fluere)
- **语言 / Language**: Rust
- **描述 / Description**: Fluere is a powerful and versatile tool designed for network monitoring and analysis. It is capable of capturing network packets in pcap format and converting them into NetFlow data
- **主题 / Topics**: netflow, packet-capture, pcap, network-monitoring, security-tools
- **功能 / Features**:
  - PCAP 转 NetFlow / PCAP to NetFlow conversion
  - 终端用户界面 / Terminal User Interface
  - 实时监控 / Real-time monitoring

---

## 🛡️ 网络安全与入侵检测 / Network Security & Intrusion Detection

这些工具专注于网络安全分析、威胁检测和入侵检测。

These tools focus on network security analysis, threat detection, and intrusion detection.

### 17. **Network-Analysis-Tools** ⭐ 108 stars
- **仓库 / Repository**: [azizaltuntas/Network-Analysis-Tools](https://github.com/azizaltuntas/Network-Analysis-Tools)
- **语言 / Language**: Python
- **描述 / Description**: Pcap (capture file) Analysis Toolkit
- **功能 / Features**:
  - PCAP 分析工具包 / PCAP analysis toolkit
  - Python 实现 / Python implementation
  - 多种分析功能 / Multiple analysis features

### 18. **SplunkForPCAP** ⭐ 44 stars
- **仓库 / Repository**: [DanielSchwartz1/SplunkForPCAP](https://github.com/DanielSchwartz1/SplunkForPCAP)
- **语言 / Language**: Python
- **描述 / Description**: The PCAP Analyzer for Splunk includes useful Dashboards to analyze network packet capture files from Wireshark or Network Monitor
- **主题 / Topics**: splunk, network-analysis, tcpdump, wireshark
- **功能 / Features**:
  - Splunk 集成 / Splunk integration
  - 仪表板可视化 / Dashboard visualization
  - 网络分析 / Network analysis

---

## 📚 其他相关资源 / Other Related Resources

### 官方工具和文档 / Official Tools & Documentation

1. **Wireshark 官方文档 / Wireshark Official Documentation**
   - [https://www.wireshark.org/docs/](https://www.wireshark.org/docs/)
   - 官方用户指南和手册 / Official user guide and manual

2. **tcpdump 官方网站 / tcpdump Official Website**
   - [https://www.tcpdump.org/](https://www.tcpdump.org/)
   - tcpdump 和 libpcap 官方资源 / Official resources for tcpdump and libpcap

3. **Wireshark Wiki**
   - [https://wiki.wireshark.org/](https://wiki.wireshark.org/)
   - 社区维护的知识库 / Community-maintained knowledge base

---

## 🎯 选择建议 / Selection Guide

根据您的需求选择合适的工具：

Choose the right tool based on your needs:

| 需求 / Need | 推荐工具 / Recommended Tool | 原因 / Reason |
|------------|---------------------------|--------------|
| 简单的 SSH 远程抓包 / Simple SSH remote capture | **tcpdump2wireshark**, **wireshark_remote** | 轻量级，易于使用 / Lightweight, easy to use |
| Python 脚本自动化 / Python script automation | **remoteShark**, **RemoteCapture** | Python 生态系统集成好 / Good Python ecosystem integration |
| Windows 环境 / Windows environment | **SSHWireshark** | PowerShell 实现 / PowerShell implementation |
| 企业级网络分析 / Enterprise network analysis | **Malcolm**, **BruteShark** | 功能全面，可扩展 / Comprehensive features, scalable |
| 浏览器内分析 / Browser-based analysis | **webshark** | 无需安装客户端 / No client installation needed |
| Kubernetes 环境 / Kubernetes environment | **dumpy** | kubectl 插件集成 / kubectl plugin integration |
| CTF 竞赛 / CTF competitions | **pkappa2** | 攻防分析专用 / Specialized for attack & defense |
| PCAP 文件处理 / PCAP file processing | **pcap-splitter**, **fluere** | 强大的文件处理能力 / Powerful file processing capabilities |

---

## 🤝 贡献与反馈 / Contribution & Feedback

如果您发现其他相似的优秀项目，欢迎通过 issue 或 pull request 提交。

If you find other excellent similar projects, please submit them via issue or pull request.

---

## 📝 许可证 / License

本文档遵循与主仓库相同的许可证。

This document follows the same license as the main repository.

---

**最后更新 / Last Updated**: 2026-01-20
