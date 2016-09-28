module NodeHelper
  require 'net/ping'
  def ping_test?(host)
    check = Net::Ping::External.new(host)
    check.ping?
  end
end
