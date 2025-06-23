# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0
MAKEFLAGS+=--warn-undefined-variables
export MGMT_ROOT?=$(PWD)/dependencies/caravel_mgmt_soc
export MGMT_REPO_URL?=https://github.com/chipfoundry/caravel_mgmt_soc_litex.git
export MGMT_BRANCH?=Add_newfill
export PANAMAX_ROOT?=$(PWD)/dependencies/panamax
export PANAMAX_REPO_URL?=git@github.com:chipfoundry/panamax.git
export PANAMAX_BRANCH?=main
export ANALOG_ROOT?=$(PWD)/dependencies/frigate_analog
export ANALOG_REPO_URL?=git@github.com:chipfoundry/frigate_analog.git
export ANALOG_BRANCH?=add_adc_behav
export PDK_ROOT?=$(PWD)/dependencies/pdks
PRECHECK_ROOT?=${HOME}/mpw_precheck
SIM?=RTL

# PDK switch varient
export PDK?=sky130A
#export PDK?=gf180mcuC
export PDKPATH?=$(PDK_ROOT)/$(PDK)

ifeq ($(PDK),sky130A)
	SKYWATER_COMMIT=f70d8ca46961ff92719d8870a18a076370b85f6c
	export OPEN_PDKS_COMMIT?=a918dc7c8e474a99b68c85eb3546b4ed91fe9e7b
	export OPENLANE_TAG?=2023.02.23
	MPW_TAG ?= mpw-9c
endif

ifeq ($(PDK),sky130B)
	SKYWATER_COMMIT=f70d8ca46961ff92719d8870a18a076370b85f6c
	export OPEN_PDKS_COMMIT?=bdc9412b3e468c102d01b7cf6337be06ec6e9c9a
	export OPENLANE_TAG?=2023.02.23
	MPW_TAG ?= mpw-9c
endif

# Include mgmt and panamax
.PHONY: install-mcw
install-mcw:
	if [ -d "$(MGMT_ROOT)" ]; then\
		MAKE_DIR="$(PWD)"; \
		echo "Updating $(MGMT_ROOT)"; \
		cd $(MGMT_ROOT) && \
		git checkout $(MGMT_BRANCH) && git pull; \
		cd "$$MAKE_DIR"; \
	else \
		echo "Cloning $(MGMT_REPO_URL) -b $(MGMT_BRANCH)"; \
		git clone -b $(MGMT_BRANCH) $(MGMT_REPO_URL) $(MGMT_ROOT) --depth=1 --single-branch; \
	fi


.PHONY: install-panamax
install-panamax:
	if [ -d "$(PANAMAX_ROOT)" ]; then\
		MAKE_DIR="$(PWD)"; \
		echo "Updating $(PANAMAX_ROOT)"; \
		cd $(PANAMAX_ROOT) && \
		git checkout $(PANAMAX_BRANCH) && git pull; \
		cd "$$MAKE_DIR"; \
	else \
		echo "Cloning $(PANAMAX_REPO_URL) -b $(PANAMAX_BRANCH)"; \
		git clone -b $(PANAMAX_BRANCH) $(PANAMAX_REPO_URL) $(PANAMAX_ROOT) --depth=1 --single-branch; \
	fi

.PHONY: install-analog
install-analog:
	if [ -d "$(ANALOG_ROOT)" ]; then\
		MAKE_DIR="$(PWD)"; \
		echo "Updating $(ANALOG_ROOT)"; \
		cd $(ANALOG_ROOT) && \
		git checkout $(ANALOG_BRANCH) && git pull; \
		cd "$$MAKE_DIR"; \
	else \
		echo "Cloning $(ANALOG_REPO_URL) -b $(ANALOG_BRANCH)"; \
		git clone -b $(ANALOG_BRANCH) $(ANALOG_REPO_URL) $(ANALOG_ROOT) --depth=1 --single-branch; \
	fi

PYTHON_BIN=python3
.PHONY: install-ips
install-ips:
	rm -rf ./venv
	$(PYTHON_BIN) -m venv ./venv
	./venv/bin/$(PYTHON_BIN) -m pip install --upgrade pip
	./venv/bin/$(PYTHON_BIN) -m pip install wheel
	./venv/bin/$(PYTHON_BIN) -m pip install cf-ipm
	./venv/bin/$(PYTHON_BIN) -m pip install click
	./venv/bin/ipm install-dep --ipm-root ~/.ipm
	@echo "rewrite design_info for cocotb"
	# @(./venv/bin/$(PYTHON_BIN) $(PWD)/verilog/dv/setup-cocotb.py $(PWD) $(MGMT_ROOT) $(PDK_ROOT) $(PDK) $(PWD))

.PHONY: install-repos
install-repos: install-mcw install-panamax install-ips install-analog


# Install Pre-check
# Default installs to the user home directory, override by "export PRECHECK_ROOT=<precheck-installation-path>"
.PHONY: precheck
precheck:
	@git clone --depth=1 --branch $(MPW_TAG) https://github.com/efabless/mpw_precheck.git $(PRECHECK_ROOT)
	@docker pull efabless/mpw_precheck:latest

.PHONY: run-precheck
run-precheck: check-pdk check-precheck
	$(eval INPUT_DIRECTORY := $(shell pwd))
	cd $(PRECHECK_ROOT) && \
	docker run -v $(PRECHECK_ROOT):$(PRECHECK_ROOT) \
	-v $(INPUT_DIRECTORY):$(INPUT_DIRECTORY) \
	-v $(PDK_ROOT):$(PDK_ROOT) \
	-e INPUT_DIRECTORY=$(INPUT_DIRECTORY) \
	-e PDK_PATH=$(PDK_ROOT)/$(PDK) \
	-e PDK_ROOT=$(PDK_ROOT) \
	-e PDKPATH=$(PDKPATH) \
	-u $(shell id -u $(USER)):$(shell id -g $(USER)) \
	efabless/mpw_precheck:latest bash -c "cd $(PRECHECK_ROOT) ; python3 mpw_precheck.py --input_directory $(INPUT_DIRECTORY) --pdk_path $(PDK_ROOT)/$(PDK)"

.PHONY: clean
clean:
	cd ./verilog/dv/ && \
		$(MAKE) -j$(THREADS) clean

check-precheck:
	@if [ ! -d "$(PRECHECK_ROOT)" ]; then \
		echo "Pre-check Root: "$(PRECHECK_ROOT)" doesn't exists, please export the correct path before running make. "; \
		exit 1; \
	fi

check-pdk:
	@if [ ! -d "$(PDK_ROOT)" ]; then \
		echo "PDK Root: "$(PDK_ROOT)" doesn't exists, please export the correct path before running make. "; \
		exit 1; \
	fi

.PHONY: echo-var
echo-var:
	@echo $($(VAR))

###########################################################################

.PHONY: pdk-with-volare
pdk-with-volare: check-python install-volare 
	./venv/bin/volare enable ${OPEN_PDKS_COMMIT}

check-python:
ifeq ($(shell which python3),)
$(error Please install python 3.6+)
endif

.PHONY: install-volare
install-volare:
	rm -rf ./venv
	$(PYTHON_BIN) -m venv ./venv
	./venv/bin/$(PYTHON_BIN) -m pip install --upgrade --no-cache-dir pip
	./venv/bin/$(PYTHON_BIN) -m pip install --upgrade --no-cache-dir volare


###########################################################################