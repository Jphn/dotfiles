function update --description "Update APT, Snap, Flatpak, and Homebrew"
    echo "📦 Updating APT packages..."
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean

    if command -q snap
        echo "🫰 Updating Snap packages..."
        sudo snap refresh
    end

    if command -q flatpak
        echo "🧊 Updating Flatpak packages..."
        flatpak update -y && flatpak uninstall --unused -y
    end

    if command -q brew
        echo "🍺 Updating Homebrew packages..."
        brew update && brew upgrade && brew cleanup
    end

    echo "✅ All systems updated!"
end
