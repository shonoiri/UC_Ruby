class Main
  graf = Hash.new{|hsh,key| hsh[key] = [] }
  first_part = true
  contents = File.open("blue_airlines.txt").readlines.each do |line|

    if line.chomp.empty? then
      first_part = false
      end
   if first_part then
      {graf => line.strip}
       end
    if ! first_part then
      data = line.strip.split(",")
      vrhol = data[0]
      soused = {data[1] => data[2].to_i}
      graf[vrhol].push(soused)

    end
  end

  puts graf
end