#!/bin/bash
# set -x

echo
echo '               Debian Web Server Setup                     '
echo '               -----------------------                     '
echo '  This will setup basic shell environment and install php  '
echo '  MariaDB and nginx to create a web server.                '

mariadb_ver='10.11'
php_ver='8.1'

if [[ $EUID -eq 0 ]]; then
    tput setaf 1;
    echo -e "\n!Running as root! User environment and utilities will not be setup."
    tput init
    echo "Launch as a user in sudo group for complete setup."
    while true
    do
        read -p "Continue as root user (y/n)? " choice
        case "$choice" in
        y|Y )   break;;
        n|N )   exit
                break;;
        * )     echo "please enter y/Y or n/N"
                ;;
        esac
    done
else
    SUDO=sudo
    ${SUDO} echo 
fi

is_wsl=$(grep -i microsoft /proc/version)
setup_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo
echo "Select / unselect options to install:"
echo '-------------------------------------'

source $setup_dir/misc/multiselect
menu=("Shell setup" "MariaDB ${mariadb_ver}" "NginX (mainline)" "PHP ${php_ver}" )
default_selections=("true" "true" "true" "true")
nothing=("false" "false" "false" "false")
multiselect selections menu default_selections

if [[ ! "${selections[*]}" =~ "true" ]]; then
    echo "Nothing selected!"
    exit
fi

if [ ${selections[0]} = "true" ]; then
    echo
    echo "Configuring system (shell utils etc.)"
    source $setup_dir/setup.d/_shell.sh
fi

if [ ${selections[1]} = "true" ]; then
    echo
    echo "Installing and configuring MariaDB ${mariadb_ver}"
    read -p "Press enter to continue"
    source $setup_dir/setup.d/_mariadb.sh
fi

if [ ${selections[2]} = "true" ]; then
    echo
    echo "Installing and configuring latest NginX"
    read -p "Press enter to continue"
    source $setup_dir/setup.d/_nginx.sh
fi

if [ ${selections[3]} = "true" ]; then
    echo
    echo "Installing and configuring PHP ${php_ver}"
    read -p "Press enter to continue"
    source $setup_dir/setup.d/_php.sh
fi

echo
echo "Restarting services ..."
[ ${selections[1]} = true ] && ${SUDO} systemctl restart mariadb
[ ${selections[2]} = true ] && ${SUDO} systemctl restart php${php_ver}-fpm
[ ${selections[3]} = true ] && ${SUDO} systemctl restart nginx

echo
echo 'Setup completed!'
echo '----------------'
echo '. ~/.profile to reload bash config.'
echo 'run setup_webutils to install website maintenance utils.'
echo 'run setup_mailhog to install a local mail catcher'
echo 'run setup_samba to install samba'
echo 'run setup_lego to install letsencrypt client'
if [ ${selections[1]} = "true" ]; then
    echo
    echo 'Consider adding mysql superuser for web based administration:'
    echo "sudo mysql -e \"CREATE USER ${USER}@'%' IDENTIFIED BY 'passwd'; \\" 
    echo "GRANT ALL PRIVILEGES ON *.* TO $USER@'%' WITH GRANT OPTION;\""
fi
echo '----------------'
echo