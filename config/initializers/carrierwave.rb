begin
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',       # required
      :aws_access_key_id      => Setting['aws.key'],       # required
      :aws_secret_access_key  => Setting['aws.secret'],       # required
      :region                 => 'sa-east-1'  # optional, defaults to 'us-east-1'
    }
    config.fog_directory  = 'dearfriend'
  end
rescue Exception => e
  Rails.logger.warn "Error loading settings: #{e}"
end
