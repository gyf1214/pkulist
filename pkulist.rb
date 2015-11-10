require 'json'

rules = Array.new
path = 'pkulist'
raw = File.read path
raw = raw.split /\s+/
raise unless raw.size % 3 == 0
(raw.size / 3).times do |i|
    rules.push [raw[3 * i], raw[3 * i + 2]]
end

ARGV[0] ||= 's'

if ARGV[0] == 's'
  list = JSON.dump rules
  puts %{var proxy = "SOCKS5 127.0.0.1:1080; SOCKS 127.0.0.1:1080; DIRECT;";
var direct = "DIRECT;"
var rules = #{list};

function FindProxyForURL(url, host) {
    for (var i = 0; i < rules.length; i++) {
        if (isInNet(host, rules[i][0], rules[i][1])) {
            return direct;
        }
    }
    return proxy;
}
}
elsif ARGV[0] == 'l'
  rules.each do |r|
    ones = r[1].split('.').map do |x|
      8 - Math.log(256 - x.to_i, 2).floor
    end
    puts "#{r[0]}/#{ones.inject(0, &:+)}"
  end
end
