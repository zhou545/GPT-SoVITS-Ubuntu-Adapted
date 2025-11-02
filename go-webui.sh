#!/bin/bash

# GPT-SoVITS WebUI启动脚本 - Linux版本
# 适用于Ubuntu系统

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "$SCRIPT_DIR" || exit 1

# 颜色定义
RESET="\033[0m"
BOLD="\033[1m"
ERROR="\033[1;31m[ERROR]: $RESET"
INFO="\033[1;32m[INFO]: $RESET"
SUCCESS="\033[1;34m[SUCCESS]: $RESET"

echo -e "${INFO}启动 GPT-SoVITS WebUI..."

# 检查conda环境
if ! command -v conda &>/dev/null; then
    echo -e "${ERROR}未找到conda，请先安装Anaconda或Miniconda"
    exit 1
fi

# 配置运行环境
if [ -f "setup-env.sh" ]; then
    echo -e "${INFO}加载环境配置..."
    source setup-env.sh
fi

# 激活conda环境
ENV_NAME="GPTSoVits"
if conda info --envs | grep -q "^$ENV_NAME "; then
    echo -e "${INFO}激活conda环境: $ENV_NAME"
    source "$(conda info --base)/etc/profile.d/conda.sh"
    conda activate "$ENV_NAME"
else
    echo -e "${ERROR}未找到conda环境 '$ENV_NAME'"
    echo -e "${INFO}请先运行 './install-ubuntu.sh' 安装环境"
    exit 1
fi

# 检查Python
if ! command -v python &>/dev/null; then
    echo -e "${ERROR}Python未找到"
    exit 1
fi

# 启动WebUI
echo -e "${INFO}启动WebUI界面..."
python webui.py zh_CN

echo -e "${SUCCESS}WebUI已关闭"