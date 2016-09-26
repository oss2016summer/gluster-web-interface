module ApplicationHelper

    def get_df
        df = Array.new
        df_each = Hash.new
        command = String.new
        command << "df -hP"
        puts command
        output = `#{command}`.split("\n")
        output.each do |t|
            next if t.equal? output.first
            begin
                s = t.split(' ')
                df_each['Filesystem'] = s[0]
                df_each['Size'] = s[1]
                df_each['Used'] = s[2]
                df_each['Avail'] = s[3]
                df_each['Use%'] = s[4]
                df_each['Mounted on'] = s[5]
                df << df_each
                df_each = Hash.new
            rescue => ex
                puts ex
            end
        end
        return df
    end

    def volumes
        volumes = Array.new
        volume = Hash.new
        node = Node.take
        df = get_df
        # error check : node is nil
        if node.nil?
            return volumes
        end
        command = String.new
        command << "sshpass -p#{node.user_password} ssh #{node.user_name}@#{node.host_ip} gluster volume info"
        puts command
        output = `#{command}`.split("\n")
        output << "\n"
        output.each do |t|
            next if t.equal? output.first
            if t.include? ":"
                temp = t.split(":")
                volume[temp[0]] = temp[1]
            else
                volume['Mount State'] = "unmounted"
                df.each do |u|
                    next if !u['Filesystem'].include? volume['Volume Name'].delete(' ')
                    volume['Mount State'] = "mounted"
                    volume['Mount Point'] = u['Mounted on']
                end
                volumes << volume
                volume = Hash.new
            end
        end
        return volumes
    end

    def files(dir)
        files = Array.new
        file = Hash.new
        command = String.new
        command << "ls #{dir} -l"
        puts command
        output = `#{command}`.split("\n")
        output.each do |t|
            next if t.equal? output.first
            begin
                s = t.split(" ")
                file["auth"] = s[0]
                file["size"] = s[4]
                file["date"] = s[5] + " " + s[6] + " " + s[7]
                file["name"] = s[8]
                files << file
                file = Hash.new
            rescue => ex
                puts ex
            end
        end
        return files
    end

    def file_manager_table(dir = "/mnt", id = "datatable", class_option = "table table-striped table-bordered jambo_table")
        html = String.new
        html << "<table id='" + id + "' class='" + class_option + "'>"

        html << "<thead>"
        html << "<tr class='headings'>"
        html << "<th>Name</th>"
        html << "<th>auth</th>"
        html << "<th>Size</th>"
        html << "<th>Date</th>"
        html << "</tr>"
        html << "</thead>"

        html << "<tbody id='" + id + "_body'>"
        html << "<tr>"
        html << "<td>"
        html << "<a style='cursor: pointer' onclick='change_upper(" + "\"" + dir + "\"" + ")'><i class='fa fa-reply'></i></a>"
        html << " " + dir
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
                html << "<a style='cursor: pointer' onclick='change_directory(" + "\"" + dir + "/" + file['name'] + "\"" + ")'> " + file['name'] + "</a>"
                html << "</td>"
            else
                html << "<td><i class='fa fa-file-o'></i>"
                html << "<a href='/file_download?file_name=" + (dir + '/' + file['name']).gsub("/", "+") + "'> " + file['name'] + "</a>"
                html << "</td>"
            end
            html << "<td>" + file['auth'] + "</td>"
            html << "<td>" + file['size'] + "</td>"
            html << "<td>"
            html << file["date"]
            html << "<a class='pull-right' onclick='delete_file(" + "\"" + dir + "/" + file["name"] + "\"" + ")' href='#'><i class='fa fa-trash'></i></a>"
            html << "</td>"
            html << "</tr>"
        end

        html << "</tbody>"
        html << "</table>"
        return html
    end
end
