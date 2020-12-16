# frozen_string_literal: true

FFPDIR = File.join(Dir.home, 'Library', 'Application Support', 'Firefox', 'Profiles')
PROFILES = Dir.glob(File.join(FFPDIR, '*')).sort_by { |f| File.mtime(f) }
warn(PROFILES) if ENV['DEBUG']

# Start the XML string that will be sent to Alfred. This just uses strings to avoid dependencies.
XML_HEAD = %(<?xml version="1.0"?>\n<items>)
XML_PROFILES = PROFILES.reverse_each.map do |profile|
  name = File.basename(profile).split('.', 2).last
  compatibility_filename = File.join(profile, 'compatibility.ini')
  icon_dir = File.read(compatibility_filename)
               &.match(/LastPlatformDir=(?<dir>.*)/)
               &.named_captures
               &.fetch('dir', nil)
  icon_filename = File.join(icon_dir, 'firefox.icns') if icon_dir

  # Assemble this item's XML string for Alfred. See http://www.alfredforum.com/topic/5-generating-feedback-in-workflows/
  %(
    <item uid="#{profile}" arg="#{name}">
      <title>#{name}</title>
      <subtitle>#{profile}</subtitle>
      <icon>#{icon_filename}</icon>
    </item>
  )
end.join

# Finish off and echo the XML string to Alfred.
XML_TAIL = '</items>'

puts [XML_HEAD, XML_PROFILES, XML_TAIL].join
