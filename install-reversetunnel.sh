#!/bin/bash

# ReverseTunnel Auto Installer & Runner
# Download, install and run in one command

clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ⚡ ReverseTunnel Manager - Auto Installer ⚡"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check root
if [[ $EUID -ne 0 ]]; then
    echo "❌ This script must be run as root"
    echo "Please run: sudo bash install.sh"
    exit 1
fi

echo "📥 Downloading ReverseTunnel..."

# Try wget first, then curl
if command -v wget &> /dev/null; then
    if ! wget -q --show-progress https://your-domain.com/reversetunnel.sh -O /usr/local/bin/reversetunnel 2>/dev/null; then
        # Fallback: Create the script locally
        echo "⚠️  Download from server failed, installing from local copy..."
        
        # For testing, you can place the script content here
        # Or host it on your server
        
        if [ ! -f "./reversetunnel.sh" ]; then
            echo "❌ Installation failed. Please make sure reversetunnel.sh is available."
            exit 1
        fi
        
        cp ./reversetunnel.sh /usr/local/bin/reversetunnel
    fi
elif command -v curl &> /dev/null; then
    if ! curl -# -L https://your-domain.com/reversetunnel.sh -o /usr/local/bin/reversetunnel 2>/dev/null; then
        echo "⚠️  Download from server failed, installing from local copy..."
        
        if [ ! -f "./reversetunnel.sh" ]; then
            echo "❌ Installation failed. Please make sure reversetunnel.sh is available."
            exit 1
        fi
        
        cp ./reversetunnel.sh /usr/local/bin/reversetunnel
    fi
else
    echo "❌ Neither wget nor curl found. Please install one of them first."
    exit 1
fi

echo "⚙️  Setting up..."
chmod +x /usr/local/bin/reversetunnel

# Create aliases
echo "🔗 Creating command aliases..."

# For bash
if [ -f ~/.bashrc ]; then
    if ! grep -q "alias rtunnel=" ~/.bashrc 2>/dev/null; then
        echo "alias rtunnel='reversetunnel'" >> ~/.bashrc
    fi
    if ! grep -q "alias rt=" ~/.bashrc 2>/dev/null; then
        echo "alias rt='reversetunnel'" >> ~/.bashrc
    fi
fi

# For zsh
if [ -f ~/.zshrc ]; then
    if ! grep -q "alias rtunnel=" ~/.zshrc 2>/dev/null; then
        echo "alias rtunnel='reversetunnel'" >> ~/.zshrc
    fi
    if ! grep -q "alias rt=" ~/.zshrc 2>/dev/null; then
        echo "alias rt='reversetunnel'" >> ~/.zshrc
    fi
fi

# Create symlinks for easy access
ln -sf /usr/local/bin/reversetunnel /usr/local/bin/rtunnel 2>/dev/null
ln -sf /usr/local/bin/reversetunnel /usr/local/bin/rt 2>/dev/null

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Installation Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Available commands:"
echo "  • reversetunnel"
echo "  • rtunnel"
echo "  • rt"
echo ""
echo "🚀 Starting ReverseTunnel Manager..."
sleep 1

# Run ReverseTunnel automatically
exec /usr/local/bin/reversetunnel
