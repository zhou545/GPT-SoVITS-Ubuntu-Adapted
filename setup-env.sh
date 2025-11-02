#!/bin/bash

# GPT-SoVITS 环境配置脚本
# 用于设置运行时环境变量

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# 颜色定义
RESET="\033[0m"
INFO="\033[1;32m[INFO]: $RESET"
SUCCESS="\033[1;34m[SUCCESS]: $RESET"

echo -e "${INFO}配置GPT-SoVITS运行环境..."

# 设置CUDA相关环境变量（如果有GPU）
if command -v nvidia-smi &>/dev/null; then
    echo -e "${INFO}检测到NVIDIA GPU，设置CUDA环境变量"
    export CUDA_VISIBLE_DEVICES=0
    export PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:128
fi

# 设置模型缓存目录
export HF_HOME="$SCRIPT_DIR/models/huggingface"
export TRANSFORMERS_CACHE="$SCRIPT_DIR/models/transformers"
export MODELSCOPE_CACHE="$SCRIPT_DIR/models/modelscope"

# 创建模型目录
mkdir -p "$HF_HOME"
mkdir -p "$TRANSFORMERS_CACHE" 
mkdir -p "$MODELSCOPE_CACHE"

# 设置中文字体路径（避免中文显示问题）
export FONTCONFIG_PATH=/etc/fonts

# 设置临时目录
export TMPDIR="$SCRIPT_DIR/TEMP"
mkdir -p "$TMPDIR"

# 设置日志目录
export LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"

# 设置输出目录
export OUTPUT_DIR="$SCRIPT_DIR/output"
mkdir -p "$OUTPUT_DIR"

# 优化Python性能
export PYTHONUNBUFFERED=1
export PYTHONDONTWRITEBYTECODE=1

# 设置多线程
export OMP_NUM_THREADS=4
export MKL_NUM_THREADS=4

echo -e "${SUCCESS}环境配置完成"
echo -e "${INFO}环境变量已设置:"
echo "  HF_HOME: $HF_HOME"
echo "  TRANSFORMERS_CACHE: $TRANSFORMERS_CACHE"
echo "  MODELSCOPE_CACHE: $MODELSCOPE_CACHE"
echo "  TMPDIR: $TMPDIR"
echo "  LOG_DIR: $LOG_DIR"
echo "  OUTPUT_DIR: $OUTPUT_DIR"

# 如果是source调用，则导出变量到当前shell
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    echo -e "${INFO}环境变量已导出到当前shell"
else
    echo -e "${INFO}要在当前shell中使用这些变量，请运行:"
    echo "  source setup-env.sh"
fi