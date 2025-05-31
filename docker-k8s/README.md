# 本地開發環境架設與自動化設定紀錄

## 📦 架構概述

* 伺服器：Mac

* 開發平台：Docker Desktop 自帶 Kubernetes

* Gateway：Envoy Gateway 搭配 Gateway API (Kubernetes Gateway)

* 外部存取：Cloudflare Tunnel 建立 dns 紀錄

* 內部存取：Tailscale VPN

* 使用場景：平日 MBP 放宿舍作為伺服器，自動連線與公開 Gateway，遠端以平板透過 VSCode Remote 開發

## 🐳 安裝 Docker + Kubernetes

1. 安裝 Docker Desktop

從 Docker 官網 下載並安裝。

啟用內建的 Kubernetes：

Docker Desktop > Settings > Kubernetes > Enable Kubernetes ✅

## 🌐 Cloudflare Tunnel 設定

### 安裝 [cloudflared](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/)

``` zsh
brew install cloudflared
```

### 建立 Tunnel

1. 指令

    ``` zsh
    cloudflared tunnel login
    cloudflared tunnel create my-tunnel
    ```

2. 建立設定檔 ~/.cloudflared/config.yml

    ``` yaml
    tunnel: my-tunnel
    credentials-file: /Users/YOU/.cloudflared/my-tunnel.json

    ingress:
      - hostname: example.example.com
        service: http://localhost:8080
      - service: http_status:404
    ```

3. 啟動 tunnel（測試用）

    ``` zsh
    cloudflared tunnel run my-tunnel
    ```

## ☸️ Kubernetes Gateway 設定摘要

1. gateway.networking.k8s.io/v1 Gateway listener 指定k8s Gateway 要用的port

2. k8s port-forward 開發 1. 的 port 到 localhost 層級 與 ~/.cloudflared/config.yml port 對應

## ⚙️ 自動化啟動 Script 與 Launchd 設定

### 建立 Shell Script ~/bin/start-tunnel.sh

        ``` zsh
        #!/bin/zsh

        # 檢查是否已啟動 port-forward
        if ! lsof -i :8080 > /dev/null; then
          echo "[INFO] Port 8080 not bound, starting port-forward..." >> /tmp/tunnel.log
          kubectl port-forward svc/envoy-gateway -n gateway 8080:8080 >> /tmp/portforward.log 2>&1 &
        else
          echo "[INFO] Port 8080 already in use, skipping port-forward" >> /tmp/tunnel.log
        fi

        # 啟動 cloudflared tunnel
        echo "[INFO] Starting cloudflared tunnel my-tunnel..." >> /tmp/tunnel.log
        cloudflared tunnel run my-tunnel >> /tmp/cloudflared.log 2>&1
        ```

* 記得改權限

    ``` zsh
    chmod +x ~/bin/start-tunnel.sh
    ```

### launchd 腳本

1. ~/Library/LaunchAgents/user.tunnel.plist

    ``` xml
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>user.tunnel</string>

      <key>ProgramArguments</key>
      <array>
        <string>/Users/YOU/bin/start-tunnel.sh</string>
      </array>

      <key>RunAtLoad</key>
      <true/>

      <key>KeepAlive</key>
      <true/>

      <key>StandardOutPath</key>
      <string>/tmp/tunnel.log</string>
      <key>StandardErrorPath</key>
      <string>/tmp/tunnel.err</string>
    </dict>
    </plist>
    ```

2. 啟動方式

    ``` zsh
    launchctl load ~/Library/LaunchAgents/user.tunnel.plist
    ```

### 📑 日誌位置

類型 | 路徑
| cloudflared | /tmp/cloudflared.log |
| port-forward | /tmp/portforward.log |
| 啟動流程 | /tmp/tunnel.log |

### ✅ 啟動效果

* 開機後自動啟動 Docker Desktop + K8s

* 自動 port-forward 對 envoy gateway 開通 8080

* 自動啟動 Cloudflare Tunnel 串接至網域

遠端可透過網域公開 API，內網則使用 Tailscale 私網存取
