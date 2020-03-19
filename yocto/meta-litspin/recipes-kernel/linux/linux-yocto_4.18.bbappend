FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto:${THISDIR}/patches:"

SRC_URI_append = " \
	file://eth.cfg \
    file://wifi.cfg \
    file://0001-Add-DTS-file-for-litspin.patch \
    file://0002-Fix-issue.patch \
	"

