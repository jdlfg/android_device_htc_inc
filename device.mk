################# DEVICE SPECIFIC STUFF #####################
#
# Below are some things that make sure that the rom runs
# properly on htc incredible hardware
#

# stuff common to all HTC phones
#$(call inherit-product, device/htc/common/common.mk)

$(call inherit-product, device/common/gps/gps_us_supl.mk)

DEVICE_PACKAGE_OVERLAYS += device/htc/inc/overlay

#PRODUCT_PROPERTY_OVERRIDES += 

#PRODUCT_COPY_FILES += 

# media config xml file
PRODUCT_COPY_FILES += \
    device/htc/inc/media_profiles.xml:system/etc/media_profiles.xml

PRODUCT_PACKAGES += \
    librs_jni

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# Passion uses high-density artwork where available
PRODUCT_LOCALES += hdpi

# include proprietaries
ifneq ($(USE_PROPRIETARIES),)
# if we aren't including google, we need to include some basic files
ifeq ($(filter google,$(USE_PROPRIETARIES)),)
PRODUCT_PACKAGES += \
        Provision \
        LatinIME \
        QuickSearchBox
endif

# actually include the props
$(foreach prop,$(USE_PROPRIETARIES), \
  $(if $(wildcard device/htc/inc/proprietary.$(prop)), \
    $(eval \
PRODUCT_COPY_FILES += $(shell \
        cat device/htc/inc/proprietary.$(prop) \
        | sed -r 's/^\/(.*\/)([^/ ]+)$$/device\/htc\/inc\/proprietary\/\2:\1\2/' \
        | tr '\n' ' ') \
     ), \
    $(error Cannot include proprietaries from $(prop). List file device/htc/inc/proprietary.$(prop) does not exist) \
   ) \
 )
endif
