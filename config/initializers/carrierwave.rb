CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAIGOSLFRML62BDFLQ',
    :aws_secret_access_key  => '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',
    :region                 => 'us-east-1'  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'mapbadger'                     # required
  config.fog_host       = 'https://beta.mapbadger.com'            # optional, defaults to nil
  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end
