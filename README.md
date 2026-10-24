# 不用联网、不花钱：安卓手机离线跑大模型完整教程（2026 版）

> 适合人群：想在手机上离线使用 AI、又不想花钱开会员/担心隐私的人。
> 全程不需要联网使用（仅安装时需要下载），无需 Root，无需电脑。
> 全套流程 30 分钟内可完成。本文所有软件均免费开源。

## 一、先说结论：你能得到什么

做完这套流程后，你的手机会变成一个**完全离线的 AI 助手**：

- ✅ 飞机上、地铁里、没信号的野外都能用
- ✅ 聊天记录 100% 不出手机，隐私拉满
- ✅ 不限次数、不要会员费
- ✅ 可以加载 SillyTavern（酒馆）玩角色扮演，也可以当日常问答助手

代价也说清楚：

- ❌ 手机至少需要 **6GB 内存**（建议 8GB 以上）
- ❌ 智力不如 GPT-4o 这类云端大模型，但日常问答、写作润色、角色扮演完全够用
- ❌ 聊天时手机会发热、耗电加快（正常现象）

## 二、原理：30 秒看懂

大模型本质上是一个文件（gguf 格式）。有个叫 **llama.cpp** 的开源项目能在手机 CPU 上直接运行这个文件，不需要显卡、不需要联网。

**ChatterUI** 是一个开源的安卓 App，内置了 llama.cpp，你只要把模型文件给它就能跑。

想玩得更高级（角色卡、世界观、长期记忆），再加一层 **SillyTavern（酒馆）**——它运行在手机里的 Termux（一个安卓上的 Linux 终端）里，通过本地接口调用 ChatterUI 的模型。

```
你 ↔ 浏览器/酒馆界面 ↔ ChatterUI(本地API) ↔ 模型文件(gguf)
```

## 三、准备阶段（需要联网，一次性）

### 3.1 检查你的手机

- 内存 6GB 起步（设置 → 关于手机 可查看）；8GB 更稳
- 存储空间预留 4GB 以上

### 3.2 下载三个东西

| 东西 | 去哪下 | 说明 |
|---|---|---|
| ChatterUI | GitHub 搜 `ChatterUI` Releases | 本地模型运行器 |
| Termux | GitHub `termux/termux-app` Releases（**不要用应用商店版**，已停更） | 安卓 Linux 终端 |
| 模型文件 | ModelScope（魔搭，国内直连快）搜 `Qwen2.5 gguf` | 推荐下文型号 |

**模型怎么选？**（Q4_K_M 量化 = 质量和体积的平衡点，无脑选它）

| 手机内存 | 推荐模型 | 体积 | 体验 |
|---|---|---|---|
| 6~8GB | Qwen2.5-1.5B-Instruct Q4_K_M | ~1GB | 流畅，适合问答 |
| 8~12GB | Qwen2.5-3B-Instruct Q4_K_M | ~2GB | ⭐均衡推荐，中文好 |
| 12GB+ 旗舰 | Qwen2.5-7B-Instruct Q4_K_M | ~4.7GB | 接近早期 ChatGPT |

> 💡 ChatterUI 作者还提供了内置模型的一体化版本 APK（装好即用，适合纯小白），可在其 GitHub Releases 找到。

## 四、路线 A：装好即用（5 分钟，适合大多数人）

1. 安装 ChatterUI（一体化版则直接跳到第 4 步）
2. 打开 ChatterUI → 右上角菜单 → 导入/添加模型 → 选择你下载的 gguf 文件
3. 加载模型，等进度条走完
4. 回到对话页，直接开聊 ✅

到这里你已经有了一个完全离线的 AI。**想玩角色扮演/酒馆的，继续看路线 B。**

## 五、路线 B：酒馆（SillyTavern）完整玩法

### 5.1 安装 Termux 并解除后台限制

1. 安装 termux.apk
2. **关键一步**（90% 的失败都在这）：系统设置 → 应用 → Termux → 电池 → 允许后台活动/无限制。ChatterUI 同样操作。

### 5.2 一键安装酒馆

把下面的安装脚本放到手机"下载"文件夹（可通过微信/QQ发给自己再保存），打开 Termux 依次输入：

```bash
termux-setup-storage        # 弹出权限请求，点允许
cp /sdcard/Download/st-install.sh ~/
bash st-install.sh
```

脚本会自动安装 Node.js、下载 SillyTavern、装依赖，首次约 10~20 分钟。

> 手动党也可以不用脚本，自己输入：
> ```bash
> pkg install nodejs-lts git -y
> git clone https://github.com/SillyTavern/SillyTavern -b release
> cd SillyTavern && npm install
> bash start.sh
> ```

### 5.3 启动酒馆

```bash
cd ~/SillyTavern && bash start.sh
```

看到启动完成后，浏览器打开 `http://localhost:8000` 就是酒馆界面。

### 5.4 让酒馆用上本地模型

1. 打开 ChatterUI → 加载模型 → 菜单里打开 **Local API Server**（OpenAI 兼容，端口默认 8080）
2. 酒馆网页 → 左上角插头图标（API 连接）：
   - API 类型：Chat Completion
   - Chat Source：Custom (OpenAI-compatible)
   - Endpoint：`http://127.0.0.1:8080/v1`
   - API Key 随便填
3. 点连接 → 成功后选择模型 ✅

### 5.5 日常启动顺序（记住这个就够）

> 开机后：Termux 启动酒馆 → ChatterUI 加载模型 + 开本地服务 → 浏览器开玩

## 六、避坑指南（都是实际踩过的坑）

| 问题 | 解决 |
|---|---|
| npm 安装卡住/失败 | Termux 里执行 `npm config set registry https://registry.npmmirror.com` 后重跑 |
| 酒馆后台被杀 | Termux 通知栏点 **Acquire wakelock**；确认电池优化已关 |
| 连不上 8080 | 确认 ChatterUI 的 Local API Server 处于运行状态（界面有开关） |
| 回复很慢 | 正常。小手机芯片就是慢，3B 模型一般每秒 3~8 字，等得起就玩 |
| 闪退/杀后台 | 换 1.5B 模型；聊天设置里把上下文长度（Context）调小到 4096 |
| 应用商店搜不到 Termux | 正常，去 GitHub Releases 下载 apk |
| 手机发烫 | 摘掉手机壳、别边充电边聊；温度过高系统会强制降频更慢 |

## 七、进阶玩法（简单提一嘴，够你自己研究）

- **角色卡**：酒馆支持导入 PNG 角色卡，jannny 等社区有大量现成的
- **更强的模型**：Qwen3、Gemma 系列都有小尺寸 gguf，方法完全相同
- **电脑上跑**：同一套逻辑，电脑用 LM Studio 更简单，酒馆连 `http://127.0.0.1:1234/v1` 即可
- **隐私办公**：把会议录音转文字（whisper 也有手机方案）喂给本地模型做总结

## 八、总结

一套流程下来：**免费 + 离线 + 隐私 + 无限次**。它不会取代云端大模型，但它给了你一个"断网也有的 AI"，这就值回折腾的 30 分钟。

有问题欢迎评论区留言，常见问题都会回。
