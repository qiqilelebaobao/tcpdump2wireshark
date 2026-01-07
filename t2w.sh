#!/bin/bash

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
        if [[ $SHELL = "/bin/bash" ]]; then
            IFS='.' read -ra ADDR <<< "$input"
        elif [[ $SHELL = "/bin/zsh" ]]; then
            IFS='.' read -rA ADDR <<< "$input"
        else
            echo "You are using another shell: $SHELL"
            return 0
        fi

#        for i in "${ADDR[@]}"; do
#            if ((i < 0 || i > 255)); then
#                return 0
#            fi
#        done
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
check_wait_time_if_int(){
    if [[ $1 =~ ^(0|[1-9][0-9]*)$ ]]; then
        return 0
    else
        return 1
    fi
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

    scp -q "${host}:${remote_file_name}" "${local_file_name}" || { echo "❗ 拷贝失败: scp 退出码为 $?，无法从 $host 复制 $remote_file_name" >&2; return 1; }
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

    if [[ "$OSTYPE" == "darwin"* ]]; then
        open -n "$file_name" || { echo "无法打开文件: $file_name" >&2; return 1; }
    else
        xdg-open "$file_name" || { echo "无法打开文件: $file_name" >&2; return 1; }
    fi

    return 0
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
capture_and_open(){

    local HOST=${1:-"127.0.0.1"}
    local CAP_HOST_OR_PORT=${2:-"127.0.0.1"}

    local CAP_NAME
    CAP_NAME=${HOST}_$(date +%F_%T)
    
    local REMOTE_FILE_NAME="/tmp/${CAP_NAME}.pcap"
    local LOCAL_FILE_NAME="/tmp/${CAP_NAME}.pcap"

    local CAP_TIME=${3:-"0"}
    local SLEEP_TIME=${4:-"3"}
    local RETVAL=0

    check_wait_time_if_int "$CAP_TIME" || { echo "❌ 输入失败: 输入时间应为正整数 $CAP_TIME" >&2; return 1;}

    check_ip_or_port "$CAP_HOST_OR_PORT"
    local CHECK_RESULT=$?

    # phase1 capture
    case $CHECK_RESULT in
    0)
        echo "❌ 输入失败: 输出参数应为IP地址或者端口" >&2
        return 2
        ;;
    1)
        echo "🎯 开始抓包: 抓包IP $CAP_HOST_OR_PORT ，持续进行，直到ctrl +c 停止..."
        if [[ $CAP_TIME -gt 0 ]]; then
            ssh -q -tt "$HOST" "CLIENT_PORT=\$(env | grep SSH_CLIENT | awk '{print \$2}'); timeout $CAP_TIME tcpdump -i any -w $REMOTE_FILE_NAME host $CAP_HOST_OR_PORT and not port \$CLIENT_PORT"
        else
            ssh -q -tt "$HOST" "CLIENT_PORT=\$(env | grep SSH_CLIENT | awk '{print \$2}'); tcpdump -i any -w $REMOTE_FILE_NAME host $CAP_HOST_OR_PORT and not port \$CLIENT_PORT"
        fi
        ;;
    2)
        echo "🎯 开始抓包: 抓包端口 $CAP_HOST_OR_PORT ，持续进行，直到ctrl +c 停止..."
        if [[ $CAP_TIME -gt 0 ]]; then
            ssh -q -tt "$HOST" "CLIENT_PORT=\$(env | grep SSH_CLIENT | awk '{print \$2}'); timeout $CAP_TIME tcpdump -i any -w $REMOTE_FILE_NAME port $CAP_HOST_OR_PORT and not port \$CLIENT_PORT"
        else
            ssh -q -tt "$HOST" "CLIENT_PORT=\$(env | grep SSH_CLIENT | awk '{print \$2}'); tcpdump -i any -w $REMOTE_FILE_NAME port $CAP_HOST_OR_PORT and not port \$CLIENT_PORT"
        fi
        ;;
    esac

    RETVAL=$?
    if [[ $RETVAL -eq 124 ]]; then
        echo "🔄 超时：tcpdump 超时退出" >&2
    elif [[ $RETVAL -ne 0 ]]; then
        echo "❗ 抓包失败: tcpdump 退出码为$RETVAL" >&2
        return 3
    fi

    check_wait_time_if_int "$SLEEP_TIME" || { echo "❌ 输入失败: 输入等待时间应为整数 $SLEEP_TIME" >&2; return 1;}
    echo ""

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


