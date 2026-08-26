# dns-switch

A bash TUI and CLI for managing DNS over TLS (DoT) and DNSSEC via `systemd-resolved` and `NetworkManager`.

## Features

- Interactive TUI for provider selection alongside CLI arguments.
- Benchmarks TCP latency across providers to find and switch to the fastest.
- Falls back to default DNS if DoT validation fails.
- Reapplies DoT on network state changes like WiFi reconnects or VPNs.
- Written in bash using `resolvectl`, without extra package dependencies.
- Handles `sudo` internally, checks for missing tools on launch, and prevents root installs from breaking config paths.

## Requirements
- `bash` >= 5.0
- `systemd-resolved`
- `NetworkManager`
- `resolvectl`

## Installation

### Direct
This downloads the script, sets up default providers, and configures the system hooks.

Using `curl`:
```bash
curl -sSL https://raw.githubusercontent.com/dyokism/dns-switch/main/src/install.sh | bash
```

Or using `wget`:
```bash
wget -qO- https://raw.githubusercontent.com/dyokism/dns-switch/main/src/install.sh | bash
```

### Manual
```bash
# 1. Copy script to PATH
cp src/dns-switch ~/.local/bin/dns-switch
chmod +x ~/.local/bin/dns-switch

# 2. Setup providers
mkdir -p ~/.config/dns-switch
cp src/providers.conf ~/.config/dns-switch/providers.conf

# 3. Setup system hooks
dns-switch install
```

## Usage

```
Usage:
  dns-switch                           Open interactive TUI picker
  dns-switch <provider>                Switch to specific DoT provider
  dns-switch auto                      Benchmark and switch to fastest provider
  dns-switch bench                     Benchmark DoT TCP latency across all providers
  dns-switch default                   Revert to router / DHCP DNS
  dns-switch status                    Show active provider and resolution status
  dns-switch install                   Configure system hooks (requires sudo)
  dns-switch uninstall                 Remove system hooks (requires sudo)
  dns-switch version, --version        Show version
  dns-switch help, -h, --help          Show this help message
```

## Configuration

Providers are configured in `~/.config/dns-switch/providers.conf`.
Format: `name=ip1,ip2`
Example:
```ini
cloudflare=1.1.1.1#one.one.one.one,1.0.0.1#one.one.one.one
```

## Uninstallation

```bash
dns-switch uninstall
rm ~/.local/bin/dns-switch
rm -rf ~/.config/dns-switch
```

## License
MIT License. See `LICENSE` for details.
