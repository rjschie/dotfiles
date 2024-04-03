
mac: xcode brew rust symlink

brew:
	command -v brew &>/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
	brew update
	brew upgrade
	brew bundle --file=$(CURDIR)/Brewfile

xcode:
	xcode-select install || true

rust:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

symlink:
	#

.SILENT: brew xcode rust symlink
