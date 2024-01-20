# NHZ-PROOT-LINUX-DISTRO-INSTALLER

_   __  __  __  _____      ____    __      ____    ______
   / | / / / / / / /__  /     / __ \  / /     / __ \  /_   _/
  /  |/ / / /_/ /    / /     / /_/ / / /     / / / /   / /
 / /|  / / __  /    / /___  / ____/ / /___  / /_/ / _ / /_
/_/ |_/ /_/ /_/    /_____/ /_/     /____ / /_____/ /_____/

           (NHZ-PROOT-LINUX-DISTRO-INSTALLER)
                  Author: Nick Codings
                  
**# Install Linux Distributions in Termux Effortlessly!**

This Bash script empowers you to install various Linux distributions within Termux, running them seamlessly on your Android device without requiring root access. Leveraging PRoot, it automates the process of downloading, configuring, and launching distros, offering a convenient way to expand your mobile capabilities.

**## Key Features**

- **Automated Installation:** Effortlessly handles the download and setup of rootfs files for supported distros.
- **Architecture Awareness:** Detects your device's architecture and ensures compatibility.
- **PRoot Integration:** Utilizes PRoot to create isolated Linux environments without system-level modifications.
- **User-Friendly Interface:** Guides you through the installation process with clear prompts and informative messages.
- **Customizable Login Scripts:** Generates easy-to-use scripts for launching installed distros.

**## Installation**

1. **Prerequisites:**
   - Ensure you have Termux installed on your Android device.
   - Grant Termux storage permissions if prompted.

2. **Clone the Repository:**
   ```bash
   git clone https://github.com/your-username/NHZ-PROOT-LINUX-DISTRO-INSTALLER
   ```

3. **Run the Script:**
   ```bash
   cd NHZ-PROOT-LINUX-DISTRO-INSTALLER

   bash nhz-proot-linux-distro-installer.sh
   ```

**## Usage**

1. **Provide Rootfs Link:** When prompted, enter the rootfs link for the distro you wish to install.
2. **Specify Distro Name:** Choose a name for your distro (used for the login script).
3. **Follow Prompts:** The script will handle the rest, providing feedback along the way.

**## Launching the Distro**

```bash
bash ubuntu.sh  # (Replace "ubuntu" with your chosen distro name)
```

**## Additional Information**

- **Copyright and Licensing:** [State copyright information and license terms here.]
- **Contributions:** [Outline guidelines for contributions and collaboration.]
- **Known Issues and Limitations:** [List any known issues or limitations.]
- **Acknowledgments:** [Credit third-party components or resources used.]

**## Get Involved!**

- Provide feedback or suggestions for improvements.
- Contribute code or translations.
- Share your experiences and help others in the community.

**## Enjoy Linux on the Go!**

Let's explore the possibilities of Linux within Termux together!
