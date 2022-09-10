echo WARNING: run this from bash only
#rm -rf .env
#python -m venv .env
. .env/bin/activate
.env/bin/python -m pip install --upgrade pip
pip install wheel
pip3 install --upgrade diffusers transformers scipy ftfy
pip3 install --upgrade --pre torch torchvision pytorch_lightning --extra-index-url https://download.pytorch.org/whl/nightly/cpu
pip install taming-transformers-rom1504
pip install omegaconf  einops clip kornia

#pip3 install torch torchvision torchaudio 
which pip
which python
python3 -c 'import torch; print(torch.__version__) '
python -c"import torch; print(torch.backends.mps.is_available())"
git clone --depth 1 git@github.com:CompVis/stable-diffusion.git
/bin/bash

echo now edit .env/lib/python3.10/site-packages/torch/nn/functional.py line 2511
echo Change this line: return torch.layer_norm(input, normalized_shape, weight, bias, eps, torch.backends.cudnn.enabled)
echo into this line: return torch.layer_norm(input.contiguous(), normalized_shape, weight, bias, eps, torch.backends.cudnn.enabled)
echo
echo add .contiguous() to the input tensor
