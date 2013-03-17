CarrierWave.configure do |config|
  if Rails.env.development? or Rails.env.production?
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
      :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
      :region                 => 'us-east-1'
      # :host                   => 's3.example.com',             # optional, defaults to nil
      # :endpoint               => 'https://s3.example.com:8080' # optional, defaults to nil
    }
    config.fog_directory  = ENV['AWS_S3_BUCKET']
    config.fog_public     = false
    config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
    config.storage        = :fog
  else
    config.storage            = :file
    config.enable_processing  = false
  end
end
