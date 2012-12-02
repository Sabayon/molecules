#!/usr/bin/python
import os, shutil, time
import subprocess
from datetime import datetime

sabayon_molecule_home = os.getenv("SABAYON_MOLECULE_HOME", "/sabayon")
source_chroot_dir = os.getenv('SOURCE_CHROOT_DIR')
chroot_dir = os.getenv('CHROOT_DIR')
cdroot_dir = os.getenv('CDROOT_DIR')
boot_dir = os.path.join(chroot_dir, "boot")
cdroot_boot_dir = os.path.join(cdroot_dir, "boot")

# generate EFI GRUB
make_grub_efi = os.path.join(sabayon_molecule_home, "scripts/make_grub_efi.sh")
exit_st = subprocess.call([make_grub_efi])
if exit_st != 0:
    raise SystemExit(exit_st)

boot_kernel = [x for x in os.listdir(boot_dir) if x.startswith("kernel-")]
if boot_kernel:
    boot_kernel = os.path.join(boot_dir, sorted(boot_kernel)[0])
    shutil.copy2(boot_kernel, os.path.join(cdroot_boot_dir, "sabayon"))

boot_ramfs = [x for x in os.listdir(boot_dir) if x.startswith("initramfs-")]
if boot_ramfs:
    boot_ramfs = os.path.join(boot_dir, sorted(boot_ramfs)[0])
    shutil.copy2(boot_ramfs, os.path.join(cdroot_boot_dir, "sabayon.igz"))


# Write build info
build_info_file = os.path.join(cdroot_dir, "BUILD_INFO")
build_date = str(datetime.fromtimestamp(time.time()))
bf = open(build_info_file, "w")
bf.write("Sabayon ISO image build information\n")
bf.write("Built on: %s\n" % (build_date,))
bf.flush()
bf.close()

def replace_version(path):
    release_version = os.getenv("RELEASE_VERSION", "HEAD")
    cf = open(path, "r")
    new_cf = []
    for line in cf.readlines():
        line = line.replace("__VERSION__", release_version)
        new_cf.append(line)
    cf.close()
    cf_new = open(path+".cdroot", "w")
    cf_new.writelines(new_cf)
    cf_new.flush()
    cf_new.close()
    os.rename(path+".cdroot", path)

# Change txt.cfg and isolinux.txt to match version
isolinux_cfg = os.path.join(cdroot_dir, "isolinux/txt.cfg")
grub_cfg = os.path.join(cdroot_dir, "boot/grub/grub.cfg")
isolinux_txt = os.path.join(cdroot_dir, "isolinux/isolinux.txt")
replace_version(isolinux_cfg)
replace_version(grub_cfg)
replace_version(isolinux_txt)

# Generate Language and Keyboard menus for GRUB-2
make_grub_langs = os.path.join(
    sabayon_molecule_home,
    "scripts/make_grub_langs.sh")
exit_st = subprocess.call([make_grub_langs, grub_cfg])
if exit_st != 0:
    raise SystemExit(exit_st)

# Copy pkglist over, if exists
sabayon_pkgs_file = os.path.join(chroot_dir, "etc/sabayon-pkglist")
if os.path.isfile(sabayon_pkgs_file):
    shutil.copy2(sabayon_pkgs_file, os.path.join(cdroot_dir, "pkglist"))
    iso_path = os.getenv("ISO_PATH")
    if iso_path:
        shutil.copy2(sabayon_pkgs_file, iso_path+".pkglist")

# copy back.jpg to proper location
isolinux_img = os.path.join(chroot_dir, "usr/share/backgrounds/isolinux/back.jpg")
if os.path.isfile(isolinux_img):
    shutil.copy2(isolinux_img, os.path.join(cdroot_dir, "isolinux/back.jpg"))

iso_md5_script = os.path.join(sabayon_molecule_home, "scripts/pre_iso_script_livecd_hash.sh")
exit_st = subprocess.call([iso_md5_script])
raise SystemExit(exit_st)
