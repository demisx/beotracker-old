# sudo groupadd deployers
# sudo useradd -G deployers deploy
# Add local user id_rsa.pub to ~/.ssh/authorized_keys on servers
# Update /etc/ssh/sshd_config file on servers to allow :user to connect

set :application, 'beotracker-com'
set :repo_url, 'git@github.com:demisx/beotracker.git'
set :deploy_to, '/home/gr/beocommedia/beotracker-com'
set :scm, :git
set :log_level, :info # :debug

# set :format, :pretty
set :pty, true
set :keep_releases, 5
set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{bin log tmp vendor/bundle public/system}

set :ssh_options, {
  forward_agent: true,
  port: 63158,
  # verbose: :debug
}

SSHKit.config.command_map[:rake]  = "bundle exec rake"
SSHKit.config.command_map[:rails] = "bundle exec rails"
SSHKit.config.command_map[:sudo]  = "sudo"

task :whoami do
  on roles(:all) do
    execute :whoami
    execute "uname -a"
  end
end

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :sudo, "service beotracker-com restart"
    end
  end

  before :restart, "db:seed"
end

namespace :db do
  desc 'Seed DB data'
  task :seed do

    on primary :db do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:seed"
        end
      end
    end
  end

  desc 'Drop DB'
  task :drop do

    on primary :db do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:drop"
        end
      end
    end
  end

  desc 'Create DB'
  task :create do

    on primary :db do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:create"
        end
      end
    end
  end
end
