CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => 'AKIAIUTPUOVUPSDVIFVQ',       # required
    :aws_secret_access_key  => '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',       # required
    :region                 => 'sa-east-1'  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'dearfriend'
end