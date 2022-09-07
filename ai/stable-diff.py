import os
import torch
#from torch import autocast
from diffusers import StableDiffusionPipeline
from transformers import AutoModel

from PIL import Image

steps = 100
seed = 15900
guidance=20.0
model_path = "/Users/jeremyprice/git/stable-diffusion-v1-4/"
model_id = "CompVis/stable-diffusion-v1-4"
#device = "cuda"
#device="cpu"
device = "mps"


torch.use_deterministic_algorithms(True)


def image_grid(imgs, rows, cols):
    print(len(images), rows, cols)
    assert len(imgs) == rows*cols

    w, h = imgs[0].size
    grid = Image.new('RGB', size=(cols*w, rows*h))
    grid_w, grid_h = grid.size
    
    for i, img in enumerate(imgs):
        grid.paste(img, box=(i%cols*w, i//cols*h))
    return grid




#access_token = "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"

#16bit
#pipe = StableDiffusionPipeline.from_pretrained(model_id, torch_dtype=torch.float16, use_auth_token=access_token)
#pipe = pipe.to(device)


pipe = StableDiffusionPipeline.from_pretrained(model_path)
pipe = pipe.to(device)



#prompt = "a photo of a giant scary koala striding through a scary moonlit forest"
#prompt = "a photo of a giant scary koala on a city street"
#prompt = "a photo of a koala with the head of Margaret Thatcher"
#prompt = "a photo of a koala with sharp teeth attacking someone"
#prompt = "a photo of kangaroos with spears hunting a human"
#prompt = "a photo of the planet earth in the shape of a pair of testicles, floating in space"
#prompt = "The entire planet earth in an icecream cone instead of the icecream.  Surreal."

#make a directory called "results"
if not os.path.exists("output"):
    os.makedirs("output")


#Make an array of prompts to use

#prompts = ["Cyber wasp warrior", "Cyborg wasp warrior", "High tech cyber wasp warrior", "The Earth floating in the water at sunset","The Earth floating over the water at sunset", "The Earth floating over the sea","Earth tide","Earthtide", "A photo of an icecream cone with the Earth on top.  hyperreal","Ringworld", "Ringworld culture", "Ringworld unreal 5 render, octane render", "Ringworld unreal 5 render, studio ghibli, tim hildebrandt, digital art, octane render, beautiful composition, trending on artstation,  masterpiece", "Ringworld Roger Dean", "Iain M. Banks, tim hildebrandt, digital art, octane render, beautiful composition, trending on artstation,  masterpiece", "naked succubus, outer space, unreal 5 render,  tim hildebrandt, digital art, octane render, beautiful composition, trending on artstation, award - winning photograph, masterpiece", "naked alien monster, outer space, unreal 5 render, tim hildebrandt, digital art, octane render, beautiful composition, trending on artstation, award - winning photograph, masterpiece", "naked", "naked unreal 5 render, tim hildebrandt, digital art, octane render, beautiful composition, trending on artstation, award - winning photograph, masterpiece", "naked  digital illustration matte painting trending on Artstation", "naked at the beach", "ice cream cone ice floe", "ice floe in an ice cream cone, unreal 5 render, octane render", "Snow White in the style of Hokusai","Snow White holding an apple in the style of Hokusai", "Liv Tyler in a slutty Santa suit", "Liv Tyler as slutty Snow White", "Koala space marine", "Koala space marine, artstation, pixel, unreal 5 render", "Photorealistic koala space marine", "Photorealistic kangaroo space marine", "Photorealistic kangaroo space marine, Chriss Foss", "Kangaroo space marine, Chris Foss", "Kangaroo space marine,  Anthony Roberts", "Kangaroo space marine,  Roger Dean", "Kangaroo maschinen krieger", "Koala maschinen krieger", "Kangaroo space marine maschinen krieger", "Koala space marine maschinen krieger", "Photorealistic wombat space marine", "beautiful futuristic wombat space marine digital illustration matte painting trending on Artstation", "futuristic wombat space marine digital illustration deviantart", "futuristic wombat space marine digital illustration render", "Snow White as Sadako from The Ring", "Snow White crawling through a TV screen, Sadako, Ring", "Snow White race queen", "Snow White race queen Nissan", "Dirty Snow White", "Dirty Snow White with apple", "Snow White is dirty","Snow White has dirty clothes","Snow White in mud","Snow White next to Nissan Navara","Snow White driving a Nissan Navara","Margaret Thatcher merged with a possum","Margaret Thatcher in Nosferatu","Margaret Thatcher with huge sabre-tooth teeth","A possum as Margaret Thatcher","City with penises reaching into the sky","City with with skyscrapers as penises", "City with penis skyscrapers","Insect palace", "Caravan palace", "Fantasy palace made of insect wings","Walking in the mushroom forest", "John Wick fighting wombles","Starscream crashing into the World Trade Center","A picture of Sydney with skyscraper dicks.","Margaret Thatcher as a possum","Margaret Thatcher naked on a cold day","Margaret Thatcher in the style of H.R. Giger, biomechanical","a photo of a giant scary koala striding through a forest","a sabre-tooth koala attacking the cameraman","The planet earth in an icecream cone, stock photo, trending on artstation, masterpiece, creative, acrylic","Angela Merkel naked", "beautiful futuristic solarpunk Angela Merkel naked digital illustration matte painting trending on Artstation", "beautiful futuristic solarpunk insect palace digital illustration matte painting trending on Artstation", "Angela Merkel naked at the beach", "futuristic city in alien world, outer space, unreal 5 render, studio ghibli, tim hildebrandt, digital art, octane render, beautiful composition, trending on artstation, award - winning photograph, masterpiece ", "beautiful futuristic solarpunk Hobbit treehouse digital illustration matte painting trending on Artstation","Ringworld", "Ringworld culture", "Ringworld unreal 5 render, octane render", "Ringworld unreal 5 render, studio ghibli, tim hildebrandt, digital art, octane render, beautiful composition, trending on artstation,  masterpiece", "Ringworld Roger Dean", "Orbital by Roger Dean", "Culture Orbital by Roger Dean", "Iain M. Banks, digital art, octane render, beautiful composition, trending on artstation,  masterpiece", "Ringworld digital illustration matte painting trending on Artstation", "Ringworld koalas", "Ringworld koalas tim hildebrandt, digital art, octane render, beautiful composition, trending on artstation,  masterpiece", "Nagrand", "Nagrand in the style of Sydney Nolan, painting, beautiful composition,  masterpiece", "kubla khan in the style of Albert Tucker, digital art, octane render, beautiful composition, trending on artstation,  masterpiece", "Culture Orbital tim hildebrandt, digital art, octane render, beautiful composition, trending on artstation,  masterpiece", "Orbital  digital art, octane render, beautiful composition, trending on artstation,  masterpiece", "Culture GSV  digital art, octane render, beautiful composition, trending on artstation,  masterpiece", "Oshu'gun Nagrand digital art, beautiful composition, trending on artstation,  masterpiece", "Oshu'gun Nagrand digital art, beautiful composition, artstation, pixel, deviantart,  render", "naked", "Mechanical insect", "Culture drone","Clockwork insect, digital art, render, beautiful composition, trending on artstation,  masterpiece", "Steampunk robot insect, digital art, render, beautiful composition, trending on artstation,  masterpiece", "High-tech digial insect smooth profile, digital art, render, beautiful composition, trending on artstation,  masterpiece" "FLCL robot digital art, octane render, beautiful composition, trending on artstation,  masterpiece", "FLCL guitar swing", "Snow White with cyber neon lighting, futuristic jewelry, hyper realistic, digital art","Snow White shodan with apple unreal 5 render, octane render","Snow White shodan with apple, cyber neon lighting, futuristic jewelry, unreal 5 render, octane render",]




prompts.append("Snow White shodan unreal 5 render, octane render")
prompts.append("Snow White shodan cyber neon lighting, futuristic jewelry, cyber digital illustration")
prompts.append("Snow White shodan cyber unreal 5 render, studio ghibli, tim hildebrandt, digital art, octane render, beautiful composition, trending on artstation,  masterpiece")
prompts.append("Snow White shodan cyber digital illustration airbrush")
prompts.append("Snow White shodan noir cyber digital illustration airbrush")
prompts.append("Snow White noir cyber digital illustration airbrush")
prompts.append("Snow White noir cyber apple digital illustration airbrush")
prompts.append("Snow White noir cyber green glow digital illustration airbrush")
prompts.append("Snow White noir cyber glowing green digital illustration airbrush")
prompts.append("Snow White noir cyber green glow unreal 5 render, octane render")
prompts.append("Snow White noir cyber unreal 5 render, octane render")
prompts.append("Snow White noir cyber  green glow unreal 5 render, octane render")
prompts.append("beautiful futuristic solarpunk Snow White digital illustration matte painting trending on Artstation")
prompts.append("beautiful futuristic cyberpunk Snow White digital illustration matte painting trending on Artstation")
prompts.append("space marine, by Josh Kirby")
prompts.append("Cosmonaut Koala by Josh Kirby")
prompts.append("Map of the world on icecream in a cone, hyperreal, by Josh Kirby")
prompts.append("Map of the world on icecream in a cone, hyperreal")
prompts.append("space marine with flower pot armour")
prompts.append("Map of the world on an icecream cone, glossy, in focus")
prompts.append("Map of the world on an icecream cone, unreal 5 render, octane render")
prompts.append("Map of Australia on an icecream cone, unreal 5 render, octane render")
prompts.append("Map of Europe on an icecream cone, unreal 5 render, octane render")
prompts.append("Map of the world on an icecream cone, unreal 5 render, octane render, acrylic on canvas")
prompts.append("Map of the world on an icecream cone,  acrylic on canvas")
prompts.append("Map of the world on an icecream cone, the cream is paint, dripping down the cone,  acrylic on canvas")
prompts.append("Cosmonaut Koala, hero of the people")
prompts.append("Cosmonaut Koala, standing on an alien planet, unreal 5 render, tim hildebrandt, digital art, octane render, beautiful composition, trending on artstation, award - winning photograph, masterpiece")
prompts.append("bullet with butterfly wings")
prompts.append("gefikt,  unreal 5 render,  tim hildebrandt, digital art, octane render, beautiful composition, trending on artstation, award - winning photograph, masterpiece")
prompts.append("fikt, outer space, unreal 5 render,  tim hildebrandt, digital art, octane render, beautiful composition, trending on artstation, award - winning photograph, masterpiece")
prompts.append("einfach geile nakt, outer space, unreal 5 render,  tim hildebrandt, digital art, octane render, beautiful composition, trending on artstation, award - winning photograph, masterpiece")
prompts.append("wet pussy, outer space, unreal 5 render,  tim hildebrandt, digital art, octane render, beautiful composition, trending on artstation, award - winning photograph, masterpiece")
prompts.append("naked alien, outer space, unreal 5 render,  tim hildebrandt, digital art, octane render, beautiful composition, trending on artstation, award - winning photograph, masterpiece")
prompts.append("naked alien princess, outer space, unreal 5 render,  tim hildebrandt, digital art, octane render, beautiful composition, trending on artstation,  masterpiece")



i=seed
for pr in prompts:

	#Loop over prompts
	for prompt in prompts:

		#with autocast(device):
			#Loop from 0 to seed
			i = i + 1
			#Loop guidance over array [3.0, 7.5, 20.0]
			for guidance in [3.0, 7.5, 20.0, 30.0]:

				g = torch.Generator()
				g.manual_seed(i)
				torch.manual_seed(i)
				
				#torch.set_printoptions(threshold=10_000)
				#print("rng state: ", torch.get_rng_state())
				#image = pipe(prompt, num_inference_steps=steps, generator=generator, guidance_scale=8.5 )["sample"][0]  
				image = pipe(prompt, num_inference_steps=steps, generator=g, guidance_scale=guidance )["sample"][0]  
				image.save("output/"+prompt+"_"+str(i)+"_g"+str(guidance)+".png")
				print("Saved output/"+prompt+"_"+str(i)+"_g"+str(guidance)+".png")

				#num_images = 9
				#iprompts = [prompt] * num_images
				#print(prompt)

				#images = pipe(iprompts, num_inference_steps=steps, generator=generator)["sample"]

				##loop over images and save each one with a different number
				#for j in range(num_images):
				#images[j].save("output/"+prompt+"_"+str(i)+"_"+str(j)+"_g7.5.png")

				#print("Saved "+str(num_images)+" as "+"output/"+prompt+"_"+str(i)+"_")
				##grid = image_grid(images, rows=3, cols=3)
				##grid.save("output/"+prompt+"_"+str(i)+".png")
