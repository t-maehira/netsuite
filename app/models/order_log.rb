class OrderLog < ActiveRecord::Base
  # approved field value
  APPROVED_ACCEPT = 'accept'
  APPROVED_REJECT = 'reject'

  # NetSuiteのレコードタイプ
  TYPE_SALESORDER       = 'SALESORDER'
  TYPE_ITEMFULFILLMENT  = 'ITEMFULFILLMENT'

  VALID_TYPES = [TYPE_SALESORDER, TYPE_ITEMFULFILLMENT]
  validates :record_type, :inclusion=> { :in => VALID_TYPES }
  validates :record_id, presence: true

  # URL有効期限(日)
  APPROVE_LIMIT = 10

  #
  # selectページのrecord_type毎の文言
  #
  RECORD_LIST = {
    TYPE_SALESORDER => {
      'title' => '注文書承諾',
      'tranid_title' => '注文書',
      'button_accept' => '承諾',
      'button_reject' => '拒否'
    },
    TYPE_ITEMFULFILLMENT => {
      'title' => '納品受領確認',
      'tranid_title' => '納品書',
      'button_accept' => '確認OK',
      'button_reject' => '確認NG'
    }
  }

  #
  # NetSuite側の承諾ステータス
  #
  APPROVED_TEXT = {
    APPROVED_ACCEPT => 1, # 承諾
    APPROVED_REJECT => 2  # 拒否
  }

  #
  # NetSuite側の更新フィールドリスト
  #
  NETSUITE_UPDATE_FIELDS = {
    TYPE_SALESORDER => {
      'url' => 'custbody_so_consentscreen_url',
      'limit' => 'custbody_so_consentscreen_deadline',
      'approved' => 'custbody_so_consentstatus'
    },
    TYPE_ITEMFULFILLMENT => {
      'url' => 'custbody_ai_consentscreen_url',
      'limit' => 'custbody_ai_consentscreen_deadline',
      'approved' => 'custbody_ai_consentstatus'
    }
  }
end
