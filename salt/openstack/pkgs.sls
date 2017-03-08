{%- if grains['os_family'] == 'RedHat' %}
centos-release-openstack-ocata:
  pkg.latest
{%- else %}
add openstack:
  cmd.run:
    - name: zypper addrepo -f obs://Cloud:OpenStack:Ocata/openSUSE_Leap_42.2 Ocata
    - creates: /etc/zypp/repos.d/Ocata.repo
{%- endif %}

python-openstackclient:
  pkg.latest
