URL := https://huggingface.co/deepseek-ai/DeepSeek-V3-Base/resolve/main
PATTERN := model-%05d-of-000163.safetensors
DOWNLOADED = $(wildcard model-00[0-9][0-9][0-9]-of-000163.safetensors)
CONVERTED = $(wildcard ../DeepSeek-V3-Demo/model*.safetensors)
HAVE = $(words $(DOWNLOADED))
REQUIRED := 5
MAKE ?= make -s
ifeq ($(SHOWENV),)
	# no exports
else
	export
endif
all: install download convert run
install run:
	$(MAKE) -C inference $@
download:
	if [ "$(HAVE)" != "$(REQUIRED)" ]; then \
		for n in $$(seq 1 $(REQUIRED)); do \
			$(MAKE) $$(printf $(PATTERN) $$n).download; \
		done; \
	else \
		echo required model files already downloaded >&2; \
	fi
%.download:
	wget -N $(URL)/$*
convert devices:
	$(MAKE) -C inference $@
env:
ifeq ($(SHOWENV),)
	$(MAKE) SHOWENV=1 $@
else
	$@
	$(MAKE) -C inference $@
endif
login:
	if [ ! -s "$(HOME)/.cache/huggingface/token" ]; then \
	 huggingface-cli login; \
	fi
llama3: login
	# https://stackoverflow.com/a/78427080/493161
	pip install --break-system-packages \
	 transformers ctranslate2 OpenNMT-py==2.* sentencepiece sacremoses
	ct2-transformers-converter \
	 --model meta-llama/Meta-Llama-3-8B-Instruct \
	 --output_dir Meta-Llama-3-8B-Instruct \
	 --force \
	 --quantization int8
