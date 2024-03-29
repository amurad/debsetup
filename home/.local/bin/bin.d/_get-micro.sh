echo
echo "Updating micro editor..."

repo="zyedidia/micro"

setup_alternatives () {
  if command -v micro &> /dev/null; then
    micro_dir=$(dirname $(which micro))
    if ! update-alternatives --list editor | grep "micro" >/dev/null; then
      ${SUDO} update-alternatives --set editor ${micro_dir}/micro
    else
      ${SUDO} update-alternatives --install /usr/bin/editor editor ${micro_dir}/micro 50
    fi
  fi
}

if command -v micro &> /dev/null; then
  cur_version="$(micro -version | grep -Eo "[0-9]+\.[0-9]+(\.[0-9]+)?")"
else
  cur_version="0.0"
fi

new_version="$(github_latest_release_num $repo)"
file=micro-"${new_version}-${arch}.deb"

if [ "${cur_version}" \> "${new_version}" ] || [ "${cur_version}" = "${new_version}" ]; then
    printf "Already at latest version: micro ${cur_version}\n"
else
    # get the package
    wget -nv --show-progress "https://github.com/${repo}/releases/download/v${new_version}/${file}"
    # install it
    ${SUDO} dpkg -i $file
    # remove the file
    rm -vf $file
    setup_alternatives
    printf "Press enter to continue "
    read key
fi
