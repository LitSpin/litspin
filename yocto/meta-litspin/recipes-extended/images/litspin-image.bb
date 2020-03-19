DESCRIPTION = "Build for LitSpin"
IMAGE_FEATURES += " ssh-server-openssh"
DISTRO_FEATURES += " wifi"

IMAGE_INSTALL = "\
    packagegroup-core-boot \
    packagegroup-core-full-cmdline \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    kernel-modules \
    linux-firmware \
    wpa-supplicant \
    startup-scripts \
    sudo \
"

inherit core-image

inherit extrausers
EXTRA_USERS_PARAMS += "\
    usermod -p $(openssl passwd litspin) root; \
"
