require 'redcarpet'

module Jekyll

    module QuoteBlock
      def block_quote(quote)
          "<blockquote class=\"blockquote\">" + quote + "</blockquote>"
      end
    end

    class Converters::Markdown::CustomRedcarpetParser < Jekyll::Converters::Markdown::RedcarpetParser
        def class_with_proper_highlighter(highlighter)
          Class.new(Redcarpet::Render::HTML) do
            case highlighter
            when "pygments"
              include WithPygments
            when "rouge"
              Jekyll::External.require_with_graceful_fail(%w(
                rouge rouge/plugins/redcarpet
              ))

              unless Gem::Version.new(Rouge.version) > Gem::Version.new("1.3.0")
                abort "Please install Rouge 1.3.0 or greater and try running Jekyll again."
              end

              include Rouge::Plugins::Redcarpet
              include CommonMethods
              include WithRouge
            else
              include WithoutHighlighting
            end

            include QuoteBlock
          end
        end
    end
end
