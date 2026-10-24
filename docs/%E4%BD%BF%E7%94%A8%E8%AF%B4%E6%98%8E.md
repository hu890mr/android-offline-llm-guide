# SillyTavern 手机安装包 · 使用说明

本文件夹包含全部所需文件，拷到手机即可安装：

| 文件 | 用途 |
|---|---|
| termux.apk | Termux 终端（跑 SillyTavern 后端） |
| ChatterUI.apk | 本地模型运行器（内置 llama.cpp，带本地 API 服务） |
| ChatterUI-内置模型.apk | ⭐ 一体化版：ChatterUI 已内搭 Qwen2.5-3B 模型，装好即用，无需导入 gguf |
| qwen2.5-3b-instruct-q4_k_m.gguf | 本地小模型 Qwen2.5-3B（中文好，约2GB，8G内存手机适用） |
| st-install.sh | Termux 里的一键安装 SillyTavern 脚本 |

## 安装步骤（手机上操作）

### 1. 装两个 APK
先装 termux.apk，再装 ChatterUI.apk。
装完 Termux 后：系统设置 → 应用 → Termux → 电池 → 允许后台活动；ChatterUI 同样处理。

### 2. Termux 里装 SillyTavern
打开 Termux，依次输入：

    termux-setup-storage          # 弹出权限请求，点允许
    cp /sdcard/Download/st-install.sh ~/
    bash st-install.sh

脚本会自动装 Node.js、克隆 SillyTavern、装依赖（首次约 10~20 分钟）。
以后启动酒馆：

    cd ~/SillyTavern && bash start.sh

浏览器打开 http://localhost:8000 即是酒馆界面。

### 3. ChatterUI 导入模型并开启本地服务
1. 打开 ChatterUI → 右上角菜单 → 导入/添加模型 → 选择 gguf 文件
   （从手机"下载"文件夹选 qwen2.5-3b-instruct-q4_k_m.gguf）
2. 加载模型 → 菜单里开启「Local API Server」（OpenAI 兼容服务，端口默认 8080）

### 4. 在酒馆里连接本地模型
ST 网页 → 左上角插头图标（API 连接）→
API 类型：Chat Completion → Chat Source 选 Custom (OpenAI-compatible) →
Custom Endpoint 填：

    http://127.0.0.1:8080/v1

API Key 随便填，点连接。连接成功后选模型即可用本地小模型聊天。

## 日常使用流程
开机后：打开 Termux（保持后台）→ `cd ~/SillyTavern && bash start.sh`
→ 打开 ChatterUI 加载模型 + 开启本地服务 → 浏览器玩酒馆。

## 常见问题
- npm 安装慢/失败：Termux 里执行 `npm config set registry https://registry.npmmirror.com` 后重跑脚本
- 酒馆后台被杀：Termux 通知栏点 "Acquire wakelock"，或设置里关电池优化
- 连不上 8080：确认 ChatterUI 的本地服务处于运行状态（界面上有开关）
- 内存不足/闪退：换更小的模型（Qwen2.5-1.5B Q4），或减少上下文长度
