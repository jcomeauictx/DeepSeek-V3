#!/bin/bash
url=https://huggingface.co/deepseek-ai/DeepSeek-V3-Base/resolve/main
for n in $(seq 1 3); do
	wget -N $url/model-$(printf %05d $n)-of-000163.safetensors
done
