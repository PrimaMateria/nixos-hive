''
  echo
  echo "Configuring docker"
  echo "------------------"

  # Install docker
  # Not tested yet, because at first docker was installed
  # imperatively
  if command -v "docker"; then
    echo "docker already installed"
  else
    curl -fsSL https://get.docker.com -o "$HOME/Downloads/get-docker.sh"
    sudo sh "$HOME/Downloads/get-docker.sh"
    sudo usermod --append --groups docker primamateria
  fi
''
