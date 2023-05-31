cd ~/Applications
git clone git@github.com:st-f/adb-helper.git
cd adb-helper
chmod 755 adb-helper
echo 'alias adb-helper="sh ~/Applications/adb-helper/adb-helper.sh"' >> ~/.bash_profile
source ~/.bash_profile
