echo WARNING: run this from bash only
rm -rf .env
python -m venv .env
. .env/bin/activate
.env/bin/python -m pip install --upgrade pip
pip3 install --upgrade diffusers transformers scipy ftfy
pip3 install --pre torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/nightly/cpu

#pip3 install torch torchvision torchaudio 
which pip
/bin/bash
