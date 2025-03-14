URL := https://huggingface.co/deepseek-ai/DeepSeek-V3-Base/resolve/main
PATTERN := model-%05d-of-000163.safetensors
DOWNLOADED = $(wildcard model-00[0-9][0-9][0-9]-of-000163.safetensors)
HAVE = $(words $(DOWNLOADED))
REQUIRED := 4
MAKE := make -s
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
convert:
	$(MAKE) -C inference $@
env:
ifeq ($(SHOWENV),)
	$(MAKE) SHOWENV=1 $@
else
	$@
endif
