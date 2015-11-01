module FilledSeven
  module Rails
    module IconHelper
      # Creates an icon tag given an icon name and possible icon
      # modifiers.
      #
      # Examples
      #
      #   f7_icon "album"
      #   # => <i class="pe-7f-album"></i>
      #
      #   f7_icon "album", class: "pull-left"
      #   # => <i class="pe-7f-album pull-left"></i>
      #
      #   f7_icon "album", data: { id: 123 }
      #   # => <i class="pe-7f-album" data-id="123"></i>
      #
      #   content_tag(:li, f7_icon("album", text: "Bulleted list item"))
      #   # => <li><i class="pe-7f-album"></i> Bulleted list item</li>
      def f7_icon(names = "album", options = {})
        classes = []
        classes.concat Private.icon_names(names)
        classes.concat Array(options.delete(:class))
        text = options.delete(:text)
        right_icon = options.delete(:right)
        icon = content_tag(:i, nil, options.merge(:class => classes))
        Private.icon_join(icon, text, right_icon)
      end

      module Private
        extend ActionView::Helpers::OutputSafetyHelper

        def self.icon_join(icon, text, reverse_order = false)
          return icon if text.blank?
          elements = [icon, ERB::Util.html_escape(text)]
          elements.reverse! if reverse_order
          safe_join(elements, " ")
        end

        def self.icon_names(names = [])
          array_value(names).map { |n| "pe-7f-#{n}" }
        end

        def self.array_value(value = [])
          value.is_a?(Array) ? value : value.to_s.split(/\s+/)
        end
      end
    end
  end
end
