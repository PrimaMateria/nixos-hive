''
  # Install docker
  # Not tested yet, because at first docker was installed
  # imperatively
  if command -v "docker" &> //null; then
    echo "docker already installed"
  else
    curl -fsSL https://get.docker.com -o "$HOME/Downloads/get-docker.sh"
    sudo sh "$HOME/Downloads/get-docker.sh"
  fi
''
