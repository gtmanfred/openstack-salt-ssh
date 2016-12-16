set releasever:
  file.managed:
    - name: /etc/yum/vars/releasever
    - contents: 7.2.1511

comment out mirrorlist:
  file.comment:
    - name: /etc/yum.repos.d/CentOS-Base.repo
    - regex: '^mirrorlist=.*$'

uncomment baseurl:
  file.comment:
    - name: /etc/yum.repos.d/CentOS-Base.repo
    - regex: 'baseurl=.*$'
