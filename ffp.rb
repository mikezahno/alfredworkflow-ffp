# frozen_string_literal: true

FFPDIR = File.join(Dir.home, 'Library', 'Application Support', 'Firefox', 'Profiles')
PROFILES = Dir.glob(File.join(FFPDIR, '*')).sort
# warn(PROFILES)

# Start the XML string that will be sent to Alfred. This just uses strings to avoid dependencies.
XML_HEAD = %(<?xml version="1.0"?>\n<items>)
XML_PROFILES = PROFILES.map do |profile|
  name = File.extname(profile).delete('.')

  # Assemble this item's XML string for Alfred. See http://www.alfredforum.com/topic/5-generating-feedback-in-workflows/
  %(
    <item uid="#{profile}" arg="#{name}">
      <title>#{name}</title>
      <subtitle>#{profile}</subtitle>
    </item>)
end.join

# Finish off and echo the XML string to Alfred.
XML_TAIL = '</items>'

puts [XML_HEAD, XML_PROFILES, XML_TAIL].join
