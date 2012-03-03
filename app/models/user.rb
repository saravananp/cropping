class User < ActiveRecord::Base

attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
has_attached_file :picture,
	:styles => { :small => "50x50#", :large => "500x500>" }
validates_attachment_presence :picture
after_update :reprocess_picture, :if => :cropping?


def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
end

  def picture_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file picture.path(style)
  end

  private
  
  def reprocess_picture
    picture.reprocess!
  end

end
