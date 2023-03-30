################################################################################
#
# chirpstack-gateway-bridge
#
################################################################################

CHIRPSTACK_GATEWAY_BRIDGE_VERSION = v3.14.2
CHIRPSTACK_GATEWAY_BRIDGE_SITE = $(call github,chirpstack,chirpstack-gateway-bridge,$(CHIRPSTACK_GATEWAY_BRIDGE_VERSION))
CHIRPSTACK_GATEWAY_BRIDGE_LICENSE = MIT
CHIRPSTACK_GATEWAY_BRIDGE_LICENSE_FILES = LICENSE

CHIRPSTACK_GATEWAY_BRIDGE_LDFLAGS = -s -w -X main.version=$(CHIRPSTACK_GATEWAY_BRIDGE_VERSION)
CHIRPSTACK_GATEWAY_BRIDGE_GO_ENV = CGO_ENABLED=0 GOPROXY=https://goproxy.io,direct

CHIRPSTACK_GATEWAY_BRIDGE_POST_EXTRACT_HOOKS += CHIRPSTACK_GATEWAY_BRIDGE_INSTALL_DEPS

define CHIRPSTACK_GATEWAY_BRIDGE_INSTALL_DEPS
    (cd $(@D); \
        mkdir -p build; \
        $(HOST_GO_TARGET_ENV) $(CHIRPSTACK_GATEWAY_BRIDGE_GO_ENV) $(GO_BIN) install -mod=mod golang.org/x/lint/golint; \
    	$(HOST_GO_TARGET_ENV) $(CHIRPSTACK_GATEWAY_BRIDGE_GO_ENV) $(GO_BIN) install -mod=mod github.com/goreleaser/goreleaser; \
	    $(HOST_GO_TARGET_ENV) $(CHIRPSTACK_GATEWAY_BRIDGE_GO_ENV) $(GO_BIN) install -mod=mod github.com/goreleaser/nfpm \
    )
endef

define CHIRPSTACK_GATEWAY_BRIDGE_BUILD_CMDS
    (cd $(@D); \
        mkdir -p build; \
        $(HOST_GO_TARGET_ENV) $(CHIRPSTACK_GATEWAY_BRIDGE_GO_ENV) $(GO_BIN) \
            build -a -installsuffix cgo -mod=mod -ldflags "$(CHIRPSTACK_GATEWAY_BRIDGE_LDFLAGS)" \
            -o build/chirpstack-gateway-bridge cmd/chirpstack-gateway-bridge/main.go \
    )
endef

define CHIRPSTACK_GATEWAY_BRIDGE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/build/chirpstack-gateway-bridge $(TARGET_DIR)/usr/bin/chirpstack-gateway-bridge
endef


$(eval $(golang-package))
