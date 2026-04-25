# Update and upgrade system packages
apt update && apt upgrade -y

# Install git dependency
apt install git -y

# Clone the repository
git clone https://github.com/nhztech/NHZPLDI

# Navigate to the project directory and run the installer
cd NHZPLDI
bash NHZPLDI.sh
