CarrierWave.configure do |config|
  # config.storage = :file
  if Rails.env.test?
    config.storage = :file
    config.enable_processing = true
  else
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['AWS_S3_KEY'],
      :aws_secret_access_key  => ENV['AWS_S3_SECRET'],
      :region                 => 'eu-west-1'  # optional, defaults to 'us-east-1'
    }
    config.asset_host     = "http://#{ENV['AWS_S3_BUCKET']}.s3.amazonaws.com"
    config.fog_directory  = ENV['AWS_S3_BUCKET']
    config.fog_public     = true
    config.fog_attributes = {
      'Cache-Control'=>'max-age=315576000'
      # 'access-control-allow-origin' => '*',
      # 'access-control-allow-credentials' => 'true'
    }
  end
end
