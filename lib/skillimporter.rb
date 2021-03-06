class SkillImporter

  def initialize(filename=File.absolute_path('db/data/skills.csv'))
    @filename = filename
  end

  def import
    field_names = ['name']
    puts "Importing skills from '#{@filename}'"
    failure_count = 0
    Skill.transaction do
      File.open(@filename).each do |line|
        data = line.chomp.split(',')
        attribute_hash = Hash[field_names.zip(data)]
        begin
          Skill.create!(attribute_hash)
          print '.'
        rescue ActiveRecord::UnknownAttributeError
          failure_count += 1
          print '!'
        ensure
          STDOUT.flush
        end
      end
    end
    failures = failure_count > 0 ? "(failed to create #{failure_count} student records)" : ''
    puts "\nDONE #{failures}\n\n"
  end

end
