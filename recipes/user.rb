
# For password shadowing
gem_package "ruby-shadow"

cookbook_file "/etc/profile.d/aliases.sh" do
  source 'aliases.sh'
  owner "root"
  group "root"
  mode 0755
end

cookbook_file "/etc/zsh/zaliases" do
  source 'zaliases'
  owner "root"
  group "root"
  mode 0755
end

cookbook_file "/etc/zsh/zshrc.plus" do
  source 'zshrc.plus'
  owner "root"
  group "root"
  mode 0755
end

lines = [
  ". /etc/zsh/zaliases",
  ". /etc/zsh/zshrc.plus ",
  ". /etc/profile"
]

lines.each do |l|
  append_if_no_line "zaliases" do
    path "/etc/zsh/zprofile"
    line l
  end
end

# I don't know why the data_bags approach isn't working
user_account 'sid137' do
  # shell "/bin/zsh"
  password "$1$AwN5NJAI$W1DeeekfzPR5fiM91pFjQ/"
  ssh_keys [
    "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAtBpjQEcKhFhz5RWhQR4Xt3nQ1fV1ynmqQTAgjFMJmXKKlXIi074lbYjgXoW9pjKqdVgL2dLLYbLW7Pv/kUMkGvah+59JHms1/aqlwHj5U6Eo75WMynMLyStjftNRe7WYwNObp8Y4eNdkNN8gqr0ogoQzwpfckB4NscjKnrN1tcp90d/dl3UIiWGQnIklyX/pOVTmpaZ8r0+MXneDT1k89ghng4phKOrlv55cllAy98+Ck6T9PMwXk1Q9bBJAuNgjiukaxqtseV5aoOZX4wGmuzzC9mMif6UWbll/JBTrTP4PkhCgLT/ZTYfQs9s3wokj5ZWqN0e7g1yP85wI2tFbcQ== noli@Nolis-MacBook-Pro.local"
  ]
end

# Give asterisk user sudo priveledges
file "/etc/sudoers.d/sid137" do
  content "%sid137 ALL=NOPASSWD:ALL"
  mode "0440"
end
