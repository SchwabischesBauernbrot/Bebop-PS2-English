Patcher for Cowboy Bebop - Serenade of Reminiscence
===================================================

This patcher patches Cowboy Bebop - Serenade of Reminiscence with SONICMAN69's English Translation v1.0.0.
It produces the file COWBOY_BEBOP_PS2_ENGLISH_PATCHED_1.0.0.iso (sha1sum: 966e76a618608c9b84bfaf9756974fc91ef99d5d)

English translation v1.0.0

Prerequisites
-------------

- ISO dump of the original game disc (sha1sum: 3e6968ec5b83d930b9536e96f8911c7f2256c19f)
- More than 2 GB of memory (for decompression)
- More than 4 GB available disk space (for temporary files and resulting file)

Windows: You do not need anything special. 7zip and zstd are provided for your convenience in `patching_utils`.
         Please put the original ISO file and the patcher folder on the DESKTOP to prevent long file paths issues.
Linux: You need zstd. Install it using your package manager.

How to use this patcher
-----------------------

Windows:
  Drag and drop your COWBOY BEBOP ISO file onto WINDOWS_DROP_BEBOP_PS2_ISO_HERE.bat.
  The patched file "COWBOY_BEBOP_PS2_ENGLISH_PATCHED_1.0.0.iso" will appear in this directory.
  Alternative: Manual patching using command line
    .\WINDOWS_DROP_BEBOP_PS2_ISO_HERE.bat bebop.iso

Linux:
  Drag and drop your COWBOY BEBOP ISO file onto LINUX_DROP_BEBOP_PS2_ISO_HERE.sh.
  LINUX_DROP_BEBOP_PS2_ISO_HERE.sh must have executable permission (chmod +x LINUX_DROP_BEBOP_PS2_ISO_HERE.sh).
  The patched file "COWBOY_BEBOP_PS2_ENGLISH_PATCHED_1.0.0.iso" will appear in this directory.
  Alternative: Manual patching using command line
    bash LINUX_DROP_BEBOP_PS2_ISO_HERE.sh bebop.iso
