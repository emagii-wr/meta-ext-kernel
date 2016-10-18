# This kernel bbappend assumes that "linux"
# is a subdirectory of "yocto"
# "linux" is the configured source and build tree

inherit externalsrc

EXTERNALSRC = "${YOCTO_ROOT}/linux"
EXTERNALSRC_BUILD = "${EXTERNALSRC}"

S = "${EXTERNALSRC}"

KMETA = ""
KSRC_linux_windriver_4_1 = ""
KSRC_kernel_cache = ""
SRC_URI = "" 
SRCREV = ""
SRCPV = "4.1"

do_kernel_config_externalsrc () {
	bbnote "external kernel_config_externalsrc"
}
addtask kernel_config_externalsrc after do_patch before do_kernel_configme

do_kernel_configme () {
	bbnote "external kernel_configme"
}
addtask kernel_configme after do_kernel_config_externalsrc before do_configure

do_install_append() {
	install -m 0644 ${B}/System.map ${STAGING_KERNEL_BUILDDIR}/System.map-${KERNEL_VERSION}
}

do_compile_kernelmodules() {
	bbnote "external kernel"
	unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS MACHINE
	if (grep -q -i -e '^CONFIG_MODULES=y$' ${B}/.config); then
		oe_runmake -C ${B} ${PARALLEL_MAKE} modules CC="${KERNEL_CC}" LD="${KERNEL_LD}" ${KERNEL_EXTRA_ARGS}

		# Module.symvers gets updated during the
		# building of the kernel modules. We need to
		# update this in the shared workdir since some
		# external kernel modules has a dependency on
		# other kernel modules and will look at this
		# file to do symbol lookups

		# Same directory, cp not needed

		# mkdir	-p ${STAGING_KERNEL_BUILDDIR}
		# cp Module.symvers ${STAGING_KERNEL_BUILDDIR}

	else
		bbnote "no modules to compile"
	fi
}
addtask compile_kernelmodules after do_compile before do_strip

do_shared_workdir () {
	bbnote "external shared_workdir"
}
addtask shared_workdir before do_unpack

do_clean () {
	oe_runmake -C ${B} clean
}

do_cleanall() {
	oe_runmake -C ${B} clean
}
