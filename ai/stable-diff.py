import torch
from torch import autocast
from diffusers import StableDiffusionPipeline
from transformers import AutoModel


steps = 100
seed = 1028

model_path = "/Users/jeremyprice/git/stable-diffusion-v1-4/"
model_id = "CompVis/stable-diffusion-v1-4"
#device = "cuda"
device="cpu"
#device = "mps"

#access_token = "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"

#16bit
#pipe = StableDiffusionPipeline.from_pretrained(model_id, torch_dtype=torch.float16, use_auth_token=access_token)
#pipe = pipe.to(device)


pipe = StableDiffusionPipeline.from_pretrained(model_path)
pipe = pipe.to(device)



prompt = "a photo of the planet Earth in the shape of a pair of testicles"
#with autocast(device):
#Loop from 0 to seed
for i in range(seed):
    generator = torch.Generator("cpu").manual_seed(i)
    image = pipe(prompt, num_inference_steps=steps, generator=generator)["sample"][0]  
    image.save("output_"+str(i)+".png")
