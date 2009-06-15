class Response < ActiveRecord::Base

  hobo_model # Don't put anything above this

  belongs_to :question
  validates_presence_of :callerid, :guid
  
  fields do
    callerid :string
    guid     :string
    response :integer
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
