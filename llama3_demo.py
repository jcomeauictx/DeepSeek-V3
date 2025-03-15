# from https://stackoverflow.com/a/78427080/493161
import ctranslate2
import transformers

generator = ctranslate2.Generator("/content/drive/MyDrive/models/Meta-Llama-3-8B-Instruct", device="cuda") # device="cuda" or "cpu"
tokenizer = transformers.AutoTokenizer.from_pretrained("meta-llama/Meta-Llama-3-8B-Instruct")

messages = [
    {"role": "system", "content": "Helpful assistant"},
    {"role": "user", "content": "what is the water structure?"},
]

input_ids = tokenizer.apply_chat_template(messages, tokenize=False, add_generation_prompt=True)
terminators = [tokenizer.eos_token_id,tokenizer.convert_tokens_to_ids("<|eot_id|>")]
input_tokens = tokenizer.convert_ids_to_tokens(tokenizer.encode(input_ids))
results = generator.generate_batch([input_tokens], include_prompt_in_result=False, max_length=200, sampling_temperature=0.6, sampling_topp=0.9, end_token=terminators)
output = tokenizer.decode(results[0].sequences_ids[0])
print(output)
