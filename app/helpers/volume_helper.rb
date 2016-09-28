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

    def mount_table(dir = @current_dir, id = "mount_table", class_option = "table table-striped table-bordered jambo_table")
        html = String.new
        html << "<table id='#{id}' class='#{class_option}'>"
        html << "<thead>"
        html << "<tr class='headings'>"
        html << "<th>Name</th>"
        html << "<th>auth</th>"
        html << "<th></th>"
        html << "</tr>"
        html << "</thead>"
        html << "<tbody id='#{id}_body'>"
        html << "<tr>"
        html << "<td>"
        html << "<a class='chupper' style='cursor: pointer'><i class='fa fa-reply'></i></a> #{@current_dir}"
        html << "</td>"
        html << "<td></td>"
        html << "<td></td>"
        html << "</tr>"

        files(dir).each do |file|
            if file["auth"][0]=='d'
                html << "<td style='color:#0d8ade;'><i class='fa fa-folder-open-o'></i>"
                html << "<a class='chdir' style='cursor: pointer'> #{file['name']}</a>"
                html << "</td>"
                html << "<td>#{file['auth']}"
                html << "</td>"
                html << "<td>"
                html << "<form data-parsley-validate>"
                html << "<input type='hidden' value='#{@current_dir}/#{file["name"]}'>"
                html << "<button type='submit' class='btn btn-primary pull-right'>select</button>"
                html << "</form>"
                html << "</td>"
                html << "</tr>"
            end
        end

        html << "</tbody>"
        html << "</table>"
        return html
    end

end
