#!/bin/bash
# GPT-SoVITS 模型下载脚本 (Linux/macOS版本)
# 此脚本用于下载项目运行所需的所有预训练模型

# 默认参数
SOURCE="HF-Mirror"
SKIP_PRETRAINED=false
SKIP_UVR5=false
SKIP_ASR=false
SKIP_G2PW=false

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --source)
            SOURCE="$2"
            shift 2
            ;;
        --skip-pretrained)
            SKIP_PRETRAINED=true
            shift
            ;;
        --skip-uvr5)
            SKIP_UVR5=true
            shift
            ;;
        --skip-asr)
            SKIP_ASR=true
            shift
            ;;
        --skip-g2pw)
            SKIP_G2PW=true
            shift
            ;;
        -h|--help)
            echo "用法: $0 [选项]"
            echo "选项:"
            echo "  --source SOURCE     下载源 (HF, HF-Mirror, ModelScope) [默认: HF-Mirror]"
            echo "  --skip-pretrained   跳过预训练模型下载"
            echo "  --skip-uvr5         跳过UVR5模型下载"
            echo "  --skip-asr          跳过ASR模型下载"
            echo "  --skip-g2pw         跳过G2PW模型下载"
            echo "  -h, --help          显示此帮助信息"
            exit 0
            ;;
        *)
            echo "未知参数: $1"
            exit 1
            ;;
    esac
done

# 颜色输出函数
info() {
    echo -e "\033[36m[INFO]\033[0m $1"
}

success() {
    echo -e "\033[32m[SUCCESS]\033[0m $1"
}

error() {
    echo -e "\033[31m[ERROR]\033[0m $1"
}

warning() {
    echo -e "\033[33m[WARNING]\033[0m $1"
}

# 下载函数
download_file() {
    local url=$1
    local output=$2
    
    info "正在下载: $output"
    if command -v wget >/dev/null 2>&1; then
        wget -O "$output" "$url"
    elif command -v curl >/dev/null 2>&1; then
        curl -L -o "$output" "$url"
    else
        error "未找到 wget 或 curl，无法下载文件"
        return 1
    fi
    
    if [ $? -eq 0 ]; then
        success "下载完成: $output"
        return 0
    else
        error "下载失败: $output"
        return 1
    fi
}

# 解压函数
extract_file() {
    local archive=$1
    local destination=$2
    
    info "正在解压: $archive 到 $destination"
    
    case "$archive" in
        *.zip)
            unzip -q -o "$archive" -d "$destination"
            ;;
        *.tar.gz)
            tar -xzf "$archive" -C "$destination"
            ;;
        *)
            error "不支持的压缩格式: $archive"
            return 1
            ;;
    esac
    
    if [ $? -eq 0 ]; then
        rm -f "$archive"
        success "解压完成: $archive"
        return 0
    else
        error "解压失败: $archive"
        return 1
    fi
}

# 根据源设置下载URL
case "$SOURCE" in
    "HF")
        info "使用 HuggingFace 源下载模型"
        PRETRAINED_URL="https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/pretrained_models.zip"
        G2PW_URL="https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/G2PWModel.zip"
        UVR5_URL="https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/uvr5_weights.zip"
        NLTK_URL="https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/nltk_data.zip"
        ASR_URL="https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/asr_models.zip"
        ;;
    "HF-Mirror")
        info "使用 HuggingFace-Mirror 源下载模型"
        PRETRAINED_URL="https://hf-mirror.com/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/pretrained_models.zip"
        G2PW_URL="https://hf-mirror.com/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/G2PWModel.zip"
        UVR5_URL="https://hf-mirror.com/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/uvr5_weights.zip"
        NLTK_URL="https://hf-mirror.com/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/nltk_data.zip"
        ASR_URL="https://hf-mirror.com/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/asr_models.zip"
        ;;
    "ModelScope")
        info "使用 ModelScope 源下载模型"
        PRETRAINED_URL="https://www.modelscope.cn/models/XXXXRT/GPT-SoVITS-Pretrained/resolve/master/pretrained_models.zip"
        G2PW_URL="https://www.modelscope.cn/models/XXXXRT/GPT-SoVITS-Pretrained/resolve/master/G2PWModel.zip"
        UVR5_URL="https://www.modelscope.cn/models/XXXXRT/GPT-SoVITS-Pretrained/resolve/master/uvr5_weights.zip"
        NLTK_URL="https://www.modelscope.cn/models/XXXXRT/GPT-SoVITS-Pretrained/resolve/master/nltk_data.zip"
        ASR_URL="https://www.modelscope.cn/models/XXXXRT/GPT-SoVITS-Pretrained/resolve/master/asr_models.zip"
        ;;
    *)
        error "不支持的源: $SOURCE"
        exit 1
        ;;
esac

info "开始下载 GPT-SoVITS 所需的模型文件..."
info "使用源: $SOURCE"

# 1. 下载预训练模型 (4.2GB)
if [ "$SKIP_PRETRAINED" = false ]; then
    if [ ! -d "GPT_SoVITS/pretrained_models/sv" ]; then
        info "下载预训练模型 (约 4.2GB)..."
        if download_file "$PRETRAINED_URL" "pretrained_models.zip"; then
            extract_file "pretrained_models.zip" "GPT_SoVITS"
            success "预训练模型下载完成"
        else
            error "预训练模型下载失败"
            exit 1
        fi
    else
        info "预训练模型已存在，跳过下载"
    fi
else
    warning "跳过预训练模型下载"
fi

# 2. 下载G2PW模型
if [ "$SKIP_G2PW" = false ]; then
    if [ ! -d "GPT_SoVITS/text/G2PWModel" ]; then
        info "下载G2PW模型..."
        if download_file "$G2PW_URL" "G2PWModel.zip"; then
            extract_file "G2PWModel.zip" "GPT_SoVITS/text"
            success "G2PW模型下载完成"
        else
            error "G2PW模型下载失败"
            exit 1
        fi
    else
        info "G2PW模型已存在，跳过下载"
    fi
else
    warning "跳过G2PW模型下载"
fi

# 3. 下载UVR5模型 (718MB)
if [ "$SKIP_UVR5" = false ]; then
    if [ ! -d "tools/uvr5/uvr5_weights" ]; then
        info "下载UVR5模型 (约 718MB)..."
        if download_file "$UVR5_URL" "uvr5_weights.zip"; then
            extract_file "uvr5_weights.zip" "tools/uvr5"
            success "UVR5模型下载完成"
        else
            error "UVR5模型下载失败"
            exit 1
        fi
    else
        info "UVR5模型已存在，跳过下载"
    fi
else
    warning "跳过UVR5模型下载"
fi

# 4. 下载ASR模型 (1.1GB)
if [ "$SKIP_ASR" = false ]; then
    if [ ! -d "tools/asr/models" ]; then
        info "下载ASR模型 (约 1.1GB)..."
        if download_file "$ASR_URL" "asr_models.zip"; then
            extract_file "asr_models.zip" "tools/asr"
            success "ASR模型下载完成"
        else
            warning "ASR模型下载失败，可能需要手动下载"
            info "请访问以下链接手动下载ASR模型:"
            info "- Whisper模型: https://huggingface.co/openai/whisper-large-v3"
            info "- FunASR模型: https://www.modelscope.cn/models/iic/speech_seaco_paraformer_large_asr_nat-zh-cn-16k-common-vocab8404-pytorch"
        fi
    else
        info "ASR模型已存在，跳过下载"
    fi
else
    warning "跳过ASR模型下载"
fi

# 5. 下载NLTK数据
if [ ! -d "nltk_data" ]; then
    info "下载NLTK数据..."
    if download_file "$NLTK_URL" "nltk_data.zip"; then
        extract_file "nltk_data.zip" "."
        success "NLTK数据下载完成"
    else
        warning "NLTK数据下载失败，程序仍可正常运行"
    fi
else
    info "NLTK数据已存在，跳过下载"
fi

success "模型下载完成！"
info "总下载大小约: 6GB"
info "如果某些模型下载失败，请检查网络连接或尝试不同的源"
info ""
info "使用方法:"
info "  下载所有模型: ./download_models.sh"
info "  使用HF源: ./download_models.sh --source HF"
info "  跳过UVR5模型: ./download_models.sh --skip-uvr5"
info "  跳过ASR模型: ./download_models.sh --skip-asr"