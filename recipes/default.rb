#
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

apt_repository "salt-stack" do
  uri "http://ppa.launchpad.net/saltstack/salt/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
end

%w(salt-master salt-minion salt-syndic).each do |pkg|
  package pkg
end

append_if_no_line "salt master" do
  path "/etc/salt/minion"
  line "master: salt.sid137.com" 
end
execute "restart salt-minion"

# For password shadowing
gem_package "ruby-shadow"

# TODO: install system VIM
# https://raw.github.com/sid137/.vim/vundler/vimrc /etc/vim/vimrc
# TODO: install system shell
include_recipe "server-essentials::security"
