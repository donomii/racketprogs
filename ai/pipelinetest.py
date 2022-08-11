from transformers import pipeline
import torch

model = 'bigscience/bloom-1b7'


generator = pipeline('text-generation',model=model,device=torch.device("mps")) 
generator.model.to("mps")
print(generator("I am the very model of "))
