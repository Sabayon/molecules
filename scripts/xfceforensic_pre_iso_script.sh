#!/bin/bash
GFORENSIC_DIR="/sabayon/remaster/gforensic"
cp "${GFORENSIC_DIR}"/isolinux/isolinux.cfg "${CDROOT_DIR}/isolinux/txt.cfg"
cp "${GFORENSIC_DIR}"/isolinux/back.jpg "${CDROOT_DIR}/isolinux/back.jpg"
cp "${GFORENSIC_DIR}"/isolinux/isolinux.txt "${CDROOT_DIR}/isolinux/isolinux.txt"
