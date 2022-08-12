rm -rf .env
python -m venv .env
source .env/bin/activate
.env/bin/python -m pip install --upgrade pip
pip3 install --upgrade transformers
pip3 install --pre torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/nightly/cpu
#pip3 install torch torchvision torchaudio 
$SHELL
