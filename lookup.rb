def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")

def parse_dns(dns_raw)
  dns_records = {}
  dns_raw.reject { |line| line.empty? }.
    map { |line| line.split(",") }.
    reject { |record| record.length < 3 }.
    map { |record_array| record_array.map { |data_in_record| data_in_record.strip } }.
    each { |data| dns_records[data[1]] = { :type => data[0], :value => data[2] } }
  dns_records
end

def resolve(dns_records, lookup_chain, domain)
  if !dns_records.keys.include? domain
    puts "record not found for #{domain}"
    lookup_chain
  elsif dns_records[domain][:type] == "A"
    lookup_chain.push(dns_records[domain][:value])
    lookup_chain
  elsif dns_records[domain][:type] == "CNAME"
    lookup_chain.push(dns_records[domain][:value])
    resolve(dns_records, lookup_chain, dns_records[domain][:value])
  end
end

dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
