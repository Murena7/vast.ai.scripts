#!/bin/bash

COMFYUI_DIR=/workspace/ComfyUI
CUSTOM_NODES=()

APT_PACKAGES=(wget git curl)

PIP_PACKAGES=()

CHECKPOINT_MODELS=(
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/diffusion_models/wan2.1_i2v_480p_14B_bf16.safetensors"
)

VAE_MODELS=(
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors"
)

TEXT_ENCODER_MODELS=(
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"
)

CLIP_VISION_MODELS=(
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors"
)

function provisioning_print_header() {
  echo "====== VAST.AI COMFYUI PROVISIONING SCRIPT START ======"
}

function provisioning_print_end() {
  echo "====== VAST.AI COMFYUI PROVISIONING SCRIPT END ======"
}

function provisioning_get_apt_packages() {
  echo "Installing APT packages..."
  apt update && apt install -y "${APT_PACKAGES[@]}"
}

function provisioning_get_nodes() {
  echo "Installing custom nodes..."
  cd "${COMFYUI_DIR}/custom_nodes" || exit
  for repo in "${CUSTOM_NODES[@]}"; do
    git clone "${repo}"
  done
}

function provisioning_get_pip_packages() {
  echo "Installing pip packages..."
  pip install "${PIP_PACKAGES[@]}"
}

function provisioning_get_files() {
  mkdir -p "$1"
  cd "$1" || exit
  shift
  for file in "$@"; do
    echo "Downloading: $file"
    wget -N "$file"
  done
}

function provisioning_start() {
  provisioning_print_header
  provisioning_get_apt_packages
  provisioning_get_nodes
  provisioning_get_pip_packages

  provisioning_get_files \
    "${COMFYUI_DIR}/models/checkpoints" \
    "${CHECKPOINT_MODELS[@]}"

  provisioning_get_files \
    "${COMFYUI_DIR}/models/vae" \
    "${VAE_MODELS[@]}"

  provisioning_get_files \
    "${COMFYUI_DIR}/models/text_encoders" \
    "${TEXT_ENCODER_MODELS[@]}"

  provisioning_get_files \
    "${COMFYUI_DIR}/models/clip_vision" \
    "${CLIP_VISION_MODELS[@]}"

  provisioning_print_end
}

provisioning_start
