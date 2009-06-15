class Question < ActiveRecord::Base

  hobo_model # Don't put anything above this

  belongs_to :survey
  has_many :responses, :dependent => :destroy
  validates_presence_of :question, :order, :valid_responses
  validates_format_of :valid_responses,
                      :with => /^\d\.\.\d$/,
                      :on => :create
  
  fields do
    name      :string
    question  :text
    order     :integer
    valid_responses :string
    active    :boolean
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