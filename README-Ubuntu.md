# GPT-SoVITS Ubuntu版本使用指南

这是GPT-SoVITS项目的Ubuntu Linux适配版本，基于原Windows整合包修改而来。

## 系统要求

- **操作系统**: Ubuntu 18.04+ (推荐 Ubuntu 20.04/22.04)
- **Python**: 3.10 (通过conda安装)
- **GPU**: NVIDIA GPU (可选，支持CUDA 12.6/12.8)
- **内存**: 建议8GB以上
- **存储**: 建议20GB以上可用空间

## 快速开始

### 1. 安装系统依赖

```bash
# 更新包管理器
sudo apt update

# 安装基础依赖
sudo apt install -y git wget ffmpeg libsox-dev

# 安装Anaconda/Miniconda (如果未安装)
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

### 2. 一键安装

```bash
# 使用默认设置安装 (CUDA 12.8 + HuggingFace)
bash install-ubuntu.sh

# 或者自定义安装选项
bash install-ubuntu.sh --device CU128 --source HF --download-uvr5
```

### 3. 启动应用

```bash
# 启动WebUI界面
./go-webui.sh

# 或启动API服务器
./api-server.sh
```

## 安装选项说明

### 设备类型 (--device)
- `CU126`: CUDA 12.6 (适用于较新的NVIDIA GPU)
- `CU128`: CUDA 12.8 (默认，适用于最新的NVIDIA GPU)  
- `CPU`: 仅使用CPU (适用于无GPU环境)

### 模型源 (--source)
- `HF`: HuggingFace (默认，国外用户推荐)
- `HF-Mirror`: HuggingFace镜像 (国内用户推荐)
- `ModelScope`: 魔搭社区 (国内用户备选)

### 其他选项
- `--download-uvr5`: 下载UVR5人声分离模型
- `--env-name NAME`: 自定义conda环境名称

## 使用示例

### 基础使用
```bash
# 国内用户推荐配置
bash install-ubuntu.sh --device CU128 --source HF-Mirror --download-uvr5

# CPU版本安装
bash install-ubuntu.sh --device CPU --source ModelScope
```

### 启动服务
```bash
# 启动WebUI (推荐新手使用)
./go-webui.sh

# 启动API服务器 (供其他软件调用)
./api-server.sh

# 或使用简洁版本 (直接对应Windows的接口.bat)
./接口.sh
```

## 目录结构说明

```
GPT-SoVITS-v2pro-20250604/
├── go-webui.sh          # WebUI启动脚本
├── api-server.sh        # API服务器启动脚本 (完整版)
├── 接口.sh              # API接口启动脚本 (简洁版，对应Windows接口.bat)
├── install-ubuntu.sh    # Ubuntu安装脚本
├── setup-env.sh         # 环境配置脚本
├── check-ubuntu-setup.sh # 系统检查脚本
├── README-Ubuntu.md     # Ubuntu使用说明
├── MIGRATION-NOTES.md   # 迁移说明文档
├── requirements-ubuntu.txt # Ubuntu优化依赖列表
├── webui.py            # WebUI主程序
├── api_v2.py           # API服务器主程序
├── requirements.txt    # Python依赖列表
├── extra-req.txt       # 额外依赖
├── GPT_SoVITS/         # 核心模块
├── tools/              # 工具集
└── ...
```

## 常见问题

### 1. conda命令未找到
```bash
# 重新加载shell配置
source ~/.bashrc
# 或
source ~/.zshrc
```

### 2. CUDA版本不匹配
检查NVIDIA驱动和CUDA版本：
```bash
nvidia-smi
nvcc --version
```

### 3. 内存不足
- 使用CPU版本: `--device CPU`
- 减少batch size
- 关闭其他占用内存的程序

### 4. 网络连接问题
- 国内用户使用镜像源: `--source HF-Mirror`
- 配置代理或VPN

### 5. 权限问题
```bash
# 给脚本添加执行权限
chmod +x *.sh
```

## 性能优化建议

1. **GPU加速**: 使用NVIDIA GPU可显著提升推理速度
2. **SSD存储**: 使用SSD存储模型文件可提升加载速度  
3. **内存优化**: 确保有足够的系统内存和显存
4. **网络优化**: 使用国内镜像源可提升下载速度

## 更新说明

相比Windows版本的主要变化：
- 移除了Windows特定的runtime目录
- 使用conda管理Python环境
- 适配Linux系统的路径和命令
- 优化了安装和启动流程
- 添加了系统依赖检查

## 技术支持

- 原项目地址: https://github.com/RVC-Boss/GPT-SoVITS
- 问题反馈: 请在原项目提交Issue
- 使用文档: 参考原项目的详细文档

## 许可证

本项目遵循原GPT-SoVITS项目的许可证条款。