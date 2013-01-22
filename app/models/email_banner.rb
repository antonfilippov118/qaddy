class EmailBanner < ActiveRecord::Base
  belongs_to :webstore

  attr_accessible :active
  attr_accessible :comment
  attr_accessible :banner # paperclip attachment

  has_attached_file :banner, 
    styles: { thumb: '200x100>', small: '360x180>', medium: '560x280>', big: '780x390>' },
    path: "emailheader/:attachment/:id/:style-:hash.:extension",
    :hash_secret => "e663bea571b13acab7309279469ca6a9",
    s3_permissions: :public_read

  validates :banner, :attachment_presence => true  


end
