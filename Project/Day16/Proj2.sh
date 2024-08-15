if [ -e /etc/ansible/ansilbe.cfg ]
then
  echo "Ansilbe is Pre-Installed!"
else
  echo "Ansilbe is installing...."
  sudo apt-get install ansible -y
fi
echo
echo
echo "Establishing SSH to worker node"
echo
