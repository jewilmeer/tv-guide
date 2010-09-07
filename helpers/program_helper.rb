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
        buffer = '<h5>Program updates</h5><ul>'
        v.each do |k,v|
          buffer << content_tag(:li, "<strong>#{k.humanize}</strong> changed to #{v.last}")
        end
        buffer << '</ul>'
      when :additions
        buffer = '<h5>Added episodes</h5><ul>'
        v.each do |episode|
          episode, data = episode.first
          if episode == "S01E00"
            buffer << content_tag(:li, "Special episode added")
          else
            buffer << content_tag(:li, "#{episode} - #{update.program.find_episode_information(episode)} added")
          end
        end
        buffer << '</ul>'
      when :updates
        buffer = '<h5>Updated episodes</h5><ul>'
        v.map do |id, data|
          begin
            episode = update.program.episodes.find(id)
            buffer << content_tag(:li, "#{episode.full_episode_title} updated")
          rescue ActiveRecord::RecordNotFound
            buffer << content_tag(:li, 'Unknown')
          end
        end
        buffer << '</ul>'
      else
        nil
      end
    end.compact
    update_description.flatten.map{|update| "#{update}".force_encoding('utf-8') } * ''
  end
end
