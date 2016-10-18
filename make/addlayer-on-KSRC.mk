# Support building kernel from a kernel in the filesystem instead of git
ifneq ($(KSRC),)
YOCTO_ROOT	:= $(REPOTOP)
YOCTO_LAYERS	:= $(YOCTO_ROOT)/layers
KERNEL_REPO	:= linux
KERNEL_SOURCE	:= $(YOCTO_ROOT)/$(KERNEL_REPO)

# Only if we have kernel source available.
ifneq (,$(wildcard $(KERNEL_SOURCE)))
# Add layer with recipe for building from yocto/linux
LAYERS          += $(REPOTOP)/layers/meta-ext-kernel
ifeq (,$(wildcard $(KERNEL_SOURCE)/.config))
$(error ERROR: ***** You have to make #_defconfig in the kernel source)
endif
else
$(info WARNING: ***** clone $(KERNEL_REPO) if you want to build with external source)
endif
endif
