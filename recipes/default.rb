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

packages = %w(
    sudo ntp 
    build-essential autoconf automake binutils-doc bison flex 
    libc6 help2man libtool patch debconf-utils aptitude
    subversion git-core 
    curl wget vim-nox
    libncurses5-dev libssl-dev libxml2 libxml2-dev libxslt1.1 libxslt1-dev libmcrypt-dev 
    zlib1g zlib1g-dev zlibc libevent-dev 
    libbz2-dev libpcre3 libpcre3-dev libpcrecpp0 libssl0.9.8 libreadline5 
    ssl-cert screen unzip unrar coreutils zsh 
)


packages.each do |pkg|
  package pkg
end
