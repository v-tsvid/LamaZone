CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'       
  
  config.fog_credentials = {
    provider:              'AWS',            
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],          
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],             
    region:                ENV['ARTIFACTS_REGION']            
  }
  
  config.fog_directory  = 'v-tsvid-bucket'                    
  config.fog_public     = false                                     
  config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" }
  
  config.ignore_integrity_errors = true
  config.ignore_processing_errors = true
  config.ignore_download_errors = true
end

if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    config.storage = :fog
  end
end