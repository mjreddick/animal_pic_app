# encoding: utf-8

class PictureUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  # if Rails.env.production?
  #   storage :fog
  # else
  #   storage :file
  # end


  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    # "uploads/pictures"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :resize_to_fit=> [700, nil]
  process :shrink_to_width => [700]
  #
  # def scale(width, height)
  #   resize width
  # end

  def shrink_to_width(width)
    manipulate! do |img|
      img.resize ">#{width}"
      img
    end
  end

  # Create different versions of your uploaded files:
  version :thumb do
    process :make_square => [160]
  end

  def make_square(size)
    #This resizes and crops the image to make it a square while maintaining aspect ratio
    manipulate! do |img|
      img.resize "#{size}x#{size}^"
      if img.width > img.height
        overflow = (img.width - size) / 2
        img.crop "#{size}x#{size}+#{overflow}+0"
      else
        overflow = (img.height - size) / 2
        img.crop "#{size}x#{size}+0+#{overflow}"
      end

      img
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   # "something.jpg" if original_filename
  #   "#{model.id}" + File.extname(original_filename)
  # end

end
