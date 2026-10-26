<div align="center">
  # dns-switch
  *DNS over TLS (DoT) and DNSSEC switcher for systemd-resolved.*

  [Features](#features) • [Requirements](#requirements) • [Installation](#installation) • [Usage](#usage) • [Configuration](#configuration) • [Uninstallation](#uninstallation)
</div>

`dns-switch` is a small Bash utility for managing DNS over TLS (DoT) and DNSSEC through `systemd-resolved` and `NetworkManager`. It works as an interactive terminal picker and as a standard CLI, letting you switch resolvers, test latency, or drop back to default DHCP DNS when needed.

## Features

- Terminal picker with arrow keys or `j`/`k`, plus in-menu TCP latency probing via `b`.
- Automatic fallback to router DNS if DoT fails, avoiding dropped connections.
- Benchmarks TCP handshakes on port 853 across providers to pick the lowest latency option (`auto` or `bench`).
- Dual-stack IPv4 and IPv6 addresses with automatic fallback.
- Scoped to active default route interfaces; ignores Docker, virtual bridges, and VPN links.
- NetworkManager dispatcher script to reapply settings after network reconnections.

## Requirements

- `bash` >= 5.0
- `systemd-resolved` (active service)
- `resolvectl`
- `ip` (`iproute2`)

## Installation

### Automatic (curl)
```bash
curl -fsSL https://raw.githubusercontent.com/dyokism/dns-switch/main/src/install.sh | bash
```

### Automatic (wget)
```bash
wget -qO- https://raw.githubusercontent.com/dyokism/dns-switch/main/src/install.sh | bash
```

### Manual
```bash
# 1. Install binary
cp src/dns-switch ~/.local/bin/dns-switch
chmod +x ~/.local/bin/dns-switch

# 2. Install default providers configuration
mkdir -p ~/.config/dns-switch
cp src/providers.conf ~/.config/dns-switch/providers.conf

# 3. Configure system hooks (requires sudo)
dns-switch install
```

## Usage

```text
Usage:
  dns-switch [command|provider]

Commands:
  (default)           Open interactive TUI picker
  <provider>          Switch to specific provider (e.g. cloudflare, quad9)
  auto                Benchmark and select fastest provider
  bench               Benchmark TCP latency across all providers
  status              Show active provider and resolution status
  default             Revert to router / DHCP DNS

System Hooks:
  install             Configure system hooks (sudo)
  uninstall           Remove system hooks (sudo)

Flags:
  -h, --help          Show this help message
  -v, --version       Show version
```

## Configuration

Providers are defined in `~/.config/dns-switch/providers.conf` in `name=ip1#sni,ip2#sni` format. Order determines fallback priority.

```ini
cloudflare=1.1.1.1#one.one.one.one,1.0.0.1#one.one.one.one,2606:4700:4700::1111#one.one.one.one
quad9=9.9.9.9#dns.quad9.net,149.112.112.112#dns.quad9.net,2620:fe::fe#dns.quad9.net
adguard=94.140.14.14#dns.adguard-dns.com,94.140.15.15#dns.adguard-dns.com
```

## Uninstallation

```bash
dns-switch uninstall
rm -f ~/.local/bin/dns-switch
rm -rf ~/.config/dns-switch
```
