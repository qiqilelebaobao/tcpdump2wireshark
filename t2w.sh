#!/usr/bin/env bash

# =============================================================================
# 函数名称: check_ip_or_port
# 功能描述: 判断输入是 IPv4 地址、端口还是其他内容
# 参数说明:
#   $1: 输入的字符串
# 返回值:
#   0 - 输入既不是 IPv4 地址也不是端口
#   1 - 输入是 IPv4 地址
#   2 - 输入是端口
# =============================================================================

check_ip_or_port() {
    local input="$1"
    local ip_regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"
    local port_regex="^[0-9]+$"

    # 检查是否为 IPv4 地址
    if [[ "$input" =~ $ip_regex ]]; then
        # 检查每个段是否在 0-255 范围内
        IFS='.' read -ra ADDR <<< "$input"
        for i in "${ADDR[@]}"; do
            if (("$i" < 0 || "$i" > 255)); then
                return 0
            fi
        done
        return 1
    fi

    # 检查是否为端口
    if [[ "$input" =~ $port_regex ]]; then
        # 检查端口号是否在 0-65535 范围内
        if ((input >= 0 && input <= 65535)); then
            return 2
        fi
    fi

    # 如果都不是，返回 0
    return 0
}

# =============================================================================
# 检查输入参数是否为正整数或零
# 参数：
#   $1 - 输入的数字，需要检查是否为正整数或零
# 返回值：
#   0 - 如果输入是正整数或零
#   1 - 如果输入不是正整数或零
# =============================================================================
check_wait_time_if_int() {
    if [[ $1 =~ ^(0|[1-9][0-9]*)$ ]]; then
        return 0
    else
        return 1
    fi
}

# =============================================================================
# 验证整数参数并输出错误信息
# 参数：
#   $1 - 输入的值
#   $2 - 参数描述（用于错误信息）
# 返回值：
#   0 - 验证成功
#   1 - 验证失败
# =============================================================================
validate_integer_parameter() {
    local value="$1"
    local param_description="$2"
    
    check_wait_time_if_int "$value" || {
        echo "❌ 输入失败: $param_description 应为正整数，但输入的是 $value" >&2
        return 1
    }
    return 0
}

# =============================================================================
# 执行拷贝操作
# 参数：
#   $1 - 远程主机地址
#   $2 - 远程文件名
#   $3 - 本地文件名
# 返回值：
#   0 - 成功
#   1 - 拷贝失败
# =============================================================================
copy_file() {
    local host="$1"
    local remote_file_name="$2"
    local local_file_name="$3"

    scp -q "${host}:${remote_file_name}" "${local_file_name}" || {
        echo "❗ 拷贝失败: scp 退出码为 $?，无法从 $host 复制 $remote_file_name" >&2
        return 1
    }
    return 0
}

# =============================================================================
# 执行打开文件操作
# 参数：
#   $1 - 本地文件名
# 返回值：
#   0 - 成功
#   1 - 打开失败
# =============================================================================
open_file() {
    local file_name="$1"
    local open_cmd

    if [[ "$OSTYPE" == "darwin"* ]]; then
        open_cmd="open -n"
    else
        open_cmd="xdg-open"
    fi

    $open_cmd "$file_name" || {
        echo "无法打开文件: $file_name" >&2
        return 1
    }

    return 0
}

check_live() {
    local input="$1"
    if [[ "$input" =~ ^live$ ]]; then
        return 0
    else
        return 1
    fi
}

# =============================================================================
# 构建 tcpdump 过滤器字符串
# 参数：
#   $1 - check_ip_or_port 的返回值 (0=其他, 1=IP, 2=端口)
#   $2 - 目标值（IP地址、端口或其他）
#   $3 - 是否需要排除客户端端口 (0=需要, 1=不需要)
# 返回值：
#   输出过滤器字符串
# =============================================================================
build_tcpdump_filter() {
    local check_result="$1"
    local target="$2"
    local exclude_client_port="$3"
    
    case $check_result in
    0)
        echo "$target"
        ;;
    1)
        if [[ "$exclude_client_port" == "0" ]]; then
            echo "host $target and not port \$CLIENT_PORT"
        else
            echo "host $target"
        fi
        ;;
    2)
        if [[ "$exclude_client_port" == "0" ]]; then
            echo "port $target and not port \$CLIENT_PORT"
        else
            echo "port $target"
        fi
        ;;
    esac
}

# =============================================================================
# 执行实时抓包并传输到 Wireshark
# 参数：
#   $1 - 主机地址
#   $2 - tcpdump 过滤器字符串
# 返回值：
#   SSH 命令的退出码
# =============================================================================
execute_live_capture() {
    local host="$1"
    local filter="$2"
    
    echo "🎯 开始抓包: 实时抓包，持续进行，直到ctrl +c 停止..."
    ssh -q "$host" "sudo tcpdump -s 0 -U -i any $filter -w -" | wireshark -k -i -
}

# =============================================================================
# 执行 SSH tcpdump 命令（带可选超时）
# 参数：
#   $1 - 主机地址
#   $2 - 抓包时长（0 表示持续直到 Ctrl+C）
#   $3 - 远程文件名
#   $4 - tcpdump 过滤器字符串
# 返回值：
#   SSH 命令的退出码
# =============================================================================
execute_ssh_tcpdump() {
    local host="$1"
    local cap_time="$2"
    local remote_file="$3"
    local filter="$4"
    
    local timeout_cmd=""
    if [[ $cap_time -gt 0 ]]; then
        timeout_cmd="timeout $cap_time"
    fi
    
    ssh -q -tt "$host" "CLIENT_PORT=\$(echo \$SSH_CLIENT | awk '{print \$2}'); $timeout_cmd sudo tcpdump -i any -w $remote_file $filter"
}

# =============================================================================
# 函数名称: capture_and_open
# 功能描述: 通过SSH在远程主机抓包，将pcap文件传输到本地并自动打开分析
# 参数说明:
#   $1: 远程连接的主机地址 (默认: 127.0.0.1)
#   $2: 抓包时指定的目标主机或者端口 (默认: 127.0.0.1)
#   $3: 抓包等待时间 (默认: 持续)
#   $4: 打开文件等待时间 (默认: 3s)
# 返回值:
#   0 - 成功
#   1 - 输入时间无效
#   2 - 输入目标
#   3 - 抓包失败
#   4 - 拷贝失败
#   5 - 文件打开失败
# =============================================================================
capture_and_open() {

    local HOST=${1:-"127.0.0.1"}
    local CAP_HOST_OR_PORT=${2:-""}

    local CAP_NAME
    CAP_NAME=${HOST}_$(date +%F_%H%M%S)

    local REMOTE_FILE_NAME="/tmp/${CAP_NAME}.pcap"
    local LOCAL_FILE_NAME="/tmp/${CAP_NAME}.pcap"

    local CAP_TIME=${3:-"0"}
    local SLEEP_TIME=${4:-"1"}
    local IF_LIVE=${5:-"not_live"}
    local RETVAL=0

    # 使用新的验证函数，减少重复代码
    validate_integer_parameter "$CAP_TIME" "输入时间" || return 1
    validate_integer_parameter "$SLEEP_TIME" "输入等待时间" || return 1

    check_live "$IF_LIVE"
    local IS_LIVE=$?

    check_ip_or_port "$CAP_HOST_OR_PORT"
    local CHECK_RESULT=$?

    # phase1 capture
    # 判断是否为实时模式
    if [[ $IS_LIVE -eq 0 ]]; then
        local filter
        filter=$(build_tcpdump_filter "$CHECK_RESULT" "$CAP_HOST_OR_PORT" "1")
        execute_live_capture "$HOST" "$filter"
        return 0
    fi

    # 非实时模式：构建过滤器并执行抓包
    local filter
    filter=$(build_tcpdump_filter "$CHECK_RESULT" "$CAP_HOST_OR_PORT" "0")
    
    case $CHECK_RESULT in
    0)
        echo "🎯 开始抓包: 抓包，持续进行，直到ctrl +c 停止..."
        ;;
    1)
        echo "🎯 开始抓包: 抓包IP $CAP_HOST_OR_PORT ，持续进行，直到ctrl +c 停止..."
        ;;
    2)
        echo "🎯 开始抓包: 抓包端口 $CAP_HOST_OR_PORT ，持续进行，直到ctrl +c 停止..."
        ;;
    esac
    
    execute_ssh_tcpdump "$HOST" "$CAP_TIME" "$REMOTE_FILE_NAME" "$filter"
    RETVAL=$?
    
    if [[ $RETVAL -eq 124 ]]; then
        echo "🔄 超时：tcpdump 超时退出" >&2
    elif [[ $RETVAL -ne 0 ]]; then
        echo "❗ 抓包失败: tcpdump 退出码为$RETVAL" >&2
        return 3
    fi
    sleep "$SLEEP_TIME"

    # phase2 copy
    printf "🎯 开始拷贝: 来自主机 %s \n🎯 远程文件名：%s -> 本地文件名：%s \n🎯 直到ctrl +c 停止..." "$HOST" "$REMOTE_FILE_NAME" "$LOCAL_FILE_NAME"

    copy_file "$HOST" "$REMOTE_FILE_NAME" "$LOCAL_FILE_NAME" || return 4
    echo ""

    # phase3 open
    echo "🎯 打开文件: 目标文件 $LOCAL_FILE_NAME"

    open_file "$LOCAL_FILE_NAME" || return 5
    echo ""

    echo "✅ 完成任务"
    echo ""

    return 0
}

# =============================================================================
# 函数名称: main
# 功能描述: 提供一个入口函数，允许用户选择执行不同的功能
# 参数说明:
#   无
# 返回值:
#   无
# =============================================================================
main() {
    if [[ $# -gt 0 ]]; then
        capture_and_open "$@"
    fi
}

# 调用 main 函数
main "$@"
