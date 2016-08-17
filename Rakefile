require 'html-proofer'

task :test do
  HTMLProofer.check_directory("./_site", {
    :disable_external => true,
    :allow_hash_href => true,
    :parallel => { :in_processes => 2 }
  }).run
end
