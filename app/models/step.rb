class Step < ActiveRecord::Base
	belongs_to :record
	belongs_to :progression
  
  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |rec|
        csv << rec.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      record = find_by_id(row["id"]) || new
      parameters = ActionController::Parameters.new(row.to_hash)
      record.update(parameters.permit(:record_id, :progression_id, :updated_at, :created_at))
      record.save!
    end
  end
end
