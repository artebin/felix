#!/usr/bin/env bash

PYTHON_VENV_ROFIMOJI_DIR="/home/${USER}/.local/lib/rofimoji/venv"
if [[ ! -d "${PYTHON_VENV_ROFIMOJI_DIR}" ]]; then
	printf "Cannot find python venv for rofimoji: %s\n" "${PYTHON_VENV_ROFIMOJI_DIR}"
	exit 1
fi
source "${PYTHON_VENV_ROFIMOJI_DIR}"/bin/activate
rofimoji
