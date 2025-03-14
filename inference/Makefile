# RANK default stolen from generate.py
# ADDR is a guess, not sure what it wants, and haven't yet investigated
RANK ?= 0
ADDR ?= 127.0.0.1
export RANK ADDR
install:
	pip install --break-system-packages -r requirements.txt
convert: convert.py
	python3 $< \
	 --hf-ckpt-path ../ \
	 --save-path ../../DeepSeek-V3-Demo \
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
