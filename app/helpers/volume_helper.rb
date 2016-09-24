module VolumeHelper

    def volume_info(volume)
        params = ['Type', 'Volume ID', 'Status', 'Number of Bricks', 'Transport-type', 'Bricks', 'Options Reconfigured', 'Mount State', 'Mount Point']
        html = ''
        html << "<div>"
        params.each do |t|
            next if volume[t].nil?
            html << "<p>"
            html << t + " : " + volume[t]
            html << "</p>"
        end
        html << "</div>"
        raw(html)
    end
end
