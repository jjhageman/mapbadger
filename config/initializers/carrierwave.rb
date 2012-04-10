#CarrierWave.configure do |config|
  #config.fog_credentials = {
    #:provider               => 'AWS',
    #:aws_access_key_id      => 'XXX',
    #:aws_secret_access_key  => 'YYY',
    #:region                 => 'us-east-1'  # optional, defaults to 'us-east-1'
  #}
  #config.fog_directory  = 'mapbadger'                     # required
  #config.fog_host       = 'https://beta.mapbadger.com'            # optional, defaults to nil
  #config.fog_public     = false                                   # optional, defaults to true
  #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
#end

Fog.credentials_path = Rails.root.join('config/fog_credentials.yml')

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider => 'AWS'
  }
  config.fog_directory = 'mapbadger'
end
