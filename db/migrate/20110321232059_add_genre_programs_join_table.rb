class AddGenreProgramsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :genres_programs, :force => true, :id => false do |t|
      t.integer :genre_id
      t.integer :program_id
    end
  end

  def self.down
    drop_table :genres_programs
  end
end