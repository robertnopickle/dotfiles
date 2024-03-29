# frozen_string_literal: true

# stolen with some slight modifications from github.com/cheshire137/dotfiles

require 'rake'
require 'erb'

desc "uninstall the dotfiles from the user's home directory"
task :uninstall do
  system %(unlink ~/.gitignore)
  system %(unlink ~/.zshrc)
  system %(chsh -s /bin/bash > /dev/null 2>&1)
end

desc "install the dotfiles into the user's home directory"
task :install do
  install_oh_my_zsh
  switch_to_zsh
  replace_all = false
  files = Dir['*'] - %w[Rakefile README.md LICENSE oh-my-zsh]
  files.each do |file|
    system %(mkdir -p "$HOME/.#{File.dirname(file)}") if file =~ %r{/}
    if File.exist?(File.join(ENV['HOME'], ".#{file.sub(/\.erb$/, '')}"))
      if File.identical? file, File.join(ENV['HOME'], ".#{file.sub(/\.erb$/, '')}")
        puts "identical ~/.#{file.sub(/\.erb$/, '')}"
      elsif replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file.sub(/\.erb$/, '')}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file.sub(/\.erb$/, '')}"
        end
      end
    else
      link_file(file)
    end
  end
end

def replace_file(file)
  system %(rm -rf "$HOME/.#{file.sub(/\.erb$/, '')}")
  link_file(file)
end

def link_file(file)
  if file =~ /.erb$/
    puts "generating ~/.#{file.sub(/\.erb$/, '')}"
    File.open(File.join(ENV['HOME'], ".#{file.sub(/\.erb$/, '')}"), 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking ~/.#{file}"
    system %(ln -s "$PWD/#{file}" "$HOME/.#{file}")
  end
end

def switch_to_zsh
  if ENV['SHELL'] =~ /zsh/
    puts 'already using zsh'
  else
    print 'switch to zsh? [ynq] '
    case $stdin.gets.chomp
    when 'y'
      puts 'switching to zsh'
      system %(chsh -s `which zsh` > /dev/null 2>&1)
    when 'q'
      exit
    else
      puts 'skipping zsh'
    end
  end
end

def install_oh_my_zsh
  if File.exist?(File.join(ENV['HOME'], '.oh-my-zsh'))
    puts 'found ~/.oh-my-zsh'
  else
    print 'install oh-my-zsh? [ynq] '
    case $stdin.gets.chomp
    when 'y'
      puts 'installing oh-my-zsh'
      system %(git clone git://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh" > /dev/null 2>&1)
    when 'q'
      exit
    else
      puts 'skipping oh-my-zsh, you will need to change ~/.zshrc'
    end
  end
end
