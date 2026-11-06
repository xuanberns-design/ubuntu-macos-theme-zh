# Ubuntu 24.04 美化成 macOS 风格（零基础中文教程）

一步一步把 Ubuntu 24.04 的 GNOME 桌面改成 Mac 风格：底部居中 Dock、红黄绿窗口按钮、Mac 图标和指针、Big Sur 壁纸、Safari 风格的 Firefox，还有把 Firefox / 应用中心等图标换成 Safari / App Store。

> 作者是 ROS 2 初学者，这是在 VMware 虚拟机里边做边记的完整过程，**每条命令都实际跑过**，踩过的坑也都写进来了。

## 运行环境

| 项目 | 版本 |
|---|---|
| 系统 | Ubuntu 24.04.4 LTS（GNOME Shell 46） |
| 运行方式 | Windows 上的 VMware Workstation 虚拟机（8GB 内存） |
| 主题 | [WhiteSur](https://github.com/vinceliuice/WhiteSur-gtk-theme) 系列（作者 vinceliuice） |

只改外观，不动系统核心组件，不影响 ROS 2 等开发环境。

## 目录

- [第 0 步：拍快照（后悔药）](#第-0-步拍快照后悔药)
- [第 1 步：Dock 移到底部 + 安装美化工具](#第-1-步dock-移到底部--安装美化工具)
- [第 2 步：WhiteSur 窗口主题](#第-2-步whitesur-窗口主题)
- [第 3 步：Mac 图标和鼠标指针](#第-3-步mac-图标和鼠标指针)
- [第 4 步：Mac 壁纸](#第-4-步mac-壁纸)
- [第 5 步：Firefox 改成 Safari 风格](#第-5-步firefox-改成-safari-风格)
- [第 6 步：一键把软件图标换成 Safari / App Store / 邮件](#第-6-步一键把软件图标换成-safari--app-store--邮件)
- [常见问题与踩坑](#常见问题与踩坑)
- [怎么撤销](#怎么撤销)

---

## 第 0 步：拍快照（后悔药）

**目标**：给系统存档，美化翻车可以一键回到原样。

VMware 菜单：**VM → Snapshot → Take Snapshot...**，名字填 `美化前`，点 Take Snapshot。

**验收**：再打开 VM → Snapshot，能看到「美化前」。

> 💡 虚拟机开着拍会显示 `Saving state`，要把整块内存写进硬盘，可能要好几分钟，耐心等。**先在 Ubuntu 里关机再拍，几秒就好。**

不是虚拟机的话，可以用 Timeshift 之类的备份工具代替。

---

## 第 1 步：Dock 移到底部 + 安装美化工具

**目标**：Dock 变成屏幕底部居中的一小条，并装好后面要用的工具。

Ubuntu 自带的 Dock 本身就是基于 Dash to Dock 改的，直接改设置即可，不用额外装扩展：

```bash
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
```

- `gsettings set`：修改一项桌面设置，等同于在「设置」里点开关，立刻生效
- `dock-position 'BOTTOM'`：Dock 放到底部
- `extend-height false`：关掉「面板模式」，Dock 缩成居中的一小条

（也可以手动改：设置 → Ubuntu 桌面 → Dock：关掉「面板模式」，位置选「底部」。）

再装三个工具：

```bash
sudo apt update && sudo apt install -y gnome-tweaks gnome-shell-extension-manager git
```

- `gnome-tweaks`：「优化」，用来切换主题、图标、指针
- `gnome-shell-extension-manager`：「扩展管理器」，用来装 GNOME 扩展（Extension，给桌面加功能的小插件）
- `git`：从 GitHub 下载主题

**验收**：Dock 在底部居中；按 Win 键搜索「优化」「扩展管理器」都能打开。

---

## 第 2 步：WhiteSur 窗口主题

**目标**：窗口变成 Mac 外观，出现红黄绿圆形按钮。

```bash
sudo apt install -y sassc libglib2.0-dev-bin libxml2-utils
cd ~
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1
cd WhiteSur-gtk-theme
./install.sh -l
```

- 第 1 行：装编译主题需要的工具（sassc 把样式源文件转成系统能读的格式）
- `git clone ... --depth=1`：下载主题，只要最新版，速度快
- `./install.sh -l`：安装主题；`-l` 让 GTK4 / libadwaita 新式应用（设置、文件等）也生效

最后出现 `Done!` 就是装好了。

然后：

1. 打开「扩展管理器」→「浏览」，搜索 **User Themes** 并安装（允许更换顶栏和菜单的主题）
2. 打开「优化」→「外观」：**Shell** 和 **过时应用程序** 都选 `WhiteSur-Light`（喜欢深色选 `WhiteSur-Dark`）
3. 把窗口按钮挪到左边（更像 Mac）：

```bash
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
```

冒号左边的按钮放在标题栏左侧，顺序是关闭、最小化、最大化。

**验收**：打开「文件」，左上角是红黄绿三个圆点；顶栏变成白色半透明。

---

## 第 3 步：Mac 图标和鼠标指针

```bash
cd ~
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git --depth=1
cd WhiteSur-icon-theme
./install.sh
cd ~
git clone https://github.com/vinceliuice/WhiteSur-cursors.git --depth=1
cd WhiteSur-cursors
./install.sh
```

装好后打开「优化 → 外观」：

- **图标**：选 `WhiteSur-light`（浅色主题）或 `WhiteSur-dark`（深色主题）
- **光标**：选 `WhiteSur-cursors`

> ⚠️ 图标列表里也会出现 `WhiteSur-cursors`，那是鼠标指针（指针和图标放在同一个文件夹里，所以被一起列出来了），**图标那一栏别选它**。

**验收**：Dock 上的图标变成 Mac 圆角方块风格，鼠标变成 Mac 黑色箭头。

---

## 第 4 步：Mac 壁纸

```bash
cd ~
git clone https://github.com/vinceliuice/WhiteSur-wallpapers.git --depth=1
xdg-open ~/WhiteSur-wallpapers
```

`xdg-open` 会用文件管理器打开这个文件夹。找到喜欢的图片，**右键 → 设为壁纸**。

---

## 第 5 步：Firefox 改成 Safari 风格

Safari 没有 Linux 版，但可以把 Firefox 的外观改成 Safari 风格，WhiteSur 主题自带这个功能。

1. **先完全关闭 Firefox**（从没打开过的话，先打开一次再关，让它生成配置文件）
2. 运行：

```bash
cd ~/WhiteSur-gtk-theme
./tweaks.sh -f monterey
```

`-f` 表示给 Firefox 装主题，`monterey` 是 macOS Monterey 风格。Ubuntu 24.04 自带的 snap 版 Firefox 也能识别。

3. 按脚本提示调整工具栏：打开 Firefox，在工具栏空白处 **右键 → 定制工具栏…**，把标签栏右边的「**+**」（新建标签页）按钮拖到地址栏那一行，点右下角「完成」，重启 Firefox。

**验收**：左上角红黄绿按钮，标签页和地址栏合并在同一行，和 Safari 的「紧凑标签」布局一样。

> 只开一个标签页时，它会单独显示在地址栏中间，这是 Safari 紧凑布局的样子，不是出错。不喜欢的话运行 `./tweaks.sh -f`（不带参数）换成默认风格，随时可以换回来。

如果重启后外观完全没变：地址栏输入 `about:config`，把 `toolkit.legacyUserProfileCustomizations.stylesheets` 改成 `true`，再重启。

---

## 第 6 步：一键把软件图标换成 Safari / App Store / 邮件

**为什么有些图标没变？** 系统自带软件的图标已经被 WhiteSur 换掉了，但 **snap 软件**（Firefox、Thunderbird、应用中心等）的启动文件里写死了自带图标的路径，图标主题管不到它们。

本仓库的 [`mac-icons.sh`](./mac-icons.sh) 会把它们的启动文件复制一份到 `~/.local/share/applications/`（系统会优先用这份），再把图标改掉：

| 软件 | 换成 |
|---|---|
| Firefox | Safari |
| Thunderbird | Apple 邮件 |
| 应用中心（App Center） | App Store |
| 其他 snap 软件 | WhiteSur 里有同名图标就换，没有就跳过 |

下载并运行：

```bash
cd ~
wget https://raw.githubusercontent.com/xuanberns-design/ubuntu-macos-theme-zh/main/mac-icons.sh
bash ~/mac-icons.sh
```

**验收**：终端打印 `已替换: firefox -> safari` 这样的几行，几秒后 Dock 图标就变了（没变就注销重新登录一次）。

以后新装了 snap 软件，再运行一次 `bash ~/mac-icons.sh` 即可。

---

## 常见问题与踩坑

**1. 粘贴命令后提示「未找到命令」，命令前面多了 `^[[200~` 或 `~`**

从微信等地方复制命令时，可能会带进看不见的控制字符。在 Ubuntu 终端里要用 **Ctrl+Shift+V** 粘贴；回车前看一眼开头有没有多出来的字符，实在不行就手动敲一遍。

**2. 拍快照时 `Saving state` 很慢**

正常现象，开机状态要把内存写进硬盘。先关机再拍，几秒就好。

**3. 微信、QQ 等软件的右上角按钮还是老样子**

这些软件自己画标题栏，不使用系统的 GTK 主题，**任何主题都改不了**。不建议去改软件本身的文件，容易出问题，软件一更新也会被覆盖。

**4. Firefox 弹出「是否要清理一下配置文件……翻新 Firefox」**

**千万别点「翻新」**，翻新会重置配置文件，刚装的 Safari 风格主题也会被清掉。点右边的 × 关掉就行。

**5. `git clone` 卡住或连接失败**

访问 GitHub 网络不稳定，重新运行那一行，或者换个网络环境再试。

---

## 怎么撤销

- **最快**：VMware 里恢复到「美化前」快照
- **Dock**：`gsettings reset org.gnome.shell.extensions.dash-to-dock dock-position` 和 `gsettings reset org.gnome.shell.extensions.dash-to-dock extend-height`
- **窗口按钮**：`gsettings reset org.gnome.desktop.wm.preferences button-layout`
- **主题 / 图标 / 指针**：「优化 → 外观」里改回 `Yaru`
- **软件图标**：删除 `~/.local/share/applications/` 里对应的 `.desktop` 文件

---

## 致谢

所有主题、图标、指针、壁纸和 Firefox 主题都来自 [vinceliuice](https://github.com/vinceliuice) 的 WhiteSur 系列项目，本仓库只是中文安装教程和一个小脚本，不包含它们的任何文件：

- [WhiteSur-gtk-theme](https://github.com/vinceliuice/WhiteSur-gtk-theme)
- [WhiteSur-icon-theme](https://github.com/vinceliuice/WhiteSur-icon-theme)
- [WhiteSur-cursors](https://github.com/vinceliuice/WhiteSur-cursors)
- [WhiteSur-wallpapers](https://github.com/vinceliuice/WhiteSur-wallpapers)

觉得有用的话，也去给原作者点个 ⭐。
