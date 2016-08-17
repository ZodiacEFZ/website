require 'html-proofer'

task :test do
  HTMLProofer.check_directory("./_site", {
    :disable_external => true,
    :allow_hash_href => true,
    :empty_alt_ignore => true,
    :url_ignore => [/#.*/],
    :parallel => { :in_processes => 2 }
  }).run
end
