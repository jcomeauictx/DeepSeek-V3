# RANK default stolen from generate.py
# ADDR is a guess, not sure what it wants, and haven't yet investigated
RANK ?= 0
ADDR ?= 127.0.0.1
OMP_NUM_THREADS ?= $(shell python3 -c \
 "from multiprocessing import cpu_count; print(cpu_count())")
DOWNLOADED := $(wildcard ../model-*.safetensors)
CONVERTED := $(wildcard ../../DeepSeek-V3-Demo/model*.safetensors)
ifeq ($(SHOWENV),)
	export RANK ADDR OMP_NUM_THREADS
else
	export
endif
install:
	pip install --break-system-packages -r requirements.txt
convert: ../../DeepSeek-V3-Demo
	touch $<
../../DeepSeek-V3-Demo: convert.py ../../DeepSeek-V3
	python3 $< \
	 --hf-ckpt-path $(word 2, $+) \
	 --save-path $@ \
	 --n-experts 256 --model-parallel 16
run:
	torchrun \
	 --nnodes 2 \
	 --nproc-per-node 8 \
	 --node-rank $(RANK) \
	 --master-addr $(ADDR) \
	 generate.py \
	  --ckpt-path ../../DeepSeek-V3-Demo \
	  --config configs/config_671B.json \
	  --interactive \
	  --temperature 0.7 \
	  --max-new-tokens 200
env:
ifeq ($(SHOWENV),)
	$(MAKE) SHOWENV=1 $@
else
	$@
endif
devices:
	python3 -c "import torch; print([torch.cuda.get_device_name(n) \
	 for n in range(torch.cuda.device_count())])"
