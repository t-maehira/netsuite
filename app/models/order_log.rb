class OrderLog < ActiveRecord::Base
  VALID_TYPES = ['order', 'check']
  validates :type , :inclusion=> { :in => VALID_TYPES }
  validates :order_id , presence: true

  SHEET_LIST = {
    'order' => {
      'title' => '注文書',
      'text' => '注文書'
    },
    'check' => {
      'title' => '検収書',
      'text' => '納品書'
    }
  }
end
