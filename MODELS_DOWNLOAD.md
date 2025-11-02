# GPT-SoVITS 模型下载指南

本项目需要下载多个预训练模型才能正常运行。由于模型文件较大（总计约6GB），这些文件没有包含在Git仓库中。

## 📋 所需模型概览

| 模型类型 | 大小 | 用途 | 必需性 |
|---------|------|------|--------|
| 预训练模型 (pretrained_models) | ~4.2GB | 核心TTS模型 | ✅ 必需 |
| UVR5模型 (uvr5_weights) | ~718MB | 音频分离 | 🔶 可选 |
| ASR模型 (asr_models) | ~1.1GB | 语音识别 | 🔶 可选 |
| G2PW模型 | ~50MB | 中文发音 | ✅ 必需 |
| NLTK数据 | ~20MB | 文本处理 | 🔶 可选 |

## 🚀 快速开始

### 方法一：使用自动下载脚本（推荐）

我们提供了自动下载脚本，支持多个下载源：

#### Windows用户
```powershell
# 下载所有模型（推荐）
.\download_models.ps1

# 使用不同的下载源
.\download_models.ps1 -Source HF          # HuggingFace
.\download_models.ps1 -Source HF-Mirror   # HuggingFace镜像（默认，国内推荐）
.\download_models.ps1 -Source ModelScope  # ModelScope（国内推荐）

# 跳过某些模型
.\download_models.ps1 -SkipUVR5           # 跳过UVR5模型
.\download_models.ps1 -SkipASR            # 跳过ASR模型
```

#### Linux/macOS用户
```bash
# 下载所有模型（推荐）
./download_models.sh

# 使用不同的下载源
./download_models.sh --source HF          # HuggingFace
./download_models.sh --source HF-Mirror   # HuggingFace镜像（默认，国内推荐）
./download_models.sh --source ModelScope  # ModelScope（国内推荐）

# 跳过某些模型
./download_models.sh --skip-uvr5          # 跳过UVR5模型
./download_models.sh --skip-asr           # 跳过ASR模型
```

### 方法二：手动下载

如果自动脚本无法使用，可以手动下载：

#### 1. 预训练模型（必需）
下载地址：
- HuggingFace: https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/pretrained_models.zip
- HF-Mirror: https://hf-mirror.com/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/pretrained_models.zip
- ModelScope: https://www.modelscope.cn/models/XXXXRT/GPT-SoVITS-Pretrained/resolve/master/pretrained_models.zip

解压到：`GPT_SoVITS/` 目录

#### 2. G2PW模型（必需）
下载地址：
- HuggingFace: https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/G2PWModel.zip
- HF-Mirror: https://hf-mirror.com/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/G2PWModel.zip
- ModelScope: https://www.modelscope.cn/models/XXXXRT/GPT-SoVITS-Pretrained/resolve/master/G2PWModel.zip

解压到：`GPT_SoVITS/text/` 目录

#### 3. UVR5模型（可选）
下载地址：
- HuggingFace: https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/uvr5_weights.zip
- HF-Mirror: https://hf-mirror.com/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/uvr5_weights.zip
- ModelScope: https://www.modelscope.cn/models/XXXXRT/GPT-SoVITS-Pretrained/resolve/master/uvr5_weights.zip

解压到：`tools/uvr5/` 目录

#### 4. ASR模型（可选）
下载地址：
- HuggingFace: https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/asr_models.zip
- HF-Mirror: https://hf-mirror.com/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/asr_models.zip
- ModelScope: https://www.modelscope.cn/models/XXXXRT/GPT-SoVITS-Pretrained/resolve/master/asr_models.zip

解压到：`tools/asr/` 目录

## 📁 目录结构

下载完成后，您的目录结构应该如下：

```
GPT-SoVITS-v2pro/
├── GPT_SoVITS/
│   ├── pretrained_models/           # 预训练模型
│   │   ├── chinese-hubert-base/
│   │   ├── chinese-roberta-wwm-ext-large/
│   │   ├── gsv-v2final-pretrained/
│   │   ├── gsv-v4-pretrained/
│   │   ├── models--nvidia--bigvgan_v2_24khz_100band_256x/
│   │   ├── sv/
│   │   ├── v2Pro/
│   │   ├── s1v3.ckpt
│   │   ├── s2G488k.pth
│   │   └── s2Gv3.pth
│   └── text/
│       └── G2PWModel/               # G2PW模型
├── tools/
│   ├── asr/
│   │   └── models/                  # ASR模型
│   └── uvr5/
│       └── uvr5_weights/            # UVR5模型
└── nltk_data/                       # NLTK数据
```

## 🌐 下载源说明

### HuggingFace
- 官方源，速度可能较慢
- 适合海外用户

### HuggingFace-Mirror
- HuggingFace的国内镜像
- 国内用户推荐使用
- 速度较快

### ModelScope
- 阿里云提供的模型托管平台
- 国内用户推荐使用
- 速度较快

## ⚠️ 注意事项

1. **网络要求**：下载需要稳定的网络连接，总大小约6GB
2. **存储空间**：确保有足够的磁盘空间（至少8GB可用空间）
3. **下载时间**：根据网络速度，可能需要30分钟到几小时
4. **断点续传**：如果下载中断，可以重新运行脚本，已下载的文件会被跳过

## 🔧 故障排除

### 下载失败
1. 检查网络连接
2. 尝试不同的下载源
3. 使用VPN（如果在国内访问HuggingFace）
4. 手动下载单个文件

### 解压失败
1. 检查下载的文件是否完整
2. 确保有足够的磁盘空间
3. 重新下载损坏的文件

### 权限问题（Linux/macOS）
```bash
chmod +x download_models.sh
```

## 📞 获取帮助

如果遇到问题，请：
1. 查看错误信息
2. 检查网络连接
3. 尝试不同的下载源
4. 在项目Issues中报告问题

## 🔄 更新模型

当项目更新时，可能需要下载新的模型文件。运行下载脚本会自动检查并下载缺失的文件。

---

**提示**：首次使用建议下载所有模型以获得完整功能体验。如果只是测试，可以先下载必需的模型（预训练模型和G2PW模型）。