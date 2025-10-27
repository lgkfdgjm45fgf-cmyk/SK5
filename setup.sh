#!/bin/bash

# 安装 Rust
echo "[INFO] 安装 Rust 工具链..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# 加载环境变量
echo "[INFO] 配置 Rust 环境变量..."
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 验证 Rust 是否成功安装
if command -v rustc >/dev/null && command -v cargo >/dev/null; then
    echo "[INFO] Rust 安装成功！"
else
    echo "[ERROR] Rust 安装失败！请检查脚本。"
    exit 1
fi

# 下载 Nexus CLI
echo "[INFO] 下载并安装 Nexus CLI..."
nohup curl https://cli.nexus.xyz/ | sh -s -- -y > output.log 2>&1 &

# 检查日志文件
if [ -f "output.log" ]; then
    echo "[INFO] Nexus CLI 下载日志："
    tail -n 10 output.log
else
    echo "[ERROR] 未找到下载日志，请检查下载是否成功。"
fi
