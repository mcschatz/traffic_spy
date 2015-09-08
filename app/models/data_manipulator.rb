class DataManipulator

  def self.column_summary(collection, column)
    collection.group(column).order('count_id DESC').count(:id).map do |column, count|
      percent = (count.to_f/collection.count * 100).round(2)
      {description: column, count: count, percent: percent}
    end
  end
end