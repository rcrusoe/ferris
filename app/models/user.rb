class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable

  has_many :conversations, -> { order(created_at: :asc) }, dependent: :destroy

  def new?
    conversations_count == 1
  end

  # name or empty str
  def name_str
    if name?
      ' '+name
    else
      ''
    end
  end
end
