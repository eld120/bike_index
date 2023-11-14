

# for redis
sudo apt install -y lsb-release curl gpg ca-certificates gnupg
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

# Nodejs install
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=16
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
echo . "$HOME/.asdf/asdf.sh" >> ~/.bashrc
./lol_source # runs source ~/.bashrc in an interactive shell

sudo apt update
sudo apt install -y nodejs
sudo apt update 
sudo apt install -y  postgresql imagemagick dirmngr gawk redis nodejs build-essential dos2unix autoconf patch rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev libpq-dev postgresql-contrib
# # sudo snap install ruby --channel=2.7/stable --classic
sudo npm install --global yarn

cd bike_index && find ./ -type f -exec dos2unix {} \;
# # sudo systemctl restart postgresql.service
# sudo systemctl enable postgresql

./lol_source # runs source ~/.bashrc in an interactive shell
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby 2.7.8

bike_index/bin/setup