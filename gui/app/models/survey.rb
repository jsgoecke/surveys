class Survey < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  has_many :questions, :dependent => :destroy
  has_many :responses, :through => :questions
  validates_presence_of :name
  validates_uniqueness_of :name
  
  fields do
    name   :string
    description :text
    active :boolean
    timestamps
  end


  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
