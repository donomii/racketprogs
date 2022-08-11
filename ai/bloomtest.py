from transformers import AutoTokenizer, AutoModel

tokenizer = AutoTokenizer.from_pretrained("bigscience/bloom-1b3")

model = AutoModel.from_pretrained("bigscience/bloom-1b3")
