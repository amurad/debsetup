### nginx ###
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | ${SUDO} tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
gpg --dry-run --quiet --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/debian $debian_release nginx\n" \
    | ${SUDO} tee /etc/apt/sources.list.d/nginx.list
printf "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | ${SUDO} tee /etc/apt/preferences.d/99nginx

${SUDO} apt update
${SUDO} apt -y install nginx

${SUDO} cp -rbv $setup_dir/etc/nginx/* /etc/nginx
if [ -f /etc/nginx/conf.d/default.conf ]; then
    ${SUDO} mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf~
fi

### create webroot ###
${SUDO} mkdir -p /srv/www/_local
printf "$(hostname)\n" | ${SUDO} tee /srv/www/_local/index.html
${SUDO} cp -rv $setup_dir/www/* /srv/www/_local/

### set permissions ###
$HOME/.local/bin/wmod /srv/www
