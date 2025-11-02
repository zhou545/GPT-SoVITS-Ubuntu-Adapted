#!/bin/bash

# GPT-SoVITS 优云智算平台一键启动脚本
# 适用于Ubuntu系统

# 颜色定义
RESET="\033[0m"
BOLD="\033[1m"
ERROR="\033[1;31m[ERROR]: $RESET"
WARNING="\033[1;33m[WARNING]: $RESET"
INFO="\033[1;32m[INFO]: $RESET"
SUCCESS="\033[1;34m[SUCCESS]: $RESET"

echo -e "${BOLD}=== GPT-SoVITS 优云智算平台快速启动 ===$RESET"
echo ""

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "$SCRIPT_DIR" || exit 1

# 检查基础环境
echo -e "${INFO}检查系统环境..."

# 检查conda
if ! command -v conda &> /dev/null; then
    echo -e "${ERROR}Conda未安装，请先安装Anaconda或Miniconda"
    echo -e "${INFO}安装命令："
    echo "  wget https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh"
    echo "  chmod +x Anaconda3-2024.10-1-Linux-x86_64.sh"
    echo "  ./Anaconda3-2024.10-1-Linux-x86_64.sh"
    exit 1
fi

# 检查GPU
echo -e "${INFO}检查GPU状态..."
if nvidia-smi &> /dev/null; then
    GPU_INFO=$(nvidia-smi --query-gpu=name,memory.total --format=csv,noheader,nounits | head -1)
    echo -e "${SUCCESS}GPU可用: $GPU_INFO"
else
    echo -e "${WARNING}GPU不可用，将使用CPU模式"
fi

# 检查conda环境
ENV_NAME="GPTSoVits"
echo -e "${INFO}检查conda环境: $ENV_NAME"

if ! conda info --envs | grep -q "^$ENV_NAME "; then
    echo -e "${WARNING}未找到conda环境 '$ENV_NAME'"
    echo -e "${INFO}正在运行安装脚本..."
    
    if [ -f "install-ubuntu.sh" ]; then
        chmod +x install-ubuntu.sh
        echo -e "${INFO}开始安装环境（这可能需要20-60分钟）..."
        ./install-ubuntu.sh --device CU128 --source HF-Mirror --download-uvr5
        
        if [ $? -eq 0 ]; then
            echo -e "${SUCCESS}环境安装完成"
        else
            echo -e "${ERROR}环境安装失败"
            exit 1
        fi
    else
        echo -e "${ERROR}未找到install-ubuntu.sh安装脚本"
        exit 1
    fi
fi

# 激活conda环境
echo -e "${INFO}激活conda环境..."
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "$ENV_NAME"

if [ $? -ne 0 ]; then
    echo -e "${ERROR}无法激活conda环境"
    exit 1
fi

# 检查Python和依赖
echo -e "${INFO}检查Python环境..."
python_version=$(python --version 2>&1)
echo -e "${INFO}Python版本: $python_version"

# 检查PyTorch
if python -c "import torch; print('PyTorch版本:', torch.__version__)" 2>/dev/null; then
    if python -c "import torch; print('CUDA可用:', torch.cuda.is_available())" 2>/dev/null; then
        echo -e "${SUCCESS}PyTorch和CUDA环境正常"
    else
        echo -e "${WARNING}PyTorch已安装但CUDA不可用"
    fi
else
    echo -e "${ERROR}PyTorch未正确安装"
    exit 1
fi

# 显示启动选项
echo ""
echo -e "${BOLD}请选择启动模式:$RESET"
echo "1) WebUI界面 (推荐新手使用)"
echo "2) API服务器 (供其他软件调用)"
echo "3) 简洁API接口 (对应Windows接口.bat)"
echo "4) 系统检查"
echo "5) 退出"
echo ""

while true; do
    read -p "请输入选择 (1-5): " choice
    case $choice in
        1)
            echo -e "${INFO}启动WebUI界面..."
            if [ -f "go-webui.sh" ]; then
                chmod +x go-webui.sh
                ./go-webui.sh
            else
                echo -e "${ERROR}未找到go-webui.sh脚本"
            fi
            break
            ;;
        2)
            echo -e "${INFO}启动API服务器..."
            if [ -f "api-server.sh" ]; then
                chmod +x api-server.sh
                ./api-server.sh
            else
                echo -e "${ERROR}未找到api-server.sh脚本"
            fi
            break
            ;;
        3)
            echo -e "${INFO}启动简洁API接口..."
            if [ -f "接口.sh" ]; then
                chmod +x 接口.sh
                ./接口.sh
            else
                echo -e "${ERROR}未找到接口.sh脚本"
            fi
            break
            ;;
        4)
            echo -e "${INFO}运行系统检查..."
            if [ -f "check-ubuntu-setup.sh" ]; then
                chmod +x check-ubuntu-setup.sh
                ./check-ubuntu-setup.sh
            else
                echo -e "${ERROR}未找到check-ubuntu-setup.sh脚本"
            fi
            echo ""
            echo "按任意键继续..."
            read -n 1 -s
            ;;
        5)
            echo -e "${INFO}退出程序"
            exit 0
            ;;
        *)
            echo -e "${WARNING}无效选择，请输入1-5"
            ;;
    esac
done

echo -e "${SUCCESS}程序已启动完成！"