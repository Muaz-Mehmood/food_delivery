class Order < ApplicationRecord
    belongs_to :user
    has_many :order_items, dependent: :destroy

    enum status: [:pending, :ready, :delivered]

    before_save :set_subtotal

    def subtotal
        order_items.collect{|order_item| order_item.valid? ? (order_item.unit_price * order_item.quantity) : 0}.sum
    end
    
    private
    def set_subtotal
        self[:subtotal] = subtotal
    end
end
