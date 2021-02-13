class User < ApplicationRecord
  include AASM
  validates :name, :status, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email invalid" },
                              uniqueness: { case_sensitive: false },
                              presence: true,
                              length: { minimum: 4, maximum: 254 }

  aasm column: 'status' do
    state :new, initial: true
    state :paid
    state :cancelled

    event :pay do
      transitions from: :new, to: :paid
    end

    event :cancel do
      transitions from: :paid, to: :cancelled
    end
  end
end
