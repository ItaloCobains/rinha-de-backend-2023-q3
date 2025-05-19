class Pessoa < ApplicationRecord
  validates :apelido, presence: true, uniqueness: true, length: { maximum: 32 }
  validates :nome, presence: true, length: { maximum: 100 }
  validates :nascimento, presence: true
  validate :validate_stack

  private 

  def validate_stack
    return if stack.nil?

    unless stack.is_a?(Array) && stack.all? {  it.is_a?(String) && it.length <= 32 }
      errors.add(:stack, "deve ser um vetor de strings com cada elemento de até 32 caracteres")
    end
  end
end
