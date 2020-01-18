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
  
  # ..
  # ..
  # FILL YOUR CODE HERE
  # ..
  # ..
  
  # To complete the assignment, implement `parse_dns` and `resolve`.
  # Remember to implement them above this line since in Ruby
  # you can invoke a function only after it is defined.

  def parse_dns(dns_raw)
    dns_raw.reject! {|i| i.start_with?"#" or i.start_with?"\n" }
    dns_records={}
    for i in dns_raw
        dns_records[i.split(",")[1].strip]=[i.split(",")[0].strip,i.split(",")[2].strip]
    end
    return dns_records
  end



def resolve dns_records,lookup_chain,domain
    if !dns_records.keys.include?domain
        puts "record not found for #{domain}"
        lookup_chain
    elsif dns_records[domain][0]=="A"
        lookup_chain.push(dns_records[domain][1])
        return lookup_chain
    elsif dns_records[domain][0]=="CNAME"
        lookup_chain.push(dns_records[domain][1])
        return resolve(dns_records, lookup_chain, dns_records[domain][1])
   end
end




  dns_records = parse_dns(dns_raw)
  lookup_chain = [domain]
  lookup_chain = resolve(dns_records, lookup_chain, domain)
  puts lookup_chain.join(" => ")