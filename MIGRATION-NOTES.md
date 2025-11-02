# GPT-SoVITS Windows到Ubuntu迁移说明

本文档记录了将GPT-SoVITS Windows整合包迁移到Ubuntu Linux系统的所有变更和注意事项。

## 迁移概述

### 原始环境
- **平台**: Windows 10/11
- **Python**: 预编译的Python 3.9运行时 (runtime目录)
- **启动方式**: .bat和.ps1脚本
- **依赖管理**: 预安装的Python包

### 目标环境  
- **平台**: Ubuntu 18.04+ (推荐20.04/22.04)
- **Python**: 通过conda管理的Python 3.10环境
- **启动方式**: .sh shell脚本
- **依赖管理**: conda + pip包管理

## 主要变更

### 1. 移除的Windows特定文件
```
runtime/                 # Windows预编译Python运行时
go-webui.bat            # Windows批处理启动脚本
go-webui.ps1            # PowerShell启动脚本  
install.ps1             # PowerShell安装脚本
接口.bat                # Windows API服务器启动脚本
```

### 2. 新增的Linux文件
```
go-webui.sh             # Linux WebUI启动脚本
api-server.sh           # Linux API服务器启动脚本
install-ubuntu.sh       # Ubuntu专用安装脚本
setup-env.sh            # 环境配置脚本
requirements-ubuntu.txt # Ubuntu优化的依赖文件
README-Ubuntu.md        # Ubuntu使用说明
check-ubuntu-setup.sh   # 系统验证脚本
MIGRATION-NOTES.md      # 本迁移说明文档
```

### 3. 依赖管理变更

#### Windows版本
- 使用预编译的Python运行时
- 所有依赖预安装在runtime目录
- 通过PATH环境变量调用

#### Ubuntu版本  
- 使用conda创建独立Python环境
- 通过pip安装依赖包
- 支持GPU/CPU自动检测和配置

### 4. 启动方式变更

#### Windows版本
```batch
# WebUI启动
go-webui.bat

# API服务器启动  
接口.bat
```

#### Ubuntu版本
```bash
# WebUI启动
./go-webui.sh

# API服务器启动
./api-server.sh
```

## 技术实现细节

### 1. 环境管理
- **conda环境**: 创建名为"GPTSoVits"的独立环境
- **Python版本**: 3.10 (兼容性最佳)
- **依赖隔离**: 避免与系统Python冲突

### 2. 依赖优化
- **requirements-ubuntu.txt**: 针对Ubuntu系统优化
- **平台特定包**: 根据架构自动选择onnxruntime版本
- **Linux特定**: 包含python_mecab_ko等Linux专用包

### 3. 环境配置
- **模型缓存**: 统一管理HuggingFace和ModelScope缓存
- **CUDA支持**: 自动检测GPU并配置CUDA环境
- **性能优化**: 设置多线程和内存优化参数

### 4. 错误处理
- **依赖检查**: 安装前验证系统依赖
- **环境验证**: 提供完整的系统检查脚本
- **错误恢复**: 详细的错误信息和解决建议

## 兼容性说明

### 保持兼容的功能
- ✅ 所有核心TTS功能
- ✅ WebUI界面和API接口
- ✅ 模型训练和推理
- ✅ 多语言支持
- ✅ 音频处理工具

### 平台特定差异
- 🔄 启动脚本格式 (.bat → .sh)
- 🔄 Python环境管理 (runtime → conda)
- 🔄 路径分隔符 (\ → /)
- 🔄 系统依赖安装方式

### 新增功能
- ✨ 自动系统依赖检查
- ✨ GPU/CPU自动配置
- ✨ 环境验证脚本
- ✨ 优化的依赖管理

## 使用流程对比

### Windows版本流程
1. 下载整合包
2. 解压到目录
3. 双击go-webui.bat启动

### Ubuntu版本流程  
1. 克隆/下载项目
2. 运行系统检查: `./check-ubuntu-setup.sh`
3. 安装环境: `./install-ubuntu.sh`
4. 启动应用: `./go-webui.sh`

## 性能对比

### 内存使用
- **Windows**: 较高 (预装所有依赖)
- **Ubuntu**: 较低 (按需安装)

### 启动速度
- **Windows**: 较快 (预编译环境)
- **Ubuntu**: 中等 (conda环境激活)

### 磁盘占用
- **Windows**: 较大 (完整runtime)
- **Ubuntu**: 较小 (共享系统依赖)

## 故障排除

### 常见问题
1. **conda未找到**: 安装Anaconda/Miniconda
2. **权限错误**: 使用chmod +x添加执行权限
3. **依赖冲突**: 删除环境重新安装
4. **GPU不可用**: 检查NVIDIA驱动和CUDA版本

### 调试工具
- `./check-ubuntu-setup.sh`: 系统验证
- `conda info --envs`: 查看环境列表
- `nvidia-smi`: 检查GPU状态
- `python --version`: 确认Python版本

## 后续维护

### 更新依赖
```bash
conda activate GPTSoVits
pip install -r requirements-ubuntu.txt --upgrade
```

### 环境重建
```bash
conda env remove -n GPTSoVits
./install-ubuntu.sh
```

### 备份重要数据
- 训练好的模型文件
- 自定义配置文件
- 用户数据和日志

## 贡献指南

如需改进Ubuntu版本，请注意：
1. 保持与原版功能兼容
2. 遵循Linux系统规范
3. 更新相关文档
4. 测试多个Ubuntu版本

---

**迁移完成日期**: 2025年1月
**适用版本**: GPT-SoVITS v2 Pro
**维护状态**: 活跃维护