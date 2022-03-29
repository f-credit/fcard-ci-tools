git config credential.helper store

echo -e "https://tech-fondeadora:$ACCESS_TOKEN@github.com" | sudo tee -a /etc/git-credentials
# echo -e "https://tech-fondeadora:$ACCESS_TOKEN@github.com" | sudo tee -a .git/credentials

# echo -e "[url \"https://$ACCESS_TOKEN@github.com/\"]\n\tinsteadOf = ssh://git@github.com/" | sudo tee -a /etc/gitconfig
echo -e "[url \"https://$ACCESS_TOKEN@github.com/\"]\n\tinsteadOf = ssh://git@github.com/" | sudo tee -a ~/.gitconfig
# echo -e "[url \"https://$ACCESS_TOKEN@github.com/\"]\n\tinsteadOf = ssh://git@github.com/" | sudo tee -a .git/config

# echo -e "[url \"https://$ACCESS_TOKEN@github.com/\"]\n\tinsteadOf = git+ssh://git@github.com/" | sudo tee -a /etc/gitconfig
echo -e "[url \"https://$ACCESS_TOKEN@github.com/\"]\n\tinsteadOf = git+ssh://git@github.com/" | sudo tee -a ~/.gitconfig
# echo -e "[url \"https://$ACCESS_TOKEN@github.com/\"]\n\tinsteadOf = git+ssh://git@github.com/" | sudo tee -a .git/config
