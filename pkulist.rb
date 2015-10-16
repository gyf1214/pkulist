require 'json'

rules = Array.new
path = 'pkulist'
raw = File.read path
raw = raw.split /\s+/
raise unless raw.size % 3 == 0
(raw.size / 3).times do |i|
    rules.push [raw[3 * i], raw[3 * i + 2]]
end

list = JSON.dump rules

puts %{var proxy = "PROXY 127.0.0.1:1080; DIRECT;";
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
