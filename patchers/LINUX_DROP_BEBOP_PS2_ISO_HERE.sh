#!/usr/bin/env bash

#
#  _ \  __|  __|__ __|
#  |  |(    (_ |   |
# ___/\___|\___|  _|
#

set -euo pipefail

export EXPECTED_ISO_SHA1SUM=3e6968ec5b83d930b9536e96f8911c7f2256c19f
export EXPECTED_ISO_ALTERNATIVE_SHA1SUM=576529dac9ea566643fd76d0dd5147fa380efe53
ALTERNATIVE_ISO=false

echo "COWBOY BEBOP PS2 PATCHER"
echo "English v1.0.0 by SONICMAN69"
echo "============================"

if ! command -v zstd >/dev/null 2>&1
then
    echo "Dependency 'zstd' could not be found. Please install 'zstd' using your package manager."
    exit 1
fi

echo "[*] Applying patch to file"
export SOURCE_ISO="${1}"
echo "${SOURCE_ISO}"

echo "[*] Finding current patcher directory"
PATCHER_CWD=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "${PATCHER_CWD}"

export PATCHED_ISO="${PATCHER_CWD}/COWBOY_BEBOP_PS2_ENGLISH_PATCHED_1.0.0.iso"
echo "${PATCHED_ISO}"

echo "[*] Finding patching data"
export PATCHDATA="${PATCHER_CWD}/patching_data/BEBOP_PS2_DCGT_EN_1.0.0"
echo "${PATCHDATA}"

if [ ! -d "${PATCHDATA}" ]; then
  echo "[-] Missing or corrupt patching data."
  exit 1
fi

echo "[*] Computing hash on received file"

if ! sha1sum "${SOURCE_ISO}" | grep "${EXPECTED_ISO_SHA1SUM}"; then
  if ! sha1sum "${SOURCE_ISO}" | grep "${EXPECTED_ISO_ALTERNATIVE_SHA1SUM}"; then
    echo "[-] Invalid ISO. SHA1SUM must match ${EXPECTED_ISO_SHA1SUM}."
    echo "    Please ensure that you provided the correct file and that you dumped"
    echo "    your disc correctly."
    exit 1
  else
    echo "[*] Alternative ISO detected"
    ALTERNATIVE_ISO=true
  fi
fi

echo "[*] Valid ISO confirmed"

export PATCHER_TEMP="${PATCHER_CWD}/temp"
export PATCHER_PATCHED_TEMP="${PATCHER_CWD}/temp/patched"
export PATCHER_PATCHED_TEMP_DATA="${PATCHER_CWD}/temp/patched/DATA"

echo "[*] Creating temp directory"
echo "${PATCHER_TEMP}"

mkdir -p "${PATCHER_TEMP}/DATA/MODULES/IRX/"
mkdir -p "${PATCHER_TEMP}/MODULES/IRX/"
mkdir -p "${PATCHER_TEMP}/patched/DATA/"

echo "[*] Extracting ISO file"

unpack () {
  >&2 echo -n "."
  dd if="${SOURCE_ISO}" of="${PATCHER_TEMP}${1}" bs=4M iflag=skip_bytes,count_bytes count="${3}" skip="${2}" 2>/dev/null
}

if [ "$ALTERNATIVE_ISO" = true ] ; then
  unpack "/SLPS_255.51" 684032 4318484
else
  unpack "/SLPS_255.50" 684032 4318484
fi
unpack "/DI." 3558801408 128
unpack "/MODULES/EZMIDI.IRX" 5588992 106221
unpack "/DATA/SUBDIR.HED" 6387712 76
unpack "/DATA/MODULES.DAT" 7942144 753664
unpack "/DATA/MODULES.HED" 6389760 836
unpack "/DATA/DMAP.DAT" 1357807616 1732345856
unpack "/DATA/DMAP.HED" 6391808 1475540
unpack "/DATA/EXTRA.DAT" 1235255296 82247680
unpack "/DATA/EXTRA.HED" 7868416 8536
unpack "/DATA/ROOT.DAT" 8695808 32768
unpack "/DATA/ROOT.HED" 7878656 264
unpack "/DATA/SHOOT.DAT" 1333428224 24379392
unpack "/DATA/SHOOT.HED" 7880704 15224
unpack "/DATA/SOUND.DAT" 3090153472 468647936
unpack "/DATA/SOUND.HED" 7897088 23100
unpack "/DATA/STATUS.DAT" 1228800000 6455296
unpack "/DATA/STATUS.HED" 7921664 3300
unpack "/DATA/SYSTEM.DAT" 8728576 1458176
unpack "/DATA/SYSTEM.HED" 7925760 1892
unpack "/DATA/THUMBS.DAT" 1317502976 2162688
unpack "/DATA/THUMBS.HED" 7927808 5984
unpack "/DATA/2DMAP.DAT" 1319665664 12697600
unpack "/DATA/2DMAP.HED" 7933952 4004
unpack "/DATA/3DMAP.DAT" 1332363264 606208
unpack "/DATA/3DMAP.HED" 7938048 924
unpack "/DATA/3DMAP2.DAT" 1332969472 458752
unpack "/DATA/3DMAP2.HED" 7940096 484
unpack "/MODULES/IRX/LIBSD.IRX" 5003264 28661
unpack "/MODULES/IRX/MCMAN.IRX" 5031936 96181
unpack "/MODULES/IRX/MCSERV.IRX" 5128192 7385
unpack "/MODULES/IRX/MODHSYN.IRX" 5136384 63037
unpack "/MODULES/IRX/MODMIDI.IRX" 5199872 21941
unpack "/MODULES/IRX/MODSEIN.IRX" 5222400 9393
unpack "/MODULES/IRX/MODSESQ.IRX" 5232640 13717
unpack "/MODULES/IRX/PADMAN.IRX" 5246976 45797
unpack "/MODULES/IRX/SDRDRV.IRX" 5294080 9161
unpack "/MODULES/IRX/SIO2MAN.IRX" 5304320 6641
unpack "/MODULES/IRX/IOPRP300.IMG" 5312512 275345
unpack "/DATA/MODULES/EZMIDI.IRX" 6281216 106221
unpack "/DATA/MODULES/IRX/LIBSD.IRX" 5695488 28661
unpack "/DATA/MODULES/IRX/MCMAN.IRX" 5724160 96181
unpack "/DATA/MODULES/IRX/MCSERV.IRX" 5820416 7385
unpack "/DATA/MODULES/IRX/MODHSYN.IRX" 5828608 63037
unpack "/DATA/MODULES/IRX/MODMIDI.IRX" 5892096 21941
unpack "/DATA/MODULES/IRX/MODSEIN.IRX" 5914624 9393
unpack "/DATA/MODULES/IRX/MODSESQ.IRX" 5924864 13717
unpack "/DATA/MODULES/IRX/PADMAN.IRX" 5939200 45797
unpack "/DATA/MODULES/IRX/SDRDRV.IRX" 5986304 9161
unpack "/DATA/MODULES/IRX/SIO2MAN.IRX" 5996544 6641
unpack "/DATA/MODULES/IRX/IOPRP300.IMG" 6004736 275345


echo

echo "[*] ISO file extracted"
echo "[*] Building patched ISO ${PATCHED_ISO}"

mkdir -p "${PATCHER_PATCHED_TEMP}/DATA"

if [ -f "${PATCHER_TEMP}/SLPS_255.51" ]; then
    echo "[*] Converting SLPS_255.51 to SLPS_255.50"

    zstd --long=31 --decompress --force --patch-from "${PATCHER_TEMP}/SLPS_255.51" "${PATCHDATA}/SLPS_255.51_to_SLPS_255.50.zstd" -o "${PATCHER_TEMP}/SLPS_255.50"
fi

zstd_patch () {
  >&2 echo -n "."
  if [[ "${1}" == "/ISOHEADER" ]]; then
    zstd --long=31 --decompress --stdout --patch-from "${PATCHER_TEMP}/SLPS_255.50" "${PATCHDATA}${1}.zstd"
  else
    zstd --long=31 --decompress --stdout --patch-from "${PATCHER_TEMP}${1}" "${PATCHDATA}${1}.zstd"
  fi
}

slack () {
  >&2 echo -n "."
  dd if=/dev/zero iflag=count_bytes count="${1}" 2>/dev/null
}

reuse () {
  >&2 echo -n "."
  cat "${PATCHER_TEMP}${1}" ;
}

provided () {
  >&2 echo -n "."
  cat "${PATCHDATA}${1}" ;
}

(
  zstd_patch "/ISOHEADER"
  provided "/SYSTEM.CNF" ; slack 1991
  reuse "/DI." ; slack 1920
  zstd_patch "/SLPS_255.50"
  reuse "/MODULES/EZMIDI.IRX" ; slack 275
  reuse "/DATA/SUBDIR.HED" ; slack 1972
  zstd_patch "/DATA/MODULES.DAT"
  zstd_patch "/DATA/MODULES.HED" ; slack 1212
  zstd_patch "/DATA/DMAP.DAT"
  zstd_patch "/DATA/DMAP.HED" ; slack 1068
  zstd_patch "/DATA/EXTRA.DAT"
  zstd_patch "/DATA/EXTRA.HED" ; slack 1704
  zstd_patch "/DATA/ROOT.DAT"
  zstd_patch "/DATA/ROOT.HED" ; slack 1784
  zstd_patch "/DATA/SHOOT.DAT"
  zstd_patch "/DATA/SHOOT.HED" ; slack 1160
  zstd_patch "/DATA/SOUND.DAT"
  zstd_patch "/DATA/SOUND.HED" ; slack 1476
  zstd_patch "/DATA/STATUS.DAT"
  zstd_patch "/DATA/STATUS.HED" ; slack 796
  zstd_patch "/DATA/SYSTEM.DAT"
  zstd_patch "/DATA/SYSTEM.HED" ; slack 1728
  zstd_patch "/DATA/THUMBS.DAT"
  zstd_patch "/DATA/THUMBS.HED" ; slack 160
  zstd_patch "/DATA/2DMAP.DAT"
  zstd_patch "/DATA/2DMAP.HED" ; slack 92
  zstd_patch "/DATA/3DMAP.DAT"
  zstd_patch "/DATA/3DMAP.HED" ; slack 1124
  zstd_patch "/DATA/3DMAP2.DAT"
  zstd_patch "/DATA/3DMAP2.HED" ; slack 1564
  reuse "/MODULES/IRX/LIBSD.IRX" ; slack 11
  reuse "/MODULES/IRX/MCMAN.IRX" ; slack 75
  reuse "/MODULES/IRX/MCSERV.IRX" ; slack 807
  reuse "/MODULES/IRX/MODHSYN.IRX" ; slack 451
  reuse "/MODULES/IRX/MODMIDI.IRX" ; slack 587
  reuse "/MODULES/IRX/MODSEIN.IRX" ; slack 847
  reuse "/MODULES/IRX/MODSESQ.IRX" ; slack 619
  reuse "/MODULES/IRX/PADMAN.IRX" ; slack 1307
  reuse "/MODULES/IRX/SDRDRV.IRX" ; slack 1079
  reuse "/MODULES/IRX/SIO2MAN.IRX" ; slack 1551
  reuse "/MODULES/IRX/IOPRP300.IMG" ; slack 1135
  reuse "/DATA/MODULES/EZMIDI.IRX" ; slack 275
  reuse "/DATA/MODULES/IRX/LIBSD.IRX" ; slack 11
  reuse "/DATA/MODULES/IRX/MCMAN.IRX" ; slack 75
  reuse "/DATA/MODULES/IRX/MCSERV.IRX" ; slack 807
  reuse "/DATA/MODULES/IRX/MODHSYN.IRX" ; slack 451
  reuse "/DATA/MODULES/IRX/MODMIDI.IRX" ; slack 587
  reuse "/DATA/MODULES/IRX/MODSEIN.IRX" ; slack 847
  reuse "/DATA/MODULES/IRX/MODSESQ.IRX" ; slack 619
  reuse "/DATA/MODULES/IRX/PADMAN.IRX" ; slack 1307
  reuse "/DATA/MODULES/IRX/SDRDRV.IRX" ; slack 1079
  reuse "/DATA/MODULES/IRX/SIO2MAN.IRX" ; slack 1551
  reuse "/DATA/MODULES/IRX/IOPRP300.IMG" ; slack 1135
) > "${PATCHED_ISO}"

echo

echo "[*] ISO file built"

echo "[*] Cleaning temp directory"
rm -rf "${PATCHER_TEMP}"

echo "[*] Build success. Thank you for using this patcher."
echo "${PATCHED_ISO}"

