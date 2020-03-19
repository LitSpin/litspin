LICENSE="CLOSED"

SRC_URI="\
        file://start-wifi.sh \
        "

#RDEPENDS_${PN} = "initscripts"

do_install () {
	install -d ${D}${sysconfdir}/init.d

    install ${WORKDIR}/start-wifi.sh ${D}${sysconfdir}/init.d
}

inherit update-rc.d

INITSCRIPT_NAME="start-wifi.sh"
INITSCRIPT_PARAMS="start 99 2 3 4 5 ."
