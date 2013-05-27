# http://www.cyberciti.biz/tips/linux-security.html
# create non-root user
include_recipe "server-essentials::user"

# disable root login over ssh
execute "sed -i.bak 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config"

# Allow SSH agent forwarding
append_if_no_line "sshd agent forwarding" do
  path "/etc/ssh/sshd_config"
  line 'AllowAgentForwarding yes'
end

service "ssh" do
  action :restart
end

# disable telnet
#     default
# ftp, rlogin, rsh
# Password Restrictions
#   password aging?
#   password reuse
# Lock accounts after Login Failures
# no accounts with empty passwords
# no uid0 accounts
# Networking
#   IPtables
#   Check listening services
#
# Intrusion Detection System
# Backups
#   Server
#   Database
#   Logs
#
# http://www.linux-sxs.org/security/scheck.html
