#!/bin/bash

# GPT-SoVITS Ubuntu安装脚本
# 专为Ubuntu系统优化的一键安装脚本

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

set -eE
set -o errtrace

trap 'on_error $LINENO "$BASH_COMMAND" $?' ERR

# 错误处理函数
on_error() {
    local lineno="$1"
    local cmd="$2"
    local code="$3"

    echo -e "${ERROR}${BOLD}命令 \"${cmd}\" 失败${RESET} 在第 ${BOLD}${lineno}${RESET} 行，退出代码 ${BOLD}${code}${RESET}"
    exit "$code"
}

# 默认参数
DEVICE="CU128"  # 默认使用CUDA 12.8
SOURCE="HF"     # 默认使用HuggingFace
DOWNLOAD_UVR5=false
ENV_NAME="GPTSoVits"

print_help() {
    echo "GPT-SoVITS Ubuntu安装脚本"
    echo ""
    echo "用法: bash install-ubuntu.sh [选项]"
    echo ""
    echo "选项:"
    echo "  --device   CU126|CU128|CPU        指定设备类型 (默认: CU128)"
    echo "  --source   HF|HF-Mirror|ModelScope 指定模型源 (默认: HF)"
    echo "  --download-uvr5                   下载UVR5模型"
    echo "  --env-name NAME                   指定conda环境名称 (默认: GPTSoVits)"
    echo "  -h, --help                        显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  bash install-ubuntu.sh --device CU128 --source HF --download-uvr5"
    echo "  bash install-ubuntu.sh --device CPU --source ModelScope"
}

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case "$1" in
    --device)
        DEVICE="$2"
        shift 2
        ;;
    --source)
        SOURCE="$2"
        shift 2
        ;;
    --env-name)
        ENV_NAME="$2"
        shift 2
        ;;
    --download-uvr5)
        DOWNLOAD_UVR5=true
        shift
        ;;
    -h|--help)
        print_help
        exit 0
        ;;
    *)
        echo -e "${ERROR}未知参数: $1"
        print_help
        exit 1
        ;;
    esac
done

echo -e "${INFO}${BOLD}GPT-SoVITS Ubuntu安装脚本${RESET}"
echo -e "${INFO}设备类型: $DEVICE"
echo -e "${INFO}模型源: $SOURCE"
echo -e "${INFO}环境名称: $ENV_NAME"
echo -e "${INFO}下载UVR5: $DOWNLOAD_UVR5"
echo ""

# 检查系统要求
echo -e "${INFO}检查系统要求..."

# 检查Ubuntu版本
if ! grep -q "Ubuntu" /etc/os-release; then
    echo -e "${WARNING}此脚本专为Ubuntu设计，其他Linux发行版可能需要调整"
fi

# 检查conda
if ! command -v conda &>/dev/null; then
    echo -e "${ERROR}未找到conda，请先安装Anaconda或Miniconda"
    echo -e "${INFO}安装命令:"
    echo "  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    echo "  bash Miniconda3-latest-Linux-x86_64.sh"
    exit 1
fi

# 检查系统依赖
echo -e "${INFO}检查系统依赖..."
MISSING_DEPS=()

if ! command -v git &>/dev/null; then
    MISSING_DEPS+=("git")
fi

if ! command -v wget &>/dev/null; then
    MISSING_DEPS+=("wget")
fi

if ! command -v ffmpeg &>/dev/null; then
    MISSING_DEPS+=("ffmpeg")
fi

if ! dpkg -l | grep -q libsox-dev; then
    MISSING_DEPS+=("libsox-dev")
fi

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo -e "${WARNING}缺少以下系统依赖: ${MISSING_DEPS[*]}"
    echo -e "${INFO}正在安装系统依赖..."
    sudo apt update
    sudo apt install -y "${MISSING_DEPS[@]}"
fi

# 创建conda环境
echo -e "${INFO}创建conda环境: $ENV_NAME"
if conda info --envs | grep -q "^$ENV_NAME "; then
    echo -e "${WARNING}环境 $ENV_NAME 已存在，将删除并重新创建"
    conda env remove -n "$ENV_NAME" -y
fi

conda create -n "$ENV_NAME" python=3.10 -y
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "$ENV_NAME"

# 安装PyTorch
echo -e "${INFO}安装PyTorch..."
case "$DEVICE" in
    CU126)
        conda install pytorch torchvision torchaudio pytorch-cuda=12.6 -c pytorch -c nvidia -y
        ;;
    CU128)
        conda install pytorch torchvision torchaudio pytorch-cuda=12.8 -c pytorch -c nvidia -y
        ;;
    CPU)
        conda install pytorch torchvision torchaudio cpuonly -c pytorch -y
        ;;
    *)
        echo -e "${ERROR}不支持的设备类型: $DEVICE"
        exit 1
        ;;
esac

# 安装Python依赖
echo -e "${INFO}安装Python依赖..."
pip install -r extra-req.txt --no-deps

# 优先使用Ubuntu优化版requirements，如果不存在则使用原版
if [ -f "requirements-ubuntu.txt" ]; then
    echo -e "${INFO}使用Ubuntu优化版依赖文件..."
    pip install -r requirements-ubuntu.txt
else
    echo -e "${INFO}使用原版依赖文件..."
    pip install -r requirements.txt
fi

# 设置模型源
case "$SOURCE" in
    HF-Mirror)
        export HF_ENDPOINT=https://hf-mirror.com
        ;;
    ModelScope)
        export MODELSCOPE_CACHE=./models
        ;;
esac

# 下载UVR5模型（如果需要）
if [ "$DOWNLOAD_UVR5" = true ]; then
    echo -e "${INFO}下载UVR5模型..."
    python -c "
import os
os.makedirs('tools/uvr5/uvr5_weights', exist_ok=True)
print('UVR5模型目录已创建，请手动下载所需模型')
"
fi

# 设置脚本权限
echo -e "${INFO}设置脚本权限..."
chmod +x go-webui.sh
chmod +x api-server.sh
chmod +x install-ubuntu.sh

echo -e "${SUCCESS}${BOLD}安装完成！${RESET}"
echo ""
echo -e "${INFO}使用方法:"
echo "  启动WebUI: ./go-webui.sh"
echo "  启动API服务器: ./api-server.sh"
echo ""
echo -e "${INFO}注意事项:"
echo "  1. 首次运行可能需要下载模型文件"
echo "  2. 确保有足够的磁盘空间存储模型"
echo "  3. 如果使用GPU，请确保NVIDIA驱动已正确安装"