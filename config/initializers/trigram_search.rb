
Rails.application.configure do
  config.after_initialize do
    if Rails.env.development? || Rails.env.production?
      begin
        ActiveRecord::Base.connection.execute("SELECT set_limit(0.2);")
        
        Rails.logger.info "Trigram similarity threshold set to 0.2"
      rescue => e
        Rails.logger.warn "Could not set trigram similarity threshold: #{e.message}"
      end
    end
  end
end
