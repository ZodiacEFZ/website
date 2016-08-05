# Plugin to add environment variables to the `site` object in Liquid templates

module Jekyll

  class EnvironmentVariablesGenerator < Generator

    def generate(site)
      site.config['env'] = ENV['JEKYLL_ENV'] || 'development'
      site.config['build_target'] = ENV['BUILD_TARGET'] || 'QINIU'
      # Add other environment variables to `site.config` here...
    end

  end

end
