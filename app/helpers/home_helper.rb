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

end
