# Recipe created by recipetool
# This is the basis of a recipe and may need further editing in order to be fully functional.
# (Feel free to remove these comments when editing.)

# WARNING: the following LICENSE and LIC_FILES_CHKSUM values are best guesses - it is
# your responsibility to verify that the values are complete and correct.
#
# The following license files were not able to be identified and are
# represented as "Unknown" below, you will need to check them yourself:
#   hostapd-0.8/COPYING
#
# NOTE: multiple licenses have been detected; they have been separated with &
# in the LICENSE value for now since it is a reasonable assumption that all
# of the licenses apply. If instead there is a choice between the multiple
# licenses then you should change the value to separate the licenses with |
# instead of &. If there is any doubt, check the accompanying documentation
# to determine which situation is applicable.
LICENSE = "GPLv2 & Unknown"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7 \
                    file://hostapd-0.8/COPYING;md5=c54ce9345727175ff66d17b67ff51f58"

SRC_URI = "git://github.com/lwfinger/rtl8188eu.git;protocol=https"

# Modify these as desired
PV = "0.1+git${SRCPV}"
SRCREV = "e90178b6563bd72d9068880b22623a0859c653d8"

S = "${WORKDIR}/git"

inherit module

EXTRA_OEMAKE += "KSRC=${STAGING_KERNEL_DIR}"


