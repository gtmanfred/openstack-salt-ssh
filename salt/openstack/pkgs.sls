add openstack:
  cmd.run:
    - name: zypper addrepo -f obs://Cloud:OpenStack:Ocata/openSUSE_Leap_42.2 Ocata
    - creates: /etc/zypp/repos.d/Ocata.repo
  pkg.latest:
    - name: python-openstackclient
