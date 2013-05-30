# Cookbook Name:: server-essentials
# Recipe:: default
#
# Copyright (C) 2013 Sidney Burks
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# set locales 
cookbook_file "/etc/profile.d/locales.sh" do
  source 'locales.sh'
  owner "root"
  group "root"
  mode 0755
end

include_recipe 'apt'

packages = %w(
    sudo ntp 
    build-essential autoconf automake binutils-doc bison flex g++
    libc6 help2man libtool patch debconf-utils aptitude
    subversion git-core mercurial
    curl wget vim-nox
    libncurses5-dev libssl-dev libxml2 libxml2-dev libxslt1.1 libxslt1-dev libmcrypt-dev 
    zlib1g zlib1g-dev zlibc libevent-dev 
    libbz2-dev libpcre3 libpcre3-dev libpcrecpp0 libssl0.9.8 libreadline5 libcurl4-openssl-dev
    ssl-cert screen unzip unrar-free coreutils zsh 
    python-virtualenv software-properties-common
)

packages.each do |pkg|
  package pkg
end

bash "create swapfile for nginx install" do
  user "root"
  code <<-EOH
  swapoff -a
  dd if=/dev/zero of=/swapfile bs=1024 count=1024k
  chown root:root /swapfile
  chmod 0600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  EOH
  not_if do
    File.exists?("/swapfile")
  end
end

# Activate swapfile on reboots
append_if_no_line "fstab swapfile" do
  path "/etc/fstab"
  line '/swapfile1 swap swap defaults 0 0'
end

bash "get salt repository key" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  echo deb http://ppa.launchpad.net/saltstack/salt/ubuntu `lsb_release -sc` main | sudo tee /etc/apt/sources.list.d/saltstack.list
  wget -q -O- "http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0x4759FA960E27C0A6" | sudo apt-key add -
  apt-get update
  EOH
end

# execute "yes | add-apt-repository ppa:saltstack/salt"
# apt_repository "salt-stack" do
#   uri "http://ppa.launchpad.net/saltstack/salt/ubuntu"
#   distribution node['lsb']['codename']
#   components ["main"]
#   keyserver "keyserver.ubuntu.com"
#   key "0E27C0A6"
# end

%w(salt-master salt-minion salt-syndic).each do |pkg|
  package pkg
end

# This doesn't do what I think it does...  cause i'm trying to grep of line
# locally, not on server
# line = `grep "master: salt.sid137.com" /etc/salt/minion`
# if line.empty?
#   execute 'echo "master: salt.sid137.com" >> /etc/salt/minion'
#   execute "restart salt-minion"
# end

append_if_no_line "zaliases" do
  path "/etc/salt/minion"
  line 'master: salt.sid137.com'
end
if node['lsb']['release'] == '12.10'
  execute "restart salt-minion"
elsif node['lsb']['release'] == '13.04'
  execute "service salt-minion restart"
end

include_recipe "server-essentials::security"
