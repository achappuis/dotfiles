#!/bin/sh

packages_dm="lightdm kitty bspwm polybar sxhkd dmenu"
packages_dev_c_emb="gcc-arm-none-eabi libnewlib-arm-none-eabi"
packages_dev_c="clangd clang-tidy clang-format cmake ninja-build gcc make $packages_dev_c_emb"
packages_dev_sh="shellcheck shfmt"
packages="vim mksh ripgrep fzf acpi bat git curl $packages_dm $packages_dev_c $packages_dev_sh"

rcfiles="vimrc mkshrc"
configs="bspwm polybar sxhkd kitty"
scripts="lock powerdown screen-config"

# Find the OS release and define a few command name for install.
os_name=$(uname -s)
if [ "$os_name" = "Linux" ]; then
	. /etc/os-release
	os_name="$ID"
fi

case $os_name in
*debian*)
	pkg="apt"
	pkg_install="$pkg -y -q install"
	sudo=doas
	mksh_path=/usr/bin/mksh
	;;
*)
	echo "Unsupported OS release"
	exit
	;;
esac

# Update the package list
update_package_list() {
  $sudo $pkg update
}

# Check if a program is in path. If not terminate script.
check_installed_or_terminate() {
  if ! which "$1" >/dev/null; then
    printf "Install and add %s in PATH before running this script.\n" "$1"
	  exit 1
  fi
}

# Check if softwares exists. If not install it.
check_and_install_package() {
	# Get the number of packages installed that match $1
	case $os_name in
	*debian*)
		num=$(dpkg -l "$1" 2>/dev/null | grep -cE '^ii')
		;;
	*)
		echo "Unsupported OS release"
		exit
		;;
	esac

	if [ "$num" -eq 1 ]; then
		printf " %-40s %s\n" "$1" "installed"
	elif [ "$num" -gt 1 ]; then
		printf " %-40s %s\n" "$1" "unexpected results, doing nothing"
	else
		printf " %-40s %s\n" "$1" "not installed, installing"
		$sudo $pkg_install "$1"
	fi
}

check_and_install_scripts() {
	if [ -e "$HOME/.local/bin/$1" ]; then
		# File exists, check if it's a symbolic link that links to the local config file
		rc_rpath=$(realpath "$HOME/.local/bin/$1")
		if [ -h "$HOME/.local/bin/$1" ] && [ "$PWD/script/$1" = "$rc_rpath" ]; then
			printf " %-40s %s\n" "$1" "installed"
		else
			printf " %-40s %s\n" "$1" "exists but won't be replaced"
		fi
	else
		# The file doesn't exist, just create a symbolic link
		ln -s "$PWD/script/$1" "$HOME/.local/bin/$1"
		printf " %-40s %s\n" "$1" "installing"
	fi
}

check_and_install_rc() {
	if [ -e "$HOME/.$1" ]; then
		# File exists, check if it's a symbolic link that links to the local config file
		rc_rpath=$(realpath "$HOME/.$1")
		if [ -h "$HOME/.$1" ] && [ "$PWD/rc/$1" = "$rc_rpath" ]; then
			printf " %-40s %s\n" "$1" "installed"
		else
			printf " %-40s %s\n" "$1" "exists but won't be replaced"
		fi
	else
		# The file doesn't exist, just create a symbolic link
		ln -s "$PWD/rc/$1" "$HOME/.$1"
		printf " %-40s %s\n" "$1" "installing"
	fi
}

check_and_install_config() {
	if [ -e "$HOME/.config/$1" ]; then
		# File exists, check if it's a symbolic link that links to the local config file
		rc_rpath=$(realpath "$HOME/.config/$1")
		if [ -h "$HOME/.config/$1" ] && [ "$PWD/config/$1" = "$rc_rpath" ]; then
			printf " %-40s %s\n" "$1" "installed"
		else
			printf " %-40s %s\n" "$1" "exists but won't be replaced"
		fi
	else
		# The file doesn't exist, just create a symbolic link
		ln -s "$PWD/config/$1" "$HOME/.config/$1"
		printf " %-40s %s\n" "$1" "installing"
	fi
}

# Check if package manager and 'sudo' are installed.
check_installed_or_terminate "$pkg"
check_installed_or_terminate "$sudo"
update_package_list

printf "Installing software packages\n"
for i in $packages; do
	check_and_install_package "$i"
done
printf "\n"

# If this is not a git repo(that is expected), clone the repo in a well known place in home and move there.
if ! git status >/dev/null 2>&1; then
	printf "Cloning repo\n"
	mkdir -p "$HOME/src"
	cd "$HOME/src" || exit
	git clone https://github.com/achappuis/dotfiles.git
	cd dotfiles || exit
fi

printf "Installing scripts\n"
for i in $scripts; do
	check_and_install_scripts "$i"
done
printf "\n"

printf "Installing RC files\n"
for i in $rcfiles; do
	check_and_install_rc "$i"
done
printf "\n"

printf "Installing Config files\n"
mkdir -p "$HOME/.config"
for i in $configs; do
	check_and_install_config "$i"
done
printf "\n"

printf "Installing Vim-Plug\n"
printf " downloading\n"
mkdir -p "$HOME/.config/vim/vim/autoload"
curl --silent -fLo plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/refs/tags/0.14.0/plug.vim
printf " verifying\n"
sha512sum --quiet --strict --ignore-missing --check check.sha512
if [ $? -ne 0 ]; then
  printf "Unexpected sha512 for plug.vim\n"
  exit 1
fi
mv plug.vim "$HOME/.config/vim/vim/autoload"
printf " installing vim plugins\n"
vim +PlugUpdate +qall
printf "\n"

printf "Updating shell\n"
$sudo chsh -s "$mksh_path" "$USER"
