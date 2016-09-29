module VolumeHelper

    def volume_info(volume, index)
        params = ['Type', 'Volume ID', 'Status', 'Number of Bricks', 'Transport-type', 'Bricks', 'Options Reconfigured', 'Mount State', 'Mount Point']
        arrow = ((index == 0) ? "up" : "down")
        display = ((index != 0) ? "style='display: none;'" : "")
        lights = []
        lights << ((volume['Status'].eql? " Stopped" or volume['Status'].eql? " Created") ? "red" : "")
        lights << ((!volume['Mount State'].eql? "mounted" and volume['Status'].eql? " Started") ? "blue" : "")
        lights << ((volume['Mount State'].eql? "mounted") ? "green" : "")
        html = ''
        html << "<div class='col-md-6 col-sm-6 col-xs-12'>"
        html << "<div class='x_panel'>"
        html << "<div class='x_title'>"
        # left title
        html << "<h2>Infomation <small>#{volume['Volume Name']}</small></h2>"
        # right title
        html << "<ul class='nav navbar-right panel_toolbox'>"
        html << "<li><a class='collapse-link'>"
        html << "<i class='fa fa-chevron-#{arrow}'></i></a></li>"
        html << "<li class='dropdown'>"
        html << "<a class='dropdown-toggle' data-toggle='dropdown' role='button' aria-expanded='false'><i class='fa fa-wrench'></i></a>"
        html << "<ul class='dropdown-menu' role='menu'>"
        html << "<li><a href='#'>Settings 1</a></li>"
        html << "<li><a href='#'>Settings 2</a></li>"
        html << "</ul>"
        html << "</li>"
        html << "<li><a><i class='fa fa-circle #{lights[2]}'></i></a></li>"
        html << "<li><a><i class='fa fa-circle #{lights[1]}'></i></a></li>"
        html << "<li><a><i class='fa fa-circle #{lights[0]}'></i></a></li>"
        html << "</ul>"
        html << "<div class='clearfix'></div>"
        html << "</div>"
        html << "<div class='x_content' #{display}>"
        # left content
        html << "<div class='col-md-6 col-sm-6 col-xs-12'>"
        html << "<div style='margin: 10px'>"
        html << "<p class='text-muted font-13 m-b-30'><span class='badge bg-blue'>Volume Info</span></p>"
        # volume_info
        html << "<div>"
        params.each do |t|
            next if volume[t].nil?
            html << "<p>"
            html << t + " : " + volume[t]
            html << "</p>"
        end
        html << "</div>"
        html << "</div>"
        # buttons
        if volume["Mount State"] == "mounted"
            html << "<a class='btn btn-app' href='/volume/unmount/#{volume['Volume Name'].delete(' ')}'><i class='fa fa-upload'></i> Unmount</a>"
        elsif volume["Status"] == " Started"
            html << "<a class='btn btn-app' href='/volume/stop/#{volume['Volume Name'].delete(' ')}'>"
            html << "<i class='fa fa-pause' style='color:#d9534f;'></i>"
            html << "<p style='color:#d9534f;'>Stop</p>"
            html << "</a>"
            html << "<a class='btn btn-app' href='?volume_name=#{volume['Volume Name'].delete(' ')}#popup_mount'><i class='fa fa-download'></i> Mount</a>"
        else
            html << "<a class='btn btn-app' href='/volume/start/#{volume['Volume Name'].delete(' ')}'>"
            html << "<i class='fa fa-play' style='color:#26B99A;'></i>"
            html << "<p style='color:#26B99A;'>Start</p>"
            html << "</a>"
            html << "<a class='btn btn-app' href='/volume/delete/#{volume['Volume Name'].delete(' ')}'>"
            html << "<i class='fa fa-trash'></i> Delete"
            html << "</a>"
        end
        html << "</div>"

        # right content
        html << "<div class='col-md-6 col-sm-6 col-xs-12'>"

        if volume["Mount State"] == "mounted"
            html << "<p class='text-muted font-13 m-b-30'><span class='badge bg-green'>Uploader</span> Activated</p>"
            html << "<form action='/file_upload/#{volume['Volume Name'].delete(' ')}' method='post' enctype='multipart/form-data' class='dropzone' style='border: 1px solid #e5e5e5; height: 300px; overflow:auto;'>"
            html << "</form>"
            html << "<br/>"
        else
            html << "<p class='text-muted font-13 m-b-30'><span class='badge bg-red'>Uploader</span> Inactivated</p>"
            html << "<form style='border: 1px solid #e5e5e5; height: 300px; overflow:auto;'>"
            html << "</form>"
            html << "<br/>"
        end

        html << "</div>"
        html << "</div>"
        html << "</div>"
        html << "</div>"
        html
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
