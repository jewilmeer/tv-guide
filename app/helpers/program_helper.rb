module ProgramHelper
  def update_header(update)
    buffer = []
    buffer << pluralize(update.updated_program_attributes.length, 'program updates') if update.updated_program_attributes.any?
    buffer << pluralize(update.additions.length, 'new episodes') if update.additions.any?
    buffer << pluralize(update.updates.length, 'updated episodes') if update.updates.any?
    buffer.join(' / ')
  end
  
  def update_description(update)
    update_description = update.real_updates.map do |k,v|
      case k
      when :program
        v.map do |k,v|
          "<strong>#{k.humanize}</strong> changed to #{v.last}"
        end
      when :additions
        v.map do |episode|
          episode, data = episode.first
          if episode == "S01E00"
            "Special episode added"
          else
            "#{episode} - #{update.program.find_episode_information(episode)} added"
          end
        end
      when :updates
        v.map do |id, data|
          begin
            episode = update.program.episodes.find(id)
            "#{episode.full_episode_title} updated"
          rescue ActiveRecord::RecordNotFound
            'Unknown'
          end
        end
      else
        nil
      end
    end.compact
    update_description.flatten.map{|update| "#{update}" } * '<br />'
  end
end
