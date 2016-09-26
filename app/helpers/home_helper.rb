module HomeHelper

    def get_du(dir)
        du = Array.new
        du_each = Hash.new
        command = String.new
        avail = 0.0
        if dir.eql? "/"
            command = "sudo df /"
            s = `#{command}`.split("\n")[1].split(" ")
            avail = s[2].to_f + s[3].to_f
        else
            command << "sudo du -s #{dir}"
            begin
                avail = `#{command}`.split(" ")[0].to_f
            rescue
                # some directory is not connected
                avail = `#{command}`.split(" ")[1].to_f
            end
        end

        command = ""
        command << "sudo du -s #{dir}/*"
        puts command
        output = `#{command}`.split("\n")
        output.each do |t|
            begin
                du_each['usage'] = t.split(" ")[0].to_f / avail
                du_each['file_name'] = t.split(" ")[1].split("/").last
                du << du_each
                du_each = Hash.new
            rescue
                # directory is not connected
                du_each['usage'] = 0.0
                du_each['file_name'] = t.split(" ")[1].split("/").last.split("'")[0]
                du << du_each
                du_each = Hash.new
            end
        end
        return du
    end

    def disk_usage_table(dir = "/mnt")
        html = String.new
        html << "<table class='' style='width:100%'>"
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
        html << "<td><canvas id='canvas1' height='140' width='140' style='margin: 15px 10px 10px 0'></canvas></td>"
        html << "<td>"
        html << "<table class='tile_info'>"

        get_du(dir).each_with_index do |t, index|
            color = ['blue', 'green', 'red', 'purple', 'grey'][index % 5]
            html << "<tr><td>"
            html << "<p><i class='fa fa-square #{color}'></i>"
            html << t['file_name']
            html << "</p></td>"
            html << "<td><p>"
            html << format("%.2f", t['usage']*100) + "%"
            html << "</p></td>"
            html << "</tr>"
        end

        html << "</table>"
        html << "</td></tr>"
        html << "</table>"
        return html
    end

end
