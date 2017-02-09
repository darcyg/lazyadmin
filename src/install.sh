#!/bin/bash

installtarball=./installer-test.tar.gz


# Installer function(s)

function set_symlink_dir {

	echo
	echo
	echo "Please specify where to symlink, so that you can start la-menus as a command."
	echo "If you want no symlinking, just type \"none\" (without the quotes)"
	echo
    read -p "> " symlinkdir
	while true; do
		if [[ "$symlinkdir" == "none" ]]; then
			symlinking="false"
			echo
			echo "No symbolic link will be created."
			sleep 1
			break
		else
			if [[ -d $symlinkdir ]]; then
				echo
				echo "A symbolic link will be created in"
				echo
				echo "$symlinkdir"
				symlinking="true"
				sleep 1
				break
			else
				echo
				echo "Not a valid directory, try again."
				echo
				read -p "> " symlinkdir
			fi
		fi

	done
}



# Start install script

clear

if [[ -f $installtarball ]]; then
    echo
    echo "Found archive..."
else
    echo
    echo "Archive missing or broken, exiting..."
    exit 65
fi


echo
echo "This is the installer for Lazy Admin, a tool for admins who are lazy."
echo
echo "By the time you've finished customozing it, you will know why it is bad to be "
echo "lazy, but for now, please provide some valuable details for installation".
echo 
echo "First I need you to tell me, wether you want me to create a user" 
echo "specific installation in $HOME/.LazyAdmin/, or install globally"
echo "in /opt/LazyAdmin/"
echo
echo "1 - Install for current user only"
echo "2 - Install for all users"
read -p "> " -n 1 installtype


while true; do

	case $installtype in

	1)
		installtype="local"
		installdir="$HOME"
		break
		;;
	2)
		installtype="global"
		installdir="/opt/LazyAdmin/"
		break
		;;
	*)
	echo
	echo "Come on, it's a simple enough choice. 1 or 2?"
	echo
	read -p "Choose 1, or 2> " -n 1 installtype
	;;

	esac
done

echo
echo "You will find your starter file named \"la-menus\" in"
echo
echo "$installdir"
echo
echo "when this installer finishes."
echo
echo "Please confirm if it's OK to symlink the starter file in /usr/local/bin"
echo
read -p "(y/n) > " -n 1 isitok

while true; do

	case $isitok in

	"y" | "Y")
	    echo
	    echo "A symlink will be created in /usr/local/bin"
	    echo
		symlinking="true"
		symlinkdir="/usr/local/bin"
		break
		;;
	"n" |"N")
		set_symlink_dir
		break
		;;
	*)
	echo
	echo "Please go again. Y or N?"
	echo
	read -p "(y/n) > " -n 1 isitok
	;;

	esac
done


if [[ "$installdir" == "$HOME" ]]; then

    installdir="$HOME/.LazyAdmin"
    
fi


echo
echo "Extracting Lazy Admin system and user files..."


if [[ -d "$HOME/.config/LazyAdmin/" ]]; then
	echo
	echo "A user config directory already exists. Can I purge it?"
    echo "This will delete all your previous configurations, so be careful."
    echo "(If you are upgrading from a previous version, it's probably better to say no...)"
    echo "Type \"yes\" (without the quotes) to proceed with purging, or anything else to" 
    echo "keep the config files"
    echo
	read -p "(yes/no) > " isitok
	if [[ "$isitok" == "yes" || "$isitok" == "YES" || "$isitok" == "Yes" ]]; then
		echo
		echo
		echo "Purging old configs..."
		mv "$HOME/.config/LazyAdmin/user" "$HOME/.config/LazyAdmin/user.OLD"
		echo
		echo "Just kidding. I renamed the old configs and preserved it in case you'd change you mind later'"
		sleep 1
	else
		echo
		echo
		echo "Using old configs can lead to unexpected behavour..."
		echo "if you encounter problems, run the installer again, and purge old config files"
		sleep 1
	fi

else
	echo
	echo "Creating config directory for user..."
	mkdir "$HOME/.config/LazyAdmin/"
	sleep 1
	echo
	echo "Done."
	sleep 1
fi

userfilesdir="$HOME/.config/LazyAdmin"

echo
echo "Extracting files..."



if [[ $installtype = "local" ]]; then

   if [[ -d "$HOME/.LazyAdmin/" ]]; then
   
        rm -rf "$HOME/.LazyAdmin/"
   
   fi

   mkdir "$HOME/.LazyAdmin/"
   installdir="$HOME/.LazyAdmin"

else 

  echo
  echo "Attempting to access /opt. Need root"
  echo
  
  if [[ -d "/opt/LazyAdmin/" ]]; then
   
       sudo rm -rf "/opt/LazyAdmin/"
   
   fi
  
  
  sudo mkdir "/opt/LazyAdmin/"
  sudo mkdir "/opt/LazyAdmin/res/"
  installdir="/opt/LazyAdmin"
  
fi



tar xvzC "$installdir" -f $installtarball "core"
tar xvzC "$installdir" -f $installtarball "plugins"
tar xvzC "$installdir" -f $installtarball "res"
tar xvzC "$userfilesdir" -f $installtarball "user"


sed -i "s|PLUGINSDIRPLACEHOLDER|PLUGINS_DIR=\"$installdir/plugins\"|" "$userfilesdir/user/function-aliases.la"
sed -i "s|PLUGINSDIRPLACEHOLDER|PLUGINS_DIR=\"$installdir/plugins\"|" "$installdir/plugins/setup-functions.la"
sed -i "s|USERDIRPLACEHOLDER|USER_DIR=\"$userfilesdir/user\"|" "$userfilesdir/user/function-aliases.la"
sed -i "s|RESDIRPLACEHOLDER|USER_DIR=\"$installdir/res\"|" "$userfilesdir/user/function-aliases.la"
sed -i "s|PLUGINSDIRPLACEHOLDER|PLUGINS_DIR=\"$installdir/plugins\"|" "$userfilesdir/user/user-functions.la"
sed -i "s|USERDIRPLACEHOLDER|USER_DIR=\"$userfilesdir/user\"|" "$installdir/res/menu-defaults.la"


RESDIRPLACEHOLDER

echo 
echo "Extracing finished."
echo

if [[ $installtype="local" ]]; then

    launcherdir="$HOME"

else

    launcherdir=$"installdir"


fi


echo "I will put the starter file in $installdir"
sleep 1


if [[ -f "$launcherdir/la-menus" ]]; then
	echo
	echo "Starter file already exists. Removing..."

	rm $launcherdir/la-menus
	sleep 1
fi

echo
echo "Creating new starter file:"
echo
echo "$launcherdir/la-menus"



tar xvzC "$launcherdir" -f $installtarball --strip=1 "launcher/la-menus"
sed -i "s|INCLUDESPLACEHOLDER|. \"$installdir/res/menu-defaults.la\"\n. \"$installdir/core/menu-functions.la\"\n. \"$userfilesdir/user/function-aliases.la\"|" "$launcherdir/la-menus"


sleep 1

echo
echo "Done."
echo

echo "Attempting to make la-menus executable."
echo "(If this step fails, you will need to do this manually)"

chmod ug+rwx "$launcherdir/la-menus"

sleep 1
echo
echo "Done (unless you got an error here)."
echo
echo "Cleaning up temporary files..."



echo
echo "Done."

sleep 1
if [[ "$symlinking" == "true" ]]; then
	echo
	echo "Now creating symlink in  $symlinkdir."
	echo "It is likely a system directory, so sudo will be used..."
	echo

    if [[ -f "$symlinkdir/la-menus" ]]; then
    
    
        sudo rm "$symlinkdir/la-menus"
    
    fi

	sudo ln -s "$launcherdir/la-menus" "$symlinkdir/la-menus"
	sleep 1
	echo
	echo "All done!"
	echo "You can now start Lazy Admin by Typing 'la-menus' as a command."
	echo "Check help for customizaton info and options."
else
	echo
	echo "All done!"
	echo "You can now start lazy Admin by typing (sh) $launcherdir/la-menus"
	echo "Check help for customizaton info and options."

fi


# Get rid of the evidence...

rm $installtarball
rm ./install.sh

echo
echo "Now press anything to go back to doing whatever it was you did before..."
read -n 1 -s keypress

exit 0






