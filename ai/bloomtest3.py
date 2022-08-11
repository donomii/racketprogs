import torch
from transformers import AutoModelForCausalLM, AutoTokenizer, set_seed

if not torch.backends.mps.is_available():
    if not torch.backends.mps.is_built():
        print("MPS not available because the current PyTorch install was not "
              "built with MPS enabled.")
    else:
        print("MPS not available because the current MacOS version is not 12.3+ "
              "and/or you do not have an MPS-enabled device on this machine.")


model = AutoModelForCausalLM.from_pretrained("bigscience/bloom-1b7", use_cache=True)
tokenizer = AutoTokenizer.from_pretrained("bigscience/bloom-1b7")

def post_process_sentence(input_sentence, generated_sentence):
    new_sentence = generated_sentence.replace(input_sentence, "")
    if "\n" not in new_sentence:
        return generated_sentence.replace("  ", " ") + "\n- "
    else:
        return (new_sentence.split("\n")[0]).replace("  ", " ") + "\n- "

def generate_single(model, tokenizer, input_sentence, max_length=50, top_k=0, temperature=0.7, do_sample=True, seed=42):
    set_seed(seed)
    input_ids = tokenizer.encode(input_sentence, return_tensors="pt")
    output = model.generate(
        input_ids, do_sample=do_sample, 
        max_length=len(input_sentence)+max_length, 
        top_k=top_k, 
        temperature=temperature,
	device="mps",
    )
    generated_sentence = tokenizer.decode(output[0], skip_special_tokens=True)
    return post_process_sentence(input_sentence, generated_sentence)

def question_bloom(input_sentence, max_length, temperature, do_sample=True, top_k=3, seed=42):
    post_processed_output = generate_single(model, tokenizer, input_sentence, temperature=temperature, max_length=max_length, do_sample=do_sample, top_k=top_k, seed=seed)
    return post_processed_output.split("\n-")[-2]

#print(question_bloom("Finish this conversation:\nMe: Hi, how are you?\nYou:  I'm fine, how are you?\n Me: Also good.  What are you doing today?\nYou:", 256, top_k=3, seed=42, temperature=0.6))

#print(question_bloom("Complete this sentence:\n\nThe capital of France is ", 80, top_k=3, seed=42, temperature=0.3))


#Loop over user input from stdin, run the AI, add the question and answer to the conversation history, and print the output.
conversation="Finish this conversation:"
while True:
    input_sentence = input("Enter a sentence: ")
    conversation=conversation+"\nYou: "+ input_sentence + "\nMe: "
    answer = question_bloom(conversation, 256, top_k=1, seed=123, temperature=0.8)
    conversation=conversation+answer
    print(conversation)
    print("-----------------------------------------------------\n")
    if input_sentence == "quit":
        break
