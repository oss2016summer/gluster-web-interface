module HomeHelper

    def html_file_manager_table(dir = @current_dir, id = "file_manager_table", class_option = "table table-striped table-bordered jambo_table")
        html = String.new
        html << "<table id='#{id}' class='#{class_option}'>"
        html << "<thead>"
        html << "<tr class='headings'>"
        html << "<th>Name</th>"
        html << "<th>auth</th>"
        html << "<th>Size</th>"
        html << "<th>Date</th>"
        html << "</tr>"
        html << "</thead>"
        html << "<tbody id='#{id}_body'>"
        html << "<tr>"
        html << "<td>"
        html << "<a class='chupper' style='cursor: pointer'><i class='fa fa-reply'></i></a> "
        html << "<span style='line-height:0'>#{dir}</span>"
        html << "<a class='pull-right' href='#popup_mkdir'><i class='fa fa-plus'></i><i class='fa fa-folder'></i></a>"
        html << "</td>"
        html << "<td></td>"
        html << "<td></td>"
        html << "<td></td>"
        html << "</tr>"

        files(dir).each do |file|
            html << "<tr class='dir_delete'>"
            if file["auth"][0]=='d'
                html << "<td style='color:#0d8ade;'><i class='fa fa-folder-open-o'></i>"
                html << "<a class='chdir' style='cursor: pointer'> #{file['name']}</a>"
                html << "</td>"
            else
                conv_name = (dir + '/' + file['name']).gsub("/", "+")
                html << "<td><i class='fa fa-file-o'></i>"
                html << "<a href='/file_download?file_name=#{conv_name}'> #{file['name']}</a>"
                html << "</td>"
            end
            html << "<td>#{file['auth']}</td>"
            html << "<td>#{file['size']}</td>"
            html << "<td>#{file["date"]}"
            html << "<a class='pull-right rmdir' href='#'><i class='fa fa-trash'></i></a>"
            html << "</td>"
            html << "</tr>"
        end

        html << "</tbody>"
        html << "</table>"
        return html
    end

    def html_disk_usage_table(dir = @current_dir, id = "disk_usage_table")
        html = String.new
        html << "<table id='#{id}' class='' style='width:100%'>"
        html << "<tr>"
        html << "<th style='width:37%;'>"
        html << "<p>Chart</p>"
        html << "</th><th>"
        html << "<div class='col-lg-7 col-md-7 col-sm-7 col-xs-7'>"
        html << "<p class=''>Name</p></div>"
        html << "<div class='col-lg-5 col-md-5 col-sm-5 col-xs-5'>"
        html << "<p class=''>Usage</p></div>"
        html << "</th></tr>"
        html << "<tr>"
        html << "<td><canvas id='#{id}_canvas' height='140' width='140' style='margin: 15px 10px 10px 0'></canvas></td>"
        html << "<td>"
        html << "<table id='disk_usage_tile_table' class='tile_info'>"
        html << "<thead>"
        html << "<tr class='headings'>"
        html << "<th></th>"
        html << "<th></th>"
        html << "</tr>"
        html << "</thead>"
        html << "<tbody>"

        get_du(dir).each_with_index do |file, index|
            color = ['blue', 'green', 'red', 'purple', 'grey'][index % 5]
            html << "<tr><td>"
            html << "<div class='col-lg-7 col-md-7 col-sm-7 col-xs-7'>"
            html << "<p><i class='fa fa-square #{color}'></i> "
            html << file['file_name']
            html << "</p></div>"
            html << "</td><td>"
            html << "<div class='col-lg-7 col-md-7 col-sm-7 col-xs-7'>"
            html << "<p style='float:right'>"
            html << format("%.2f", file['usage']*100) + "%"
            html << "</p></div>"
            html << "</td></tr>"
        end

        html << "</tbody>"
        html << "</table>"
        html << "</td></tr>"
        html << "</table>"
        return html
    end

    def html_disk_file_table
    end
end
