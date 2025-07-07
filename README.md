A collection of config and rc files I use.

There is also a shell script to easily install all the tools I'm used to on a freshly installed box.

## Setting Up a New System

1. **Install and Configure `doas`:**

On a freshly installed box, manually install doas. For example on Debian, run the following as root:

```
apt install doas
```

Now create a configuration file for doas (/etc/doas.conf) similar to the following :

```
permit persist my_user as root
```

2. **Run the Install Script:**

Download and execute the installation script:

```
cd /tmp
wget https://raw.githubusercontent.com/achappuis/dotfiles/refs/heads/master/install.sh
chmod u+x install.sh
./install.sh
```

3. **Enjoy:**

After running the script, reboot your system. The environment should be ready to use upon restart.

```
/sbin/shutdown -r now
```
