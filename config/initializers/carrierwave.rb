CarrierWave.configure do |config|
  if Rails.env.test?
    config.storage = :file
    config.enable_processing = true
  else
    config.after :store, :zencode
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['AWS_S3_KEY'],
      :aws_secret_access_key  => ENV['AWS_S3_SECRET'],
      :region                 => 'eu-west-1'                  # optional, defaults to 'us-east-1'
      # :host                   => 's3.example.com',             # optional, defaults to nil
      # :endpoint               => 'https://s3.example.com:8080' # optional, defaults to nil
    }
    config.fog_directory = ENV['AWS_S3_BUCKET']
    config.fog_public     = false                                   # optional, defaults to true
    config.fog_attributes = {
      'Cache-Control'=>'max-age=315576000',
      'access-control-allow-origin' => '*',
      'access-control-allow-credentials' => 'true'
    }  # optional, defaults to {}
  end
end
