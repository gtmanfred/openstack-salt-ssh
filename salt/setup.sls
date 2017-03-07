update suse:
  file.replace:
    - names:
      - /etc/zypp/repos.d/openSUSE-42.1-0.repo
      - /etc/zypp/repos.d/openSUSE-42.1-updates.repo
    - pattern: 42\.1
    - repl: 42.3

  pkg.uptodate:
    - dist_upgrade: True

fix grub:
  file.replace:
    - name: /boot/grub2/grub.cfg
    - pattern: root=/dev/hda1
    - repl: root=LABEL=ROOT

reboot:
  module.run:
    - name: system.reboot
