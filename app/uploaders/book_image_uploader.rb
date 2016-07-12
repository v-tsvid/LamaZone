class BookImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :fog
  process :resize_to_fit => [300, 400]

  version :thumb do
    process :resize_to_fit => [150, 200]
  end
end
