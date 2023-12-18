#!/bin/bash

# 设置目录数组
directories=("/home/ubuntu/c1" "/home/ubuntu/c2" "/home/ubuntu/c3" "/home/ubuntu/c4" "/home/ubuntu/c5")

# 循环监控各个目录
while true; do
  for dir in "${directories[@]}"; do
    # 获取目录中的main.js文件的全路径
    main_js_file="$dir/main.js"

    # 获取文件夹名称，作为tmux窗口的名称
    tmux_window=$(basename "$dir")

    # 检查main.js文件是否存在
    if [ -f "$main_js_file" ]; then
      # 获取tmux窗口是否存在的信息
      tmux_info=$(tmux ls | grep "$tmux_window" | grep -V grep)

      # 检查进程是否在运行
      process_info=$(ps aux | grep "$main_js_file" | grep -v grep)

      if [ -z "$process_info" ]; then
        echo "Node.js进程在目录 $dir 中中断，将在5秒后重新启动..."

        # 如果tmux窗口存在，则发送命令到该窗口执行main.js
        if [ -n "$tmux_info" ]; then
          tmux send-keys -t "$tmux_window" "node $main_js_file" C-m
        else
          echo "错误: tmux窗口 $tmux_window 不存在。"
        fi

        # 等待一段时间
        sleep 5
      else
        echo "Node.js进程在目录 $dir 中正常运行。"
      fi
    else
      echo "在目录 $dir 中找不到 main.js 文件。"
    fi
  done
done
