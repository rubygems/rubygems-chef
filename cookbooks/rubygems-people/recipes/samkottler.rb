home = '/home/samkottler'

directory "#{home}/src" do
  owner 'samkottler'
  group 'samkottler'
end

package 'tmux' do
  action :install
end

git "#{home}/src/dotfiles" do
  repository 'https://github.com/skottler/dotfiles' do
    revision 'master'
    checkout_branch 'master'
    action :sync
    user 'samkottler'
  end
end

%w( .gitconfig .pryrc .tmux.conf .gemrc .ackrc ).each do |file|
  link "#{home}/#{file}" do
    to "#{home}/src/dotfiles/#{file}"
  end
end
