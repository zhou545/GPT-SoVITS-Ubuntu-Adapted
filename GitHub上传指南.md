# GitHub仓库上传指南 - GPT-SoVITS项目

## 📋 目录
1. [准备工作](#1-准备工作)
2. [创建GitHub仓库](#2-创建github仓库)
3. [本地Git配置](#3-本地git配置)
4. [上传项目到GitHub](#4-上传项目到github)
5. [大文件处理方案](#5-大文件处理方案)
6. [仓库管理建议](#6-仓库管理建议)
7. [常见问题解决](#7-常见问题解决)

---

## 1. 准备工作

### 🔧 安装Git
```bash
# Windows (使用Chocolatey)
choco install git

# 或下载安装包
# https://git-scm.com/download/win

# Ubuntu/Linux
sudo apt install git

# macOS
brew install git
```

### 📝 检查项目文件
在上传前，确保以下文件已经准备好：
- ✅ `.gitignore` 文件已优化
- ✅ `README.md` 文件存在
- ✅ 敏感信息已移除
- ✅ 大文件已处理（见第5节）

### 🗂️ 当前项目结构
```
GPT-SoVITS-v2pro-20250604/
├── 📄 README.md                    # 项目说明
├── 📄 README-Ubuntu.md             # Ubuntu部署指南
├── 📄 MIGRATION-NOTES.md           # 迁移说明
├── 📄 优云智算部署指南.md           # 云平台部署指南
├── 📄 GitHub上传指南.md            # 本文档
├── 🔧 install-ubuntu.sh            # Ubuntu安装脚本
├── 🔧 go-webui.sh                  # WebUI启动脚本
├── 🔧 api-server.sh                # API服务器脚本
├── 🔧 接口.sh                      # 简洁API脚本
├── 🔧 quick-start.sh               # 一键启动脚本
├── 🔧 setup-env.sh                 # 环境配置脚本
├── 🔧 check-ubuntu-setup.sh        # 系统检查脚本
├── 📦 requirements-ubuntu.txt      # Ubuntu优化依赖
├── 📦 requirements.txt             # 原始依赖
├── 🐍 webui.py                     # WebUI主程序
├── 🐍 api_v2.py                    # API主程序
├── 📁 GPT_SoVITS/                  # 核心模块
├── 📁 tools/                       # 工具集
└── ...
```

---

## 2. 创建GitHub仓库

### 🌐 在GitHub网站创建仓库

1. **登录GitHub**: https://github.com
2. **点击 "New repository"** 或访问 https://github.com/new
3. **填写仓库信息**:
   ```
   Repository name: GPT-SoVITS-Ubuntu-Adapted
   Description: GPT-SoVITS Windows整合包的Ubuntu Linux适配版本
   
   ☑️ Public (推荐) 或 ☐ Private
   ☐ Add a README file (我们已经有了)
   ☐ Add .gitignore (我们已经有了)
   ☐ Choose a license (可选择MIT License)
   ```
4. **点击 "Create repository"**

### 📋 推荐的仓库设置
- **仓库名称**: `GPT-SoVITS-Ubuntu-Adapted`
- **描述**: `GPT-SoVITS Windows integrated package adapted for Ubuntu Linux with optimized installation scripts and deployment guides`
- **标签**: `gpt-sovits`, `ubuntu`, `linux`, `voice-synthesis`, `tts`, `ai`

---

## 3. 本地Git配置

### ⚙️ 首次配置Git
```bash
# 配置用户信息
git config --global user.name "你的用户名"
git config --global user.email "你的邮箱@example.com"

# 配置默认分支名
git config --global init.defaultBranch main

# 配置编辑器（可选）
git config --global core.editor "code --wait"  # VS Code
```

### 🔐 配置SSH密钥（推荐）
```bash
# 生成SSH密钥
ssh-keygen -t ed25519 -C "你的邮箱@example.com"

# 启动ssh-agent
eval "$(ssh-agent -s)"

# 添加密钥到ssh-agent
ssh-add ~/.ssh/id_ed25519

# 复制公钥到剪贴板
cat ~/.ssh/id_ed25519.pub
# 然后在GitHub Settings > SSH and GPG keys 中添加
```

---

## 4. 上传项目到GitHub

### 📤 方法一：从本地上传（推荐）

#### 步骤1：初始化本地仓库
```bash
# 进入项目目录
cd "d:\doucument\do_current\GPT\GPT-SoVITS-v2pro-20250604"

# 初始化Git仓库
git init

# 添加远程仓库
git remote add origin https://github.com/你的用户名/GPT-SoVITS-Ubuntu-Adapted.git
# 或使用SSH: git remote add origin git@github.com:你的用户名/GPT-SoVITS-Ubuntu-Adapted.git
```

#### 步骤2：添加文件并提交
```bash
# 检查文件状态
git status

# 添加所有文件（.gitignore会自动过滤）
git add .

# 检查将要提交的文件
git status

# 创建首次提交
git commit -m "Initial commit: GPT-SoVITS Ubuntu adaptation

- Added Ubuntu installation scripts (install-ubuntu.sh, quick-start.sh)
- Created Linux startup scripts (go-webui.sh, api-server.sh, 接口.sh)
- Added environment setup (setup-env.sh, requirements-ubuntu.txt)
- Included deployment guides (README-Ubuntu.md, 优云智算部署指南.md)
- Added system verification tools (check-ubuntu-setup.sh)
- Optimized .gitignore for the project"
```

#### 步骤3：推送到GitHub
```bash
# 推送到GitHub
git push -u origin main

# 如果遇到错误，可能需要强制推送（仅首次）
git push -u origin main --force
```

### 📤 方法二：GitHub CLI上传
```bash
# 安装GitHub CLI
# Windows: winget install GitHub.cli
# Ubuntu: sudo apt install gh

# 登录GitHub
gh auth login

# 创建仓库并推送
gh repo create GPT-SoVITS-Ubuntu-Adapted --public --source=. --remote=origin --push
```

---

## 5. 大文件处理方案

### ⚠️ GitHub文件大小限制
- 单个文件: 最大100MB
- 仓库总大小: 建议小于1GB
- 推送大小: 最大2GB

### 🗂️ 需要特殊处理的文件

#### 大文件类型识别
```bash
# 查找大于50MB的文件
find . -type f -size +50M -not -path "./.git/*"

# 查找常见的大文件类型
find . -name "*.pth" -o -name "*.bin" -o -name "*.safetensors" -o -name "*.ckpt"
```

#### 解决方案1：Git LFS（推荐）
```bash
# 安装Git LFS
git lfs install

# 跟踪大文件类型
git lfs track "*.pth"
git lfs track "*.bin"
git lfs track "*.safetensors"
git lfs track "*.ckpt"
git lfs track "*.wav"
git lfs track "*.mp3"

# 添加.gitattributes文件
git add .gitattributes

# 提交LFS配置
git commit -m "Add Git LFS tracking for large files"

# 正常添加和提交大文件
git add .
git commit -m "Add model files with Git LFS"
git push
```

#### 解决方案2：外部存储链接
在README中提供下载链接：
```markdown
## 模型文件下载

由于GitHub文件大小限制，模型文件需要单独下载：

- **GPT模型**: [下载链接](https://your-storage-link.com/gpt-weights.zip)
- **SoVITS模型**: [下载链接](https://your-storage-link.com/sovits-weights.zip)

下载后请解压到对应目录：
- GPT_weights/ 
- SoVITS_weights/
```

#### 解决方案3：分支管理
```bash
# 创建不包含大文件的主分支
git checkout -b main-lite

# 删除大文件
rm -rf GPT_weights* SoVITS_weights*

# 提交轻量版本
git add .
git commit -m "Lite version without model weights"
git push -u origin main-lite

# 设置main-lite为默认分支
```

---

## 6. 仓库管理建议

### 📚 完善README.md
```markdown
# GPT-SoVITS Ubuntu适配版

## 🎯 项目简介
这是GPT-SoVITS Windows整合包的Ubuntu Linux适配版本，提供了完整的安装脚本和部署指南。

## ✨ 主要特性
- 🐧 完全适配Ubuntu 20.04/22.04 LTS
- 🚀 一键安装脚本
- 🔧 多种启动方式
- 📖 详细的部署文档
- ☁️ 云平台部署支持

## 🚀 快速开始
\`\`\`bash
# 克隆仓库
git clone https://github.com/你的用户名/GPT-SoVITS-Ubuntu-Adapted.git
cd GPT-SoVITS-Ubuntu-Adapted

# 一键启动
./quick-start.sh
\`\`\`

## 📖 文档
- [Ubuntu部署指南](README-Ubuntu.md)
- [优云智算部署指南](优云智算部署指南.md)
- [迁移说明](MIGRATION-NOTES.md)

## 🤝 贡献
欢迎提交Issue和Pull Request！

## 📄 许可证
[MIT License](LICENSE)
```

### 🏷️ 创建Release版本
```bash
# 创建标签
git tag -a v1.0.0 -m "Release v1.0.0: Initial Ubuntu adaptation"

# 推送标签
git push origin v1.0.0

# 在GitHub网站创建Release
# 访问: https://github.com/你的用户名/GPT-SoVITS-Ubuntu-Adapted/releases/new
```

### 🌿 分支管理策略
```bash
# 主分支
main          # 稳定版本
develop       # 开发版本

# 功能分支
feature/新功能名
bugfix/问题修复名
hotfix/紧急修复名

# 创建开发分支
git checkout -b develop
git push -u origin develop
```

### 📋 Issue模板
创建 `.github/ISSUE_TEMPLATE/bug_report.md`:
```markdown
---
name: Bug报告
about: 创建一个bug报告来帮助我们改进
title: '[BUG] '
labels: bug
assignees: ''
---

**描述bug**
清晰简洁地描述这个bug是什么。

**重现步骤**
重现该行为的步骤：
1. 执行 '...'
2. 点击 '....'
3. 滚动到 '....'
4. 看到错误

**期望行为**
清晰简洁地描述你期望发生什么。

**系统信息**
- OS: [例如 Ubuntu 22.04]
- Python版本: [例如 3.10]
- CUDA版本: [例如 12.8]

**附加信息**
添加任何其他关于问题的信息。
```

---

## 7. 常见问题解决

### ❗ 推送失败问题

#### 问题1：文件过大
```bash
# 错误信息: remote: error: File xxx is 123.45 MB; this exceeds GitHub's file size limit of 100.00 MB

# 解决方案：使用Git LFS
git lfs track "大文件名"
git add .gitattributes
git add 大文件名
git commit --amend --no-edit
git push
```

#### 问题2：历史记录中有大文件
```bash
# 使用BFG Repo-Cleaner清理历史
java -jar bfg.jar --strip-blobs-bigger-than 100M .git
git reflog expire --expire=now --all && git gc --prune=now --aggressive
git push --force
```

#### 问题3：认证失败
```bash
# 使用Personal Access Token
# GitHub Settings > Developer settings > Personal access tokens
# 使用token作为密码

# 或配置SSH密钥（推荐）
ssh-keygen -t ed25519 -C "your_email@example.com"
# 添加公钥到GitHub
```

### 🔄 更新仓库
```bash
# 日常更新流程
git add .
git commit -m "描述你的更改"
git push

# 拉取最新更改
git pull origin main

# 解决冲突后
git add .
git commit -m "Resolve merge conflicts"
git push
```

### 📊 仓库统计
```bash
# 查看仓库大小
git count-objects -vH

# 查看最大的文件
git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | sed -n 's/^blob //p' | sort --numeric-sort --key=2 | tail -10

# 查看提交历史
git log --oneline --graph
```

---

## 🎯 最佳实践总结

### ✅ 推荐做法
1. **定期提交**: 小而频繁的提交比大的提交更好
2. **清晰的提交信息**: 使用有意义的提交信息
3. **分支管理**: 使用分支进行功能开发
4. **文档维护**: 保持README和文档的更新
5. **标签管理**: 为重要版本创建标签

### ❌ 避免做法
1. **不要提交敏感信息**: 密码、API密钥等
2. **不要提交大文件**: 使用Git LFS或外部存储
3. **不要强制推送**: 除非确实必要
4. **不要忽略.gitignore**: 确保正确配置忽略规则

---

## 🔗 相关链接

- [Git官方文档](https://git-scm.com/doc)
- [GitHub文档](https://docs.github.com/)
- [Git LFS文档](https://git-lfs.github.io/)
- [GitHub CLI文档](https://cli.github.com/manual/)

---

**祝你的项目在GitHub上获得成功！** 🎉