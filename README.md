# tcpdump2wireshark

Remote tcpdump → copy pcap → open in Wireshark (simple SSH helper script)

A small helper script (t2w.sh) to remotely run tcpdump over SSH on a host, copy the resulting pcap to the local machine and open it with the default GUI packet viewer (e.g., Wireshark).

脚本作者: qiqilelebaobao  
脚本文件: `t2w.sh`

---

## 简介

`t2w.sh` 通过 SSH 在远端主机上运行 tcpdump（抓包），将生成的 pcap 文件拷贝回本地 /tmp 并自动用系统默认的程序打开（macOS 使用 `open`，Linux 使用 `xdg-open`）。脚本会排除当前 SSH 会话的端口，避免把 SSH 自己的流量包含进抓包。

本仓库简短说明（About）：
- t2w.sh runs tcpdump on a remote host over SSH, copies the generated .pcap to /tmp on your machine, and opens it with the system default pcap viewer (e.g., Wireshark). Designed for quick remote capture and analysis.

---

## 依赖 / 前提

远程主机需要：
- 支持通过 SSH 连接（`ssh` 可用）
- 有 `tcpdump` 可用并且可执行（通常需要 root 权限或为 tcpdump 配置了能力）
- 有 `timeout`（GNU coreutils）可用（可选，仅当指定抓包时长时需要）

本地机需要：
- 支持 `scp`（用于复制远程文件）
- 一个可以打开 pcap 的默认应用（Wireshark 等），以及：
  - macOS: `open` 命令
  - Linux: `xdg-open` 命令

Shell 要求：
- 脚本对 `SHELL` 环境变量有简要判断，推荐在 `/bin/bash` 或 `/bin/zsh` 下运行脚本以获得最佳兼容性。

注意：
- `tcpdump` 通常需要 root 权限。如果远端不能以当前用户直接运行 `tcpdump`，请在远端允许非特权用户抓包（例如通过 `setcap`）或者在远端允许 sudo 的方式（如果修改脚本以使用 sudo）。

---

## 用法

基本语法：
```bash
./t2w.sh [REMOTE_HOST] [TARGET_IP_OR_PORT] [CAPTURE_TIME_SECONDS] [OPEN_WAIT_SECONDS]
```

参数说明：
- REMOTE_HOST: 远程主机地址或主机名（可选，默认 `127.0.0.1`）
- TARGET_IP_OR_PORT: 抓包目标，可传 IPv4 地址或端口号（可选，默认 `127.0.0.1`）
- CAPTURE_TIME_SECONDS: 抓包持续时间（秒）。传 `0` 表示持续抓包直到你在终端按 `Ctrl+C` 停止（可选，默认 `0`）
- OPEN_WAIT_SECONDS: 打开文件前的等待时间（秒）。当前脚本会校验该值为整数，但本版本并未在流程中使用（保留位，用于未来扩展）（可选，默认 `3`）

举例：
```bash
# 在远程 example.com 上抓取目标 IP 10.0.0.5 的流量，持续 60 秒，然后把 /tmp/remote_...pcap 拷回并打开
./t2w.sh example.com 10.0.0.5 60 3

# 在远程 192.168.1.10 上抓取端口 443 的流量，直到手动停止
./t2w.sh 192.168.1.10 443 0

# 在本地(默认)抓取目标 IP 127.0.0.1，持续抓取直到 Ctrl+C
./t2w.sh
```

---

## 脚本行为（概述）

1. 校验第三个参数（CAPTURE_TIME_SECONDS）是否为非负整数。
2. 识别第二个参数是 IPv4 地址还是端口（或既不是两者则报错退出）。
   - IP 检查使用正则匹配 IPv4 格式（注意：脚本中对每段的 0-255 检查有注释但被注释掉了）。
   - 检测当前 Shell (`SHELL`) 是否为 `/bin/bash` 或 `/bin/zsh`，否则会打印提示并当成非法输入。
3. 通过 SSH 在远端运行 tcpdump：
   - 远端文件名: `/tmp/${HOST}_YYYY-MM-DD_HH:MM:SS.pcap`
   - 运行的 tcpdump 命令会剔除 SSH 客户端的端口（从 `SSH_CLIENT` 环境变量中获取）以避免抓到 SSH 本身流量。
   - 若指定了 CAPTURE_TIME_SECONDS > 0，使用 `timeout` 在指定秒数后自动终止 tcpdump。
4. 抓包结束后（或被 timeout 结束），使用 `scp` 将远端 pcap 拷贝到本地 `/tmp/...pcap`。
5. 使用 `open`（macOS）或 `xdg-open`（Linux）打开该 pcap 文件（由系统的默认应用处理，通常是 Wireshark）。

---

## 返回值 / 退出码

脚本会通过退出码告知不同类型的失败：
- 0 - 成功
- 1 - 输入时间无效（非整数）
- 2 - 输入目标无效（既不是 IPv4 也不是端口）
- 3 - 抓包失败（tcpdump SSH 命令返回非 0，若返回 124 表示 timeout）
- 4 - 拷贝失败（scp 失败）
- 5 - 打开文件失败（open/xdg-open 失败）

脚本运行时也会打印一些带 emoji 的提示信息用于辅助定位问题（例如 ❌、❗、🎯、✅、🔄 等）。

---

## 常见问题与排错

- 抓包权限被拒绝 / tcpdump: permission denied
  - tcpdump 通常需要 root 权限。可在远端：
    - 使用 sudo（则需要在脚本中修改 SSH 命令为 `sudo tcpdump ...` 或以 root 用户 SSH）
    - 或为 tcpdump 二进制设置能力，例如：`sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump`
- `timeout` 未找到或无效
  - 若使用了 CAPTURE_TIME_SECONDS>0，远端需要有 `timeout` 命令（GNU coreutils）。若没有，可以在远端安装或手动通过 `Ctrl+C` 停止。
- scp 拷贝失败
  - 检查 SSH 认证、目标路径是否存在、磁盘空间及权限。
- 打不开 pcap（本地）
  - 检查系统有没有关联 .pcap 的默认程序（Wireshark）。在 Linux 上 `xdg-open` 需要可用的桌面环境和默认应用。
- `SHELL` 不是 /bin/bash 或 /bin/zsh
  - 脚本中对 IPv4 字符串分割使用了 bash/zsh 专用语法。建议使用 bash 或 zsh 运行脚本（例如 `bash ./t2w.sh ...`）。

---

## 安全与建议

- 远端执行 tcpdump 会生成 pcap 文件在 `/tmp`，应注意清理历史文件，避免泄露敏感数据。
- 如果想在本地直接以 Wireshark 打开而不是依赖系统默认应用，可以将 `open_file` 函数修改为直接调用 `wireshark -r "$LOCAL_FILE_NAME"`（或 `wireshark-gtk` / `shark`，取决于系统）。
- 当前脚本使用带时间戳的文件名，文件名中包含冒号（`:`），在某些文件系统或环境（Windows）可能不兼容。若需要跨平台兼容，可改用不含冒号的时间格式（例如 `%F_%H-%M-%S`）。

---

## 示例（快速参考）

```bash
# 连到远程 example.com，抓取 10.0.0.5 的流量 30 秒
./t2w.sh example.com 10.0.0.5 30

# 连到 192.168.0.5，抓取端口 22（SSH）的流量，直到手动停止
./t2w.sh 192.168.0.5 22 0

# 本地默认主机，抓取本机 127.0.0.1 的流量并打开
./t2w.sh
```

---

## 致谢 / 贡献

如需改进脚本（例如增加 sudo 支持、改用 `ssh -t sudo tcpdump ...`、在远端自动清理临时文件、支持 IPv6、或修复 IPv4 每段 0-255 的严格校验），欢迎提交 PR 或在 issue 中讨论。

许可证请查看仓库根目录（如果有 LICENSE 文件）。
