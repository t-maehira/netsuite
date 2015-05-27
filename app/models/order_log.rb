class OrderLog < ActiveRecord::Base
  VALID_TYPES = ['SALESORDER', 'CHECK']
  validates :record_type, :inclusion=> { :in => VALID_TYPES }
  validates :record_id, presence: true

  APPROVED_ACCEPT = 'accept'
  APPROVED_REJECT = 'reject'
  APPROVE_LIMIT = 10

  #
  # selectページのrecord_typeの文言
  #
  RECORD_LIST = {
    'SALESORDER' => {
      'title' => '注文書',
      'text' => '注文書'
    },
    'CHECK' => {
      'title' => '検収書',
      'text' => '納品書'
    }
  }

  #
  # NetSuite側の承諾ステータス
  #
  APPROVED_TEXT = {
    APPROVED_ACCEPT => 1, # 承諾
    APPROVED_REJECT => 2  # 拒否
  }

end
