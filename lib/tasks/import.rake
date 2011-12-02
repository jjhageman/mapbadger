namespace :import do
  desc "Import regions from csv file"
  task :regions, [:filename] => :environment do |task,args|
    lines = File.new(args[:filename]).readlines
    keys = [:fipscode, :name, :coords]

    lines.each do |line|
      params = {}
      values = line.strip.split(';')
      keys.each_with_index do |key,i|
        params[key] = values[i+1].gsub( /\A"/m, "" ).gsub( /"\Z/m, "" )
      end
      # puts params
      Region.create(params)
    end
  end
end
