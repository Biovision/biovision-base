namespace :metrics do
  desc 'Collect new data for metrics'
  task update: :environment do
    Metric.register("#{User.table_name}.count", User.count)
    Metric.register("#{Token.table_name}.count", Token.count)
  end
end
