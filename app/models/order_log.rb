class OrderLog < ActiveRecord::Base
  VALID_TYPES = ['SALESORDER', 'CHECK']
  validates :record_type, :inclusion=> { :in => VALID_TYPES }
  validates :record_id, presence: true

  APPROVED_ACCEPT = 'accept'
  APPROVED_REJECT = 'reject'
  APPROVE_LIMIT = 10

  SHEET_LIST = {
    'SALESORDER' => {
      'title' => '注文書',
      'text' => '注文書'
    },
    'CHECK' => {
      'title' => '検収書',
      'text' => '納品書'
    }
  }
end
