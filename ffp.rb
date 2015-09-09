theQuery = ARGV[0]

# get profiles
ffpdir = "~/Library/Application\\ Support/Firefox/Profiles/"
profiles = `ls #{ffpdir}`.split("\n")
# STDERR.puts profiles

# Start the XML string that will be sent to Alfred. This just uses strings to avoid dependencies.
xmlString = "<?xml version=\"1.0\"?>\n<items>\n"
profiles.each do | profile |
    # STDERR.puts profile
    profileClean = `echo \"#{profile}\" | grep -oEi "\\.([A-z0-9\-])+$"`.delete('.').delete("\n")

    # Assemble this item's XML string for Alfred. See http://www.alfredforum.com/topic/5-generating-feedback-in-workflows/
    thisXmlString = "\t<item uid=\"#{profile}\" arg=\"#{profileClean}\">
        <title>#{profileClean}</title>
        <subtitle>#{ffpdir}#{profile}</subtitle>
    </item>\n"

    # Append this process's XML string to the global XML string.
    xmlString += thisXmlString
end

# Finish off and echo the XML string to Alfred.
xmlString += "</items>"
puts xmlString