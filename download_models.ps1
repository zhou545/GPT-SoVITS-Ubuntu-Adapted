# GPT-SoVITS 模型下载脚本
# 此脚本用于下载项目运行所需的所有预训练模型

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("HF", "HF-Mirror", "ModelScope")]
    [string]$Source = "HF-Mirror",
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipPretrained,
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipUVR5,
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipASR,
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipG2PW
)

# 颜色输出函数
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

# 下载函数
function Invoke-Download {
    param(
        [string]$Uri,
        [string]$OutFile
    )
    try {
        Write-Info "正在下载: $OutFile"
        Invoke-WebRequest -Uri $Uri -OutFile $OutFile -UseBasicParsing
        Write-Success "下载完成: $OutFile"
    }
    catch {
        Write-Error "下载失败: $OutFile - $($_.Exception.Message)"
        throw
    }
}

# 解压函数
function Invoke-Unzip {
    param(
        [string]$ZipFile,
        [string]$Destination
    )
    try {
        Write-Info "正在解压: $ZipFile 到 $Destination"
        Expand-Archive -Path $ZipFile -DestinationPath $Destination -Force
        Remove-Item $ZipFile -Force
        Write-Success "解压完成: $ZipFile"
    }
    catch {
        Write-Error "解压失败: $ZipFile - $($_.Exception.Message)"
        throw
    }
}

# 根据源设置下载URL
switch ($Source) {
    "HF" {
        Write-Info "使用 HuggingFace 源下载模型"
        $PretrainedURL = "https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/pretrained_models.zip"
        $G2PWURL       = "https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/G2PWModel.zip"
        $UVR5URL       = "https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/uvr5_weights.zip"
        $NLTKURL       = "https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/nltk_data.zip"
        $ASRURL        = "https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/asr_models.zip"
    }
    "HF-Mirror" {
        Write-Info "使用 HuggingFace-Mirror 源下载模型"
        $PretrainedURL = "https://hf-mirror.com/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/pretrained_models.zip"
        $G2PWURL       = "https://hf-mirror.com/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/G2PWModel.zip"
        $UVR5URL       = "https://hf-mirror.com/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/uvr5_weights.zip"
        $NLTKURL       = "https://hf-mirror.com/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/nltk_data.zip"
        $ASRURL        = "https://hf-mirror.com/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/asr_models.zip"
    }
    "ModelScope" {
        Write-Info "使用 ModelScope 源下载模型"
        $PretrainedURL = "https://www.modelscope.cn/models/XXXXRT/GPT-SoVITS-Pretrained/resolve/master/pretrained_models.zip"
        $G2PWURL       = "https://www.modelscope.cn/models/XXXXRT/GPT-SoVITS-Pretrained/resolve/master/G2PWModel.zip"
        $UVR5URL       = "https://www.modelscope.cn/models/XXXXRT/GPT-SoVITS-Pretrained/resolve/master/uvr5_weights.zip"
        $NLTKURL       = "https://www.modelscope.cn/models/XXXXRT/GPT-SoVITS-Pretrained/resolve/master/nltk_data.zip"
        $ASRURL        = "https://www.modelscope.cn/models/XXXXRT/GPT-SoVITS-Pretrained/resolve/master/asr_models.zip"
    }
}

Write-Info "开始下载 GPT-SoVITS 所需的模型文件..."
Write-Info "使用源: $Source"

# 1. 下载预训练模型 (4.2GB)
if (-not $SkipPretrained) {
    if (-not (Test-Path "GPT_SoVITS/pretrained_models/sv")) {
        Write-Info "下载预训练模型 (约 4.2GB)..."
        try {
            Invoke-Download -Uri $PretrainedURL -OutFile "pretrained_models.zip"
            Invoke-Unzip "pretrained_models.zip" "GPT_SoVITS"
            Write-Success "预训练模型下载完成"
        }
        catch {
            Write-Error "预训练模型下载失败"
            exit 1
        }
    } else {
        Write-Info "预训练模型已存在，跳过下载"
    }
} else {
    Write-Warning "跳过预训练模型下载"
}

# 2. 下载G2PW模型
if (-not $SkipG2PW) {
    if (-not (Test-Path "GPT_SoVITS/text/G2PWModel")) {
        Write-Info "下载G2PW模型..."
        try {
            Invoke-Download -Uri $G2PWURL -OutFile "G2PWModel.zip"
            Invoke-Unzip "G2PWModel.zip" "GPT_SoVITS/text"
            Write-Success "G2PW模型下载完成"
        }
        catch {
            Write-Error "G2PW模型下载失败"
            exit 1
        }
    } else {
        Write-Info "G2PW模型已存在，跳过下载"
    }
} else {
    Write-Warning "跳过G2PW模型下载"
}

# 3. 下载UVR5模型 (718MB)
if (-not $SkipUVR5) {
    if (-not (Test-Path "tools/uvr5/uvr5_weights")) {
        Write-Info "下载UVR5模型 (约 718MB)..."
        try {
            Invoke-Download -Uri $UVR5URL -OutFile "uvr5_weights.zip"
            Invoke-Unzip "uvr5_weights.zip" "tools/uvr5"
            Write-Success "UVR5模型下载完成"
        }
        catch {
            Write-Error "UVR5模型下载失败"
            exit 1
        }
    } else {
        Write-Info "UVR5模型已存在，跳过下载"
    }
} else {
    Write-Warning "跳过UVR5模型下载"
}

# 4. 下载ASR模型 (1.1GB)
if (-not $SkipASR) {
    if (-not (Test-Path "tools/asr/models")) {
        Write-Info "下载ASR模型 (约 1.1GB)..."
        try {
            Invoke-Download -Uri $ASRURL -OutFile "asr_models.zip"
            Invoke-Unzip "asr_models.zip" "tools/asr"
            Write-Success "ASR模型下载完成"
        }
        catch {
            Write-Warning "ASR模型下载失败，可能需要手动下载"
            Write-Info "请访问以下链接手动下载ASR模型:"
            Write-Info "- Whisper模型: https://huggingface.co/openai/whisper-large-v3"
            Write-Info "- FunASR模型: https://www.modelscope.cn/models/iic/speech_seaco_paraformer_large_asr_nat-zh-cn-16k-common-vocab8404-pytorch"
        }
    } else {
        Write-Info "ASR模型已存在，跳过下载"
    }
} else {
    Write-Warning "跳过ASR模型下载"
}

# 5. 下载NLTK数据
if (-not (Test-Path "nltk_data")) {
    Write-Info "下载NLTK数据..."
    try {
        Invoke-Download -Uri $NLTKURL -OutFile "nltk_data.zip"
        Invoke-Unzip "nltk_data.zip" "."
        Write-Success "NLTK数据下载完成"
    }
    catch {
        Write-Warning "NLTK数据下载失败，程序仍可正常运行"
    }
} else {
    Write-Info "NLTK数据已存在，跳过下载"
}

Write-Success "模型下载完成！"
Write-Info "总下载大小约: 6GB"
Write-Info "如果某些模型下载失败，请检查网络连接或尝试不同的源"
Write-Info ""
Write-Info "使用方法:"
Write-Info "  下载所有模型: .\download_models.ps1"
Write-Info "  使用HF源: .\download_models.ps1 -Source HF"
Write-Info "  跳过UVR5模型: .\download_models.ps1 -SkipUVR5"
Write-Info "  跳过ASR模型: .\download_models.ps1 -SkipASR"