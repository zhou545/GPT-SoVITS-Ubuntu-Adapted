#!/bin/bash

# GPT-SoVITS Ubuntu设置验证脚本
# 检查迁移后的兼容性和功能

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "$SCRIPT_DIR" || exit 1

# 颜色定义
RESET="\033[0m"
BOLD="\033[1m"
ERROR="\033[1;31m[ERROR]: $RESET"
WARNING="\033[1;33m[WARNING]: $RESET"
INFO="\033[1;32m[INFO]: $RESET"
SUCCESS="\033[1;34m[SUCCESS]: $RESET"

echo -e "${INFO}${BOLD}GPT-SoVITS Ubuntu设置验证${RESET}"
echo "========================================"

# 检查计数器
CHECKS_PASSED=0
CHECKS_TOTAL=0

check_item() {
    local description="$1"
    local command="$2"
    local is_critical="${3:-false}"
    
    CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
    echo -n "检查 $description... "
    
    if eval "$command" &>/dev/null; then
        echo -e "${SUCCESS}通过${RESET}"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
        return 0
    else
        if [ "$is_critical" = "true" ]; then
            echo -e "${ERROR}失败 (关键)${RESET}"
        else
            echo -e "${WARNING}失败${RESET}"
        fi
        return 1
    fi
}

echo -e "${INFO}1. 系统环境检查"
echo "----------------------------------------"

# 检查操作系统
check_item "Linux系统" "uname -s | grep -q Linux" true

# 检查基础命令
check_item "bash shell" "command -v bash" true
check_item "git命令" "command -v git"
check_item "wget命令" "command -v wget"
check_item "curl命令" "command -v curl"

# 检查系统依赖
check_item "ffmpeg" "command -v ffmpeg"
check_item "libsox-dev" "dpkg -l | grep -q libsox-dev"

echo ""
echo -e "${INFO}2. Python环境检查"
echo "----------------------------------------"

# 检查conda
check_item "conda" "command -v conda" true

# 检查Python版本
if command -v python &>/dev/null; then
    PYTHON_VERSION=$(python --version 2>&1 | grep -o "3\.[0-9]\+")
    if [[ "$PYTHON_VERSION" == "3.10" ]] || [[ "$PYTHON_VERSION" == "3.11" ]] || [[ "$PYTHON_VERSION" == "3.9" ]]; then
        check_item "Python版本 ($PYTHON_VERSION)" "true"
    else
        check_item "Python版本 ($PYTHON_VERSION)" "false"
    fi
else
    check_item "Python" "false" true
fi

echo ""
echo -e "${INFO}3. 项目文件检查"
echo "----------------------------------------"

# 检查核心文件
check_item "webui.py" "test -f webui.py" true
check_item "api_v2.py" "test -f api_v2.py" true
check_item "requirements.txt" "test -f requirements.txt" true
check_item "install.sh" "test -f install.sh"

# 检查新创建的Ubuntu文件
check_item "go-webui.sh" "test -f go-webui.sh" true
check_item "api-server.sh" "test -f api_server.sh" true
check_item "install-ubuntu.sh" "test -f install-ubuntu.sh" true
check_item "setup-env.sh" "test -f setup-env.sh"
check_item "requirements-ubuntu.txt" "test -f requirements-ubuntu.txt"
check_item "README-Ubuntu.md" "test -f README-Ubuntu.md"

# 检查脚本权限
check_item "go-webui.sh可执行" "test -x go-webui.sh"
check_item "api-server.sh可执行" "test -x api-server.sh"
check_item "install-ubuntu.sh可执行" "test -x install-ubuntu.sh"
check_item "setup-env.sh可执行" "test -x setup-env.sh"

echo ""
echo -e "${INFO}4. 目录结构检查"
echo "----------------------------------------"

# 检查核心目录
check_item "GPT_SoVITS目录" "test -d GPT_SoVITS" true
check_item "tools目录" "test -d tools" true
check_item "logs目录" "test -d logs || mkdir -p logs"
check_item "output目录" "test -d output || mkdir -p output"
check_item "TEMP目录" "test -d TEMP || mkdir -p TEMP"

echo ""
echo -e "${INFO}5. GPU支持检查"
echo "----------------------------------------"

# 检查NVIDIA GPU
if command -v nvidia-smi &>/dev/null; then
    check_item "NVIDIA驱动" "nvidia-smi"
    check_item "CUDA运行时" "nvidia-smi | grep -q CUDA"
else
    echo "未检测到NVIDIA GPU，将使用CPU模式"
fi

echo ""
echo "========================================"
echo -e "${INFO}验证结果汇总:"
echo "  通过检查: $CHECKS_PASSED/$CHECKS_TOTAL"

if [ $CHECKS_PASSED -eq $CHECKS_TOTAL ]; then
    echo -e "${SUCCESS}${BOLD}所有检查通过！系统已准备就绪。${RESET}"
    echo ""
    echo -e "${INFO}下一步操作:"
    echo "  1. 运行安装脚本: ./install-ubuntu.sh"
    echo "  2. 启动WebUI: ./go-webui.sh"
    echo "  3. 或启动API服务器: ./api-server.sh"
    exit 0
elif [ $CHECKS_PASSED -gt $((CHECKS_TOTAL * 3 / 4)) ]; then
    echo -e "${WARNING}大部分检查通过，但有一些问题需要注意。"
    echo -e "${INFO}请查看上面的警告信息并根据需要进行修复。"
    exit 1
else
    echo -e "${ERROR}${BOLD}检查失败较多，请解决关键问题后重试。${RESET}"
    echo ""
    echo -e "${INFO}常见解决方案:"
    echo "  1. 安装缺失的系统依赖: sudo apt update && sudo apt install -y git wget ffmpeg libsox-dev"
    echo "  2. 安装conda: wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && bash Miniconda3-latest-Linux-x86_64.sh"
    echo "  3. 重新加载shell配置: source ~/.bashrc"
    exit 2
fi