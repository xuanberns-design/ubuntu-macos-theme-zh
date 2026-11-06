#!/bin/bash
# 把 snap 软件的图标换成 WhiteSur 图标包里的 Mac 风格图标。
# 原理：snap 软件的 .desktop 启动文件里写死了自带图标的路径，系统图标主题管不到。
# 这里把启动文件复制一份到 ~/.local/share/applications/（系统会优先用这份），再改掉 Icon= 那一行。
# 撤销：删除 ~/.local/share/applications/ 里对应的 .desktop 文件即可。
# 以后新装了 snap 软件，重新运行一次本脚本就行。

mkdir -p ~/.local/share/applications
for f in /var/lib/snapd/desktop/applications/*.desktop; do
  name=$(basename "$f" .desktop)   # 例如 firefox_firefox
  app=${name#*_}                    # 去掉第一个下划线前的部分，得到 firefox
  case "$app" in
    firefox)     icon=safari ;;          # Firefox -> Safari
    thunderbird) icon=mail-client ;;     # Thunderbird -> Apple 邮件
    snap-store)  icon=softwarecenter ;;  # 应用中心 -> App Store
    *)
      # 其他软件：WhiteSur 里有同名图标就用，没有就跳过
      if ls ~/.local/share/icons/WhiteSur*/apps/scalable/"$app".svg >/dev/null 2>&1; then
        icon=$app
      else
        continue
      fi ;;
  esac
  cp "$f" ~/.local/share/applications/
  sed -i "s|^Icon=.*|Icon=$icon|" ~/.local/share/applications/"$name".desktop
  echo "已替换: $app -> $icon"
done
