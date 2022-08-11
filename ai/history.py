from transformers import AutoModelForCausalLM, AutoTokenizer, set_seed

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
    )
    generated_sentence = tokenizer.decode(output[0], skip_special_tokens=True)
    return post_process_sentence(input_sentence, generated_sentence)

def question_bloom(input_sentence, max_length, temperature, do_sample=True, top_k=3, seed=42):
    post_processed_output = generate_single(model, tokenizer, input_sentence, temperature=temperature, max_length=max_length, do_sample=do_sample, top_k=top_k, seed=seed)
    return post_processed_output.split("\n-")[-2]

#print(question_bloom("Finish this conversation:\nMe: Hi, how are you?\nYou:  I'm fine, how are you?\n Me: Also good.  What are you doing today?\nYou:", 256, top_k=3, seed=42, temperature=0.6))

#print(question_bloom("Complete this sentence:\n\nThe capital of France is ", 80, top_k=3, seed=42, temperature=0.3))


#Loop over user input from stdin, run the AI, add the question and answer to the conversation history, and print the output.
conversation="Predict the next line:"

#Load the shell history file from disk
with open("/Users/jeremyprice/.zsh_history", "r") as f:
    #take the last 10 lines
    lines = f.readlines()[-10:]
    #append them to the conversation
    conversation = conversation + "\n" + "".join(lines)
    print(conversation)
    #query bloom
    answer = question_bloom(conversation, 800, top_k=3, seed=42, temperature=0.6)
    #print the answer
    print(answer)
