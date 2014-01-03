namespace :migrate do
  task program_to_network: :environment do
    Program.where.not(network_name: nil).find_each do |program|
      Network.transaction do
        network = Network.find_or_create_by name: program.network_name

        program.update_attributes({
          network_name: nil,
          network_id: network.id
        })
      end
    end
  end
end