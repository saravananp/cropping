class Test < ActiveRecord::Base
require 'paperclip_processors/cropper.rb'
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  has_attached_file :image,
	:styles => { :small => "50x50#", :large => "500x500>" },
        :processors => [:cropper]

  validates_attachment_presence :image
  after_update :reprocess_image, :if => :cropping?


  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def image_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file image.path(style)
  end

  private
  
  def reprocess_image
    image.reprocess!
  end
end
