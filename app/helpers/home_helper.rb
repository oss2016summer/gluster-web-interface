module HomeHelper

    def get_du(dir)
        du = Array.new
        du_each = Hash.new
        command = String.new
        if dir.eql? "/"
            command = "sudo df /"
            s = `#{command}`.split("\n")[1].split(" ")
            avail = s[2].to_f + s[3].to_f
        else
            command << "sudo du -s #{dir}"
            avail = `#{command}`.split(" ")[0].to_f
        end

        command << "sudo du -s #{dir}/*"
        puts command
        output = `#{command}`.split("\n")
        output.each do |t|
            du_each['usage'] = t.split(" ")[0].to_f / avail
            du_each['file_name'] = t.split(" ")[1].split("/").last
            du << du_each
            du_each = Hash.new
        end
        return du
    end

end
